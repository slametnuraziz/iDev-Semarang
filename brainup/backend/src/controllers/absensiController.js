const jwt = require('jsonwebtoken');
const Absensi = require('../models/absensiModel');

exports.generateQr = async (req, res) => {
  try {
    const siswaId = req.user.id;
    const { jadwal_id } = req.body;

    if (!jadwal_id)
      return res.status(400).json({ success: false, message: 'jadwal_id wajib' });

    const token = jwt.sign(
      { siswa_id: siswaId, jadwal_id, type: 'absen' },
      process.env.JWT_QR_SECRET,
      { expiresIn: '5m' }
    );

    res.json({ success: true, qr_token: token });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
};

exports.scanQr = async (req, res) => {
  try {
    const guruId = req.user.id;
    const { qr_token } = req.body;

    if (!qr_token)
      return res.status(400).json({ success: false, message: 'qr_token wajib' });

    const decoded = jwt.verify(qr_token, process.env.JWT_QR_SECRET);

    if (decoded.type !== 'absen')
      return res.status(400).json({ success: false, message: 'QR tidak valid' });

    const { siswa_id, jadwal_id } = decoded;

    const already = await Absensi.checkAlreadyAbsen(jadwal_id, siswa_id);
    if (already)
      return res.status(409).json({ success: false, message: 'Siswa sudah absen' });

    await Absensi.createAbsensi(jadwal_id, siswa_id, guruId);

    res.json({ success: true, message: 'Absensi berhasil' });
  } catch (e) {
    res.status(400).json({ success: false, message: 'QR kadaluarsa / tidak valid' });
  }
};

exports.getRekap = async (req, res) => {
  try {
    const { jadwalId } = req.params;
    if (!jadwalId)
      return res.status(400).json({ success: false, message: 'jadwalId wajib' });

    const data = await Absensi.getAbsensiByJadwal(jadwalId);

    res.json({ success: true, data });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
};
