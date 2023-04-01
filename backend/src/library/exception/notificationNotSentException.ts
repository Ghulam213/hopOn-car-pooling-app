import { NotFoundException, InternalServerErrorException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id?: string;
}

interface NotificationNotSentExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'Notification not sent to user with id: {{id}}';

export class NotificationNotSentException extends InternalServerErrorException {
  constructor(error: NotificationNotSentExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.PASSENGER_NOT_FOUND, error), description);
  }
}
