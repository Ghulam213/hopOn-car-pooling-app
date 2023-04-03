import { NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id: string;
}

interface PassengerNotFoundExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'Passenger with id {{id}} not found';

export class PassengerNotFoundException extends NotFoundException {
  constructor(error: PassengerNotFoundExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.PASSENGER_NOT_FOUND, error), description);
  }
}
