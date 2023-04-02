import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { applicationConfig } from 'src/config';
import { UserService } from 'src/user/services';
import * as bcrypt from 'bcrypt';
import { ConfirmRegisterDto, LoginDto, RegisterDto, ResendOptDto } from 'src/auth/dto';
import { CognitoIdentityServiceProvider } from 'aws-sdk';
import { InjectAwsService } from 'nest-aws-sdk';
import { CurrentModeEnum, User } from '@prisma/client';
import {
  UnauthorizedException,
  UserAlreadyExistsException,
  UserIncorrectLoginCredentialsException,
} from 'src/library/exception';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { SessionModel } from 'src/auth/models';
import { UserEntity } from 'src/user/entities';
import { uuid } from 'uuidv4';
import { PrismaService } from 'src/prisma/services';

@Injectable()
export class AuthService {
  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
    @InjectAwsService(CognitoIdentityServiceProvider)
    private readonly congnitoService: CognitoIdentityServiceProvider,
    private readonly userService: UserService,
    private readonly logger: Logger,
    private readonly jwtService: JwtService,
    private readonly prismaService: PrismaService,
  ) {}

  async register(registerDto: RegisterDto): Promise<UserEntity> {
    const { phone, password, ...restOfRegisterData } = registerDto;
    const hashedPassword = await this.hashPassword(password);

    try {
      const results = await this.congnitoService
        .signUp({
          Username: phone,
          Password: password,
          ClientId: this.appConfig.cognitoClientId,
        })
        .promise();

      const userServiceResult = await this.userService.createUser({
        ...restOfRegisterData,
        phone,
        password: hashedPassword,
        currentMode: CurrentModeEnum.PASSENGER,
        coginitoId: results.UserSub,
        passenger: {
          create: {},
        },
      });

      this.logger.log(results);
      delete userServiceResult.password;
      return userServiceResult;
    } catch (error) {
      this.logger.error(JSON.stringify(error));
      if (error.statusCode === 400) {
        // this means cognito call failed.
        if (error.code === 'UsernameExistsException') {
          throw new UserAlreadyExistsException({ variables: { phone } });
        }

        throw error;
      }
      // if we come here that mean db call failed.
      await this.congnitoService
        .adminDisableUser({ UserPoolId: this.appConfig.cognitoUserPoolId, Username: phone })
        .promise();
      await this.congnitoService
        .adminDeleteUser({ UserPoolId: this.appConfig.cognitoUserPoolId, Username: phone })
        .promise();
      throw error;
    }
  }

  async verifyOTP(confirmRegisterData: ConfirmRegisterDto): Promise<SessionModel> {
    const { phone, code } = confirmRegisterData;

    const user = await this.userService.findUser({ phone });

    const result = await this.congnitoService
      .confirmSignUp({
        ClientId: this.appConfig.cognitoClientId,
        ConfirmationCode: code,
        Username: phone,
      })
      .promise();
    this.logger.log(result);
    this.userService.updateUser({ where: { phone }, data: { active: true, verified: true, optedInAt: true } });
    return this.processLogin(user);
  }

  async resendOTP(resendOtpDto: ResendOptDto): Promise<boolean> {
    const { phone } = resendOtpDto;

    await this.userService.findUser({ phone });

    const result = await this.congnitoService
      .resendConfirmationCode({ ClientId: this.appConfig.cognitoClientId, Username: phone })
      .promise();
    this.logger.log(result);
    this.userService.updateUser({ where: { phone }, data: { active: true, verified: true, optedInAt: true } });
    return true;
  }

  async login(credentials: LoginDto): Promise<SessionModel> {
    const user = await this.prismaService.user.findUnique({
      where: { phone: credentials.phone },
    });

    if (!user) {
      throw new UserIncorrectLoginCredentialsException();
    }

    const valid = user && (await this.comparePassword(credentials.password, user.password));
    const isConfirmed = user?.verified;
    const { active: isActive } = user || {};

    if (!user || !valid || !isConfirmed || !isActive) {
      throw new UserIncorrectLoginCredentialsException();
    }

    return this.processLogin(user);
  }

  public async rotateRefreshToken(refreshToken: string): Promise<SessionModel> {
    try {
      const { secret } = this.appConfig.jwt.refresh;
      const payload = await this.jwtService.verifyAsync(refreshToken, { secret });
      const user = await this.userService.findUser({ id: payload.id });
      return this.processLogin(user);
    } catch (error) {
      // if any error occurs, we want to throw unauthorized exception because that all a user has to know.
      throw new UnauthorizedException({ variables: { message: 'This action is unauthorized' } });
    }
  }

  private async processLogin(user: User): Promise<SessionModel> {
    const refreshToken = await this.createRefreshToken(user);
    const accessToken = await this.createAccessToken(user);

    return {
      accessToken,
      refreshToken,
      userId: user.id,
    };
  }

  public createRefreshToken(user: User): Promise<string> {
    const { expiresIn, secret } = this.appConfig.jwt.refresh;
    const options: JwtSignOptions = { expiresIn, secret };
    const payload = { id: user.id, validTill: new Date(Date.now() + expiresIn).getTime() };
    return this.jwtService.signAsync(payload, options);
  }

  public createAccessToken(user: User): Promise<string> {
    const { expiresIn, secret } = this.appConfig.jwt.access;
    const options: JwtSignOptions = { expiresIn, secret };
    const payload = { id: user.id, cognitoId: user.coginitoId };
    return this.jwtService.signAsync(payload, options);
  }

  public comparePassword(attempt: string, password: string): Promise<boolean> {
    return bcrypt.compare(attempt, password);
  }

  public hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }

  /*
   * Generate an API key by taking two pieces of information:
   * 1. User ID to guarantee uniqueness
   * 2. Enough random bits to pad out the key
   *
   * Sign them using a private secret.
   */
  public generateUserApiKey(): string {
    const secret = this.appConfig.apiKey.secret;
    const payload = {
      uuid: uuid(),
    };
    return this.jwtService.sign(payload, { secret });
  }

  /*
   * Verify the API key by checking the signature and
   * the serial number.
   */
  public verifyUserApiKey(apiKey: string) {
    const secret = this.appConfig.apiKey.secret;
    try {
      const payload = this.jwtService.verify(apiKey, { secret });
      return payload.uuid;
    } catch (error) {
      throw new UnauthorizedException({ variables: { message: 'This action is unauthorized' } });
    }
  }

  // private async sendConfirmationEmail(user: UserEntity): Promise<void> {
  //   const confirmMailToken = await this.platformUserClientService.createUserValidateEmailToken({
  //     userToken: { userId: user.roqIdentifier },
  //   });
  //   const { email, locale, firstName, lastName } = user;
  //   const confirmMailPayload: MailSendDto = {
  //     subject: 'Confirm Email',
  //     mailType: MailTypeEnum.CONFIRM_MAIL,
  //     entities: [{ uuid: user.roqIdentifier, type: 'user' }],
  //     directlyInjectedVariables: JSON.stringify({ ...omit(user, 'password'), token: confirmMailToken.token }),
  //     recipients: {
  //       nonUsers: [
  //         {
  //           email,
  //           locale,
  //           firstName,
  //           lastName,
  //         },
  //       ],
  //       allUsers: false,
  //     },
  //   };
  //   await this.platformMailClientService.sendMail(confirmMailPayload);
  // }
}
