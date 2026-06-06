const { Pool } = require('pg');
require('dotenv').config();

// If DATABASE_URL exists (on Render), use it. Otherwise, fall back to localhost.
const isProduction = process.env.DATABASE_URL;

const pool = new Pool(
    isProduction
        ? {
              connectionString: process.env.DATABASE_URL,
              ssl: { rejectUnauthorized: false }, // Required for secure cloud connections
          }
        : {
              user: 'postgres',
              host: 'localhost',
              database: 'tourism_deals',
              password: 'frenchfry1',
              port: 5432,
          }
);

module.exports = pool;