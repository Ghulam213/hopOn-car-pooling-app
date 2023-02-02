import { Logger, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from 'src/auth/controllers';
import { AuthService } from 'src/auth/services';
import { UserModule } from 'src/user';
import { PassportModule } from '@nestjs/passport';
import { AccessTokenStrategy, ApiKeyStrategy, RefreshTokenStrategy } from 'src/auth/guards';
import { PrismaModule } from 'src/prisma';

@Module({
  imports: [UserModule, JwtModule.register({}), PassportModule, PrismaModule],
  providers: [AuthService, Logger, AccessTokenStrategy, RefreshTokenStrategy, ApiKeyStrategy],
  exports: [AuthService],
  controllers: [AuthController],
})
export class AuthModule {}
