import { Command, Console, CreateCommandOptions } from 'nestjs-console';
import * as path from 'path';
import { ImportService } from 'src/import/services';

@Console()
export class ImportConsole {
  constructor(private importService: ImportService) {}

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
  async importEntitiesConsoleCommand(options: CreateCommandOptions & { flush?: boolean }): Promise<void> {
    let flush = false;
    if (options && Object.keys(options).includes('flush') && options.flush === true) {
      flush = true;
    }
    await this.importService.importEntities(path.join(__dirname, '../../../data'), flush);
    return;
  }
}
