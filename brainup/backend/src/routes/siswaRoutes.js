const router = require('express').Router();
const s = require('../controllers/siswaController');
const { verifyToken } = require('../middleware/authJwt');

router.post('/login', s.login);

router.post('/', s.create);
router.get('/', s.getAll);
router.get('/:id', s.getById);
router.put('/:id', s.update);
router.delete('/:id', s.delete);

router.put('/onesignal/:id', verifyToken, s.updateOneSignalId);

module.exports = router;