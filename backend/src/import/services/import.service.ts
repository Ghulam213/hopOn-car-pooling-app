import * as csv from 'csvtojson';
import * as fs from 'fs';
import * as path from 'path';

import { Injectable } from '@nestjs/common';
import { createSpinner } from 'nestjs-console';
import { PrismaService } from 'src/prisma/services';

const entityDependencies = {
  user: [],
  driver: ['user'],
  passenger: ['user'],
  ride: ['driver'],
  vehicle: ['driver'],
};

@Injectable()
export class ImportService {
  constructor(private prismaService: PrismaService) {}

  async importEntities(directory: string, flush: boolean = true): Promise<void> {
    try {
      const spin = createSpinner();

      const entities = [];
      spin.start('Reading files from directories');
      const files = fs.readdirSync(directory);
      spin.succeed('Files loaded');

      files.forEach((file) => {
        spin.start(`Loading ${file}`);
        const extension = path.extname(file);
        const entityName = path.basename(file, extension);
        if (!this.prismaService[entityName]) {
          spin.fail(`Wrong entity given ${entityName} please check the seed data and try again`);
          return 0;
        }
        entities[file] = entityName;
        spin.succeed(`${file} Loaded for ${entityName}`);
      });

      const savedEntities = [];

      const sortedEntities = this.sortEntities(entities);

      if (flush) {
        spin.start('Removing existing data');
        await this.removeEntities(sortedEntities);
        spin.succeed('Existing data removed');
      }

      const keys = Object.keys(sortedEntities);
      for (const key of keys) {
        try {
          const entity = entities[key];
          const fileDirectory = `${directory}/${key}`;
          spin.start(`Reading ${entity} started`);
          const data = await csv({ flatKeys: true }).fromFile(fileDirectory);
          if (data.length === 0) {
            for (let i = 0; i < 100; i++) {
              data.push({});
            }
          }
          const treatedData = this.castData(data);
          spin.succeed(`Reading ${entity} done`);
          spin.start('Seeding database with new data');
          const newEntities = await this.prismaService[entity]?.createMany({ data: treatedData, skipDuplicates: true });
          savedEntities[entity] = newEntities;
          spin.succeed('Seeding done');
        } catch (error) {
          console.error('The detailed error while reading and seeding the database is', error);
          const errorMessage = `Error reading ${key}, error: ${error}`;
          spin.fail(errorMessage);
          throw new Error(errorMessage);
        }
      }
      console.log('The saved entities are', savedEntities);
      return;
    } catch (err) {
      console.error('The error while importing Entities is', err);
      throw new Error(err);
    }
  }

  async flushAllEntities(): Promise<void> {
    try {
      const spin = createSpinner();

      const entities = [];
      Object.keys(entityDependencies).forEach((entity) => (entities[entity] = entity));
      const sortedEntities = this.sortEntities(entities);
      spin.start('Removing existing data');
      await this.removeEntities(sortedEntities);
      spin.succeed('Existing data removed');

      return;
    } catch (err) {
      console.error('The error while importing Entities is', err);
      throw new Error(err);
    }
  }

  private async removeEntities(entities: Record<string, unknown>[]): Promise<void> {
    const keys = Object.keys(entities).reverse();
    for (const key of keys) {
      const entity = entities[key];
      console.log(`Removing ${entity}`);
      const deletedEntities = await this.prismaService[entity]?.deleteMany({});
      console.log(`Removed ${entity}, ${deletedEntities.count} entities`);
    }
  }

  private castData(data: Record<string, unknown>[]): Record<string, unknown>[] {
    return data.map((item) => {
      Object.keys(item).forEach((key) => {
        const [keyName, keyType] = key.split(':');
        const value = item[key];
        if (keyType === 'number') {
          delete item[key];
          item[keyName] = Number(value);
        }
        if (keyType === 'boolean') {
          delete item[key];
          item[keyName] = Boolean(value);
        }
      });
      return item;
    });
  }

  // [
  //   {'user.csv': 'user'},
  // ]

  private sortEntities(entities: Record<string, unknown>[]): Record<string, unknown>[] {
    const sortedEntities = [];
    const results = [];
    const keys = Object.keys(entities);

    let count = 0;

    while (Object.keys(entities).length !== Object.keys(sortedEntities).length && count < 100) {
      count++;
      keys.forEach((key) => {
        const entity = entities[key];

        if (sortedEntities.includes(entity)) {
          return;
        }

        const dependencies = entityDependencies[entity];
        if (dependencies.length === 0) {
          sortedEntities.push(entity);
          results[key] = entity;
          return;
        }

        if (dependencies.every((d) => sortedEntities.includes(d))) {
          sortedEntities.push(entity);
          results[key] = entity;
          return;
        }
      });
    }

    return results;
  }
}
