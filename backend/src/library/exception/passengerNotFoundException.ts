import { NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id?: string;
}

interface PassengerNotFoundExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'User with id {{id}} or userId {{userId}} not found';

export class PassengerNotFoundException extends NotFoundException {
  constructor(error: PassengerNotFoundExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.NOTIFICATION_NOT_SENT, error), description);
  }
}
