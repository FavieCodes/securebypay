import { pool } from '../src/db';

const run = async () => {
  try {
    const columns = await pool.query(
      `SELECT column_name, data_type, is_nullable
       FROM information_schema.columns
       WHERE table_schema = 'public' AND table_name = 'users'
       ORDER BY ordinal_position`
    );
    console.log('Columns that actually exist on "users" right now:');
    console.table(columns.rows);
  } catch (err) {
    console.error('Query failed:', err);
  } finally {
    await pool.end();
  }
};

run();
