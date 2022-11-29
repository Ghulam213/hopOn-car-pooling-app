import { BadRequestException } from '@nestjs/common';
import { ErrorCodeEnum } from 'src/library/enums';
import { prepareError } from 'src/library/exception/utils';

interface InvalidUUIDInputExceptionInterface {
  message: string;

  variables?: Record<any, never>;
}

const defaultMessage = 'Provided argument should have been a valid uuid';

export class InvalidUUIDInputException extends BadRequestException {
  constructor(
    error?: InvalidUUIDInputExceptionInterface,
    description?: string,
  ) {
    super(
      prepareError(defaultMessage, ErrorCodeEnum.INVALID_UUID, error),
      description,
    );
  }
}
