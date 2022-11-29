import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  details: string;
}

interface UserEmailNotProvidedExceptionInterface {
  message?: string;
  variables?: VariablesInterface;
}

const defaultMessage = 'No email provided';

export class UserEmailNotProvidedException extends BadRequestException {
  constructor(error?: UserEmailNotProvidedExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.USER_EMAIL_NOT_PROVIDED, error), description);
  }
}
