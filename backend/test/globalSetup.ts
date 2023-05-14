import { execSync } from 'child_process';

export default () => {
  console.log('global test booting up...');

  process.env.DATABASE_URL =
    process.env.DATABASE_URL || 'postgresql://hopon:hopon@localhost:5432/hopon_test?schema=public';

  console.log('global test booting up...');

  execSync(`npm run migration:dev`, { stdio: 'inherit' });
};
