const router = require('express').Router();
const g = require('../controllers/guruController');

router.post('/login', g.login);

router.get('/', g.getAll);
router.get('/:id', g.getById);
router.post('/', g.create);
router.put('/:id', g.update);
router.delete('/:id', g.delete);

module.exports = router;