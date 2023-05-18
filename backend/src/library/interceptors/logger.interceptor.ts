import { CallHandler, ExecutionContext, Injectable, Logger, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
    private readonly logger = new Logger('Request');

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const request = context.switchToHttp().getRequest();
        const { method, url, body, query } = request;

        this.logIncomingRequest(method, url, body, query);

        return next.handle().pipe(
            tap(response => {
                const { statusCode } = context.switchToHttp().getResponse();

                this.logResponse(statusCode, response);
            }),
        );
    }

    private logIncomingRequest(method: string, url: string, body: any, query: any): void {
        const reqObj = {
            method,
            url
        }
        if (body) {
            reqObj['body'] = body;
        }
        if (query) {
            reqObj['query'] = query;
        }
        this.logger.log(`\nRequest:\n${JSON.stringify(reqObj)}`);
    }

    private logResponse(statusCode: number, response: any): void {
        const resObj = {
            statusCode,
        }
        if (response) {
            resObj['response'] = response;
        }
        this.logger.log(`\nResponse:\n${JSON.stringify(resObj)}`);
    }
}
