import { pool } from '../src/db';

const run = async () => {
  try {
    console.log('Dropping and recreating the public schema (this deletes ALL data and tables)...');
    await pool.query('DROP SCHEMA public CASCADE');
    await pool.query('CREATE SCHEMA public');
    await pool.query('GRANT ALL ON SCHEMA public TO public');
    console.log('Done — public schema is now empty.');
  } catch (err) {
    console.error('Reset failed:', err);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
};

run();