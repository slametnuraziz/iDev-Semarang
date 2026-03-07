const express = require('express');
const cors = require('cors');

const guruRoutes = require('./routes/guruRoutes');
const siswaRoutes = require('./routes/siswaRoutes');
const jadwalRoutes = require('./routes/jadwalRoutes');
const absensiRoutes = require('./routes/absensiRoutes');
const testRoutes = require('./routes/testRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/guru', guruRoutes);
app.use('/api/siswa', siswaRoutes);
app.use('/api/jadwal', jadwalRoutes);
app.use('/api/absensi', absensiRoutes);
app.use('/api/test', testRoutes);

app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'BrainUp API is running!'
    });
});

module.exports = app;