import { pool } from '../src/db';

const run = async () => {
  try {
    const tables = await pool.query(
      `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name`
    );
    console.log('Tables that actually exist in public schema:');
    console.table(tables.rows);

    const tablesSchema = await pool.query(
      `SELECT table_schema, table_name FROM information_schema.tables WHERE table_name = 'password_reset_tokens'`
    );
    console.log('Where "password_reset_tokens" actually exists (if anywhere):');
    console.table(tablesSchema.rows);

    const searchPath = await pool.query(`SHOW search_path`);
    console.log('Current search_path (what an unqualified CREATE TABLE resolves against):');
    console.table(searchPath.rows);

    try {
      const migrations = await pool.query(
        `SELECT * FROM public."__drizzle_migrations" ORDER BY id`
      );
      console.log('What Drizzle\'s tracker thinks has been applied:');
      console.table(migrations.rows);
    } catch {
      console.log(
        '__drizzle_migrations table does not exist yet — Drizzle has never tracked a migration against this database before.'
      );
    }
  } catch (err) {
    console.error('Query failed:', err);
  } finally {
    await pool.end();
  }
};

run();