const router = require('express').Router();
const c = require('../controllers/absensiController');
const { verifyToken } = require('../middleware/authJwt');
const { isGuru, isSiswa } = require('../middleware/role');

// SISWA: generate QR token untuk absen
router.post('/token', verifyToken, isSiswa, c.generateQr);

// GURU: scan QR token untuk mencatat absen
router.post('/scan', verifyToken, isGuru, c.scanQr);

// GURU: lihat rekap absensi per jadwal
router.get('/jadwal/:jadwalId', verifyToken, isGuru, c.getRekap);

module.exports = router;
