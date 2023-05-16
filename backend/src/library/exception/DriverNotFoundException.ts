import { NotFoundException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface VariablesInterface {
  id?: string;
  userId?: string;
}

interface DriverNotFoundExceptionInterface {
  message?: string;
  variables: VariablesInterface;
}

const defaultMessage = 'Driver with id {{id}} or userId {{userId}} not found';

export class DriverNotFoundException extends NotFoundException {
  constructor(error: DriverNotFoundExceptionInterface, description?: string) {
    super(prepareError(defaultMessage, ErrorCodeEnum.DRIVER_NOT_FOUND, error), description);
  }
}
