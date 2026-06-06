require('dotenv').config(); // 1. Load environment variables first
const express = require('express');
const cors = require('cors');

const dealRoutes = require('./routes/dealRoutes');
const businessRoutes = require('./routes/businessRoutes');
const locationRoutes = require('./routes/locationRoutes');
const categoryRoutes = require('./routes/categoryRoutes');

const app = express();

app.use(express.json());
app.use(cors()); // CORS is already here, perfect!

app.get('/', (req, res) => {
    res.send('Tourism Deals API Running');
});

app.use('/deals', dealRoutes);
app.use('/businesses', businessRoutes);
app.use('/locations', locationRoutes);
app.use('/categories', categoryRoutes);

// 2. Use the environment port, defaulting to 3000 for local development
const PORT = process.env.PORT || 3000; 
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});