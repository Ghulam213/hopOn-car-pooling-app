import { BadRequestException, NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  rideId?: string;
}

interface RideNotAvailableExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'Ride with id {{rideId}} is not available';

export class RideNotAvailableException extends BadRequestException {
  constructor(error: RideNotAvailableExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.RIDE_NOT_AVAILABLE, error), description);
  }
}
