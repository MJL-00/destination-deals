/*
==================================================
Destination Deals Environment Configuration

LOCAL DEVELOPMENT:
const API_URL = 'http://localhost:3000';

PRODUCTION:
const API_URL = 'https://destination-deals.onrender.com';
==================================================
*/

const API_URL =
    window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
        ? 'http://localhost:3000'
        : 'https://destination-deals.onrender.com';