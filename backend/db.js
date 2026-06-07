const { Pool } = require('pg');
require('dotenv').config();

let pool;

// Check if DATABASE_URL exists (which only happens live on Render)
if (process.env.DATABASE_URL) {
    // PRODUCTION: Connect to Render's cloud PostgreSQL database
    pool = new Pool({
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false } // Mandatory for secure cloud hosting
    });
    console.log("Connected to PRODUCTION cloud database.");
} else {
    // DEVELOPMENT: Connect to your local machine's database using individual variables
    pool = new Pool({
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: process.env.DB_NAME,
        password: process.env.DB_PASSWORD,
        port: parseInt(process.env.DB_PORT) || 5432,
    });
    console.log("Connected to LOCAL development database.");
}

module.exports = pool;