import { migrate } from 'drizzle-orm/neon-serverless/migrator';
import { db, pool } from '../src/db';

const run = async () => {
  try {
    await migrate(db, {
      migrationsFolder: './drizzle',
      migrationsSchema: 'public',
    });
    console.log('Migrations applied — users table is ready');
  } catch (err) {
    console.error('Migration failed:', err);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
};

run();