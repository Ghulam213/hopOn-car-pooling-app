import { NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id: string;
}

interface UserNotFoundExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'User with id {{id}} not found';

export class UserNotFoundException extends NotFoundException {
  constructor(error: UserNotFoundExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_NOT_FOUND, error), description);
  }
}
