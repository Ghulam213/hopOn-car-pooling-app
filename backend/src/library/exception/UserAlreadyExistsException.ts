import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  phone: string;
}

interface UserEmailAlreadyExistsExceptionInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'The user with given phone {{phone}} already exists';

export class UserAlreadyExistsException extends BadRequestException {
  constructor(error?: UserEmailAlreadyExistsExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_ALREADY_EXISTS, error), description);
  }
}
