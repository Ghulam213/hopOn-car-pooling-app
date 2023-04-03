import { Command, Console, CreateCommandOptions, createSpinner } from 'nestjs-console';
import * as csv from 'csvtojson';
import * as fs from 'fs';
import * as path from 'path';
import { PrismaService } from 'src/prisma/services';

const entityDependencies = {
  user: [],
  driver: ['user'],
  passenger: ['user'],
  ride: ['driver'],
  vehicle: ['driver'],
};

@Console()
export class ImportConsole {
  constructor(private prismaService: PrismaService) {}

  @Command({
    command: 'import-entities',
    description: 'Seed database with entities',
    options: [
      {
        required: false,
        flags: '--flush',
      },
    ],
  })
  async importEntities(options: CreateCommandOptions & { flush?: boolean }): Promise<void> {
    try {
      let flush = false;
      if (options && Object.keys(options).includes('flush') && options.flush === true) {
        flush = true;
      }
      const spin = createSpinner();

      const entities = [];
      const directory = '../../../data';
      spin.start('Reading files from directories');
      const files = fs.readdirSync(path.join(__dirname, directory));
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

      if (flush) {
        await this.flushEntities(entities);
      }

      const sortedEntities = this.sortEntities(entities);
      const keys = Object.keys(sortedEntities);
      for (const key of keys) {
        try {
          const entity = entities[key];
          const fileDirectory = path.join(__dirname, `${directory}/${key}`);
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
      process.exit(0);
    } catch (err) {
      console.error('The error while importing Entities is', err);
      process.exit(1);
    }
  }

  async flushEntities(entities: Record<string, unknown>[]): Promise<void> {
    const spin = createSpinner();
    spin.start('Removing existing data');
    await this.removeEntities(entities);
    spin.succeed('Existing data removed');
  }

  async removeEntities(entities: Record<string, unknown>[]): Promise<void> {
    const keys = Object.keys(entities).reverse();
    for (const key of keys) {
      await this.prismaService[key]?.deleteMany({});
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
