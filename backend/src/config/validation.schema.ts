import * as Joi from 'joi';

export const validationSchema = Joi.object({
  DATABASE_URL: Joi.string()
    .uri()
    .default('postgres://roqone:roqone@localhost/roqone_dev'),
});
