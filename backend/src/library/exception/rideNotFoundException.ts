import { NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  rideId?: string;
}

interface RideNotFoundExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'Ride with id {{rideId}} not found';

export class RideNotFoundException extends NotFoundException {
  constructor(error: RideNotFoundExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.RIDE_NOT_FOUND, error), description);
  }
}
