// Postgres connection pool, shared by every route.
//
// Set DATABASE_URL in your environment (locally in a .env file, or as an
// environment variable on whatever host you deploy the API to). Example:
//   DATABASE_URL=postgresql://user:password@host:5432/dbname
//
// Most hosted Postgres providers (Supabase, Render, Railway, Neon) require
// SSL for external connections. SSL is enabled automatically unless
// PGSSL=disable is set — handy for a local Postgres install with no SSL.

require('dotenv').config();
const { Pool } = require('pg');

if (!process.env.DATABASE_URL) {
  console.error('Missing DATABASE_URL environment variable. See .env.example.');
  process.exit(1);
}

const useSSL = process.env.PGSSL !== 'disable';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: useSSL ? { rejectUnauthorized: false } : false,
});

pool.on('error', (err) => {
  console.error('Unexpected Postgres pool error', err);
});

module.exports = pool;
