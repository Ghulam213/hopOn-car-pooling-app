import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  details: string;
}

interface UserIncorrectEmailPasswordExceptionInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'The phone number or password you entered are not correct';

export class UserIncorrectLoginCredentialsException extends BadRequestException {
  constructor(error?: UserIncorrectEmailPasswordExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_INCORRECT_LOGIN_CREDENTIALS, error), description);
  }
}
