const express = require('express');
const cors = require('cors');




const dealRoutes = require('./routes/dealRoutes');
const businessRoutes = require('./routes/businessRoutes');
const locationRoutes = require('./routes/locationRoutes');
const categoryRoutes = require('./routes/categoryRoutes');

const app = express();



app.use(express.json());
app.use(cors());


app.get('/', (req, res) => {
    res.send('Tourism Deals API Running');
});

app.use('/deals', dealRoutes);
app.use('/businesses', businessRoutes);
app.use('/locations', locationRoutes);
app.use('/categories', categoryRoutes);


app.listen(3000, () => {
    console.log('Server running on port 3000');
});