import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  details: string;
}

interface UserInvalidCurrentPasswordInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'Invalid current password';

export class UserInvalidCurrentPasswordException extends BadRequestException {
  constructor(error?: UserInvalidCurrentPasswordInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_INVALID_CURRENT_PASSWORD, error), description);
  }
}
