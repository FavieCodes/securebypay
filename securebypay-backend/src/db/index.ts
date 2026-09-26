import dns from 'node:dns';
import { neonConfig, Pool } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-serverless';
import ws from 'ws';
import dotenv from 'dotenv';
import * as schema from './schema';

dotenv.config();

dns.setDefaultResultOrder('ipv4first');

neonConfig.webSocketConstructor = ws;

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on('error', (err: Error) => {
  console.error('Unexpected error on idle Postgres client', err);
});

export const db = drizzle(pool, { schema });