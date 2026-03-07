const router = require('express').Router();
const c = require('../controllers/jadwalController');
const { verifyToken } = require('../middleware/authJwt');
const { isGuru, isSiswa } = require('../middleware/role');

// ===== SISWA — harus di atas sebelum /:id =====
router.get('/siswa', verifyToken, isSiswa, c.getBySiswa);
router.get('/siswa/:id', verifyToken, isSiswa, c.getById);

// ===== GURU =====
router.post('/', verifyToken, isGuru, c.create);
router.get('/guru', verifyToken, isGuru, c.getByGuru);
router.get('/guru/:id', verifyToken, isGuru, c.getById);
router.put('/:id', verifyToken, isGuru, c.update);
router.delete('/:id', verifyToken, isGuru, c.remove);

module.exports = router;