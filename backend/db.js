const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'tourism_deals',
    password: 'frenchfry1',
    port: 5432,
});

module.exports = pool;