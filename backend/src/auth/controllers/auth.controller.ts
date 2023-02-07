import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { UserEntity } from 'src/user/entities';
import { ConfirmRegisterDto, LoginDto, RefreshTokenDto, RegisterDto, ResendOptDto } from 'src/auth/dto';
import { AuthService } from 'src/auth/services';
import { SessionModel } from 'src/auth/models';
import { RefreshTokenGuard } from 'src/auth/guards/refreshToken.guard';

@Controller()
@ApiTags('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/register')
  @ApiOkResponse({ type: UserEntity })
  async registerUser(@Body() registerData: RegisterDto): Promise<UserEntity> {
    return this.authService.register(registerData);
  }

  @Post('/login')
  @ApiOkResponse({ type: SessionModel })
  async loginUser(@Body() loginData: LoginDto): Promise<SessionModel> {
    return this.authService.login(loginData);
  }

  @UseGuards(RefreshTokenGuard)
  @Post('/refresh-token')
  @ApiOkResponse({ type: SessionModel })
  @ApiHeader({
    name: 'Authorization',
    description: 'Bearer <refresh_token>',
  })
  async refreshToken(@Body() refreshTokenData: RefreshTokenDto): Promise<SessionModel> {
    return this.authService.rotateRefreshToken(refreshTokenData.refreshToken);
  }

  @Post('/verify-register')
  @ApiOkResponse({ type: SessionModel })
  async verfiyRegister(@Body() confirmRegisterData: ConfirmRegisterDto): Promise<SessionModel> {
    return this.authService.verifyOTP(confirmRegisterData);
  }

  @Post('/resend-otp')
  @ApiOkResponse({ type: Boolean })
  async resendOTP(@Body() resendOtpData: ResendOptDto): Promise<boolean> {
    return this.authService.resendOTP(resendOtpData);
  }
}
