import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  email: string;
}

interface UserEmailAlreadyExistsExceptionInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'The user with given email {{email}} already exists';

export class UserEmailAlreadyExistsException extends BadRequestException {
  constructor(error?: UserEmailAlreadyExistsExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_EMAIL_ALREADY_EXISTS, error), description);
  }
}
