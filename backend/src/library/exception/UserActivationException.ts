import { ConflictException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id: string;
  status: string;
}

interface UserActivationExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'User with id {{id}} is already {{status}}';

export class UserActivationException extends ConflictException {
  constructor(error: UserActivationExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_UPDATE_ACTIVE_STATUS_FAILED, error), description);
  }
}
