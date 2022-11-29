import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  details: string;
}

interface UserInvalidTokenExceptionInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'Token is not valid';

export class UserInvalidTokenException extends BadRequestException {
  constructor(error?: UserInvalidTokenExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_INVALID_TOKEN, error), description);
  }
}
