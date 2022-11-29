import { Injectable } from '@nestjs/common';
import Handlebars from 'handlebars';

export interface LocalizedDtoInterface {
  locales: LocalizationInterface[];
}

export interface LocalizationInterface {
  locale: string;
}

@Injectable()
export class UtilityService {
  public static compileHandleBarTemplate(
    content: string,
    contentVars: any,
  ): string {
    const template = Handlebars.compile(content);
    return template(contentVars);
  }
}
