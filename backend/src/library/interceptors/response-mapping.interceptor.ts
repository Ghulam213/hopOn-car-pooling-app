import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ResponseModel } from 'src/library/models';

@Injectable()
export class ResponseMappingInterceptor<T> implements NestInterceptor<T, ResponseModel<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<ResponseModel<T>> {
    return next.handle().pipe(map((data) => ({ data })));
  }
}
