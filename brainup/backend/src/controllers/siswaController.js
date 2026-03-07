const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Siswa = require('../models/siswaModel');
const db = require('../config/db');

exports.create = async (req, res) => {
    try {
        const {nama, jenis_kelamin, kelas, sekolah, email, password} = req.body;
        const hash = await bcrypt.hash(password, 10);
        await Siswa.createSiswa([nama, jenis_kelamin, kelas, sekolah, email, hash]);
        res.status(201).json({ success: true, message: 'Siswa berhasil ditambahkan' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat menambahkan siswa', error: error.message });
    }
};

exports.getAll = async (req, res) => {
    try {
        const data = await Siswa.getAllSiswa();
        res.status(200).json({ success: true, message: 'Data siswa BrainUp', data });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat mengambil data', error: error.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const data = await Siswa.getSiswaById(req.params.id);
        if (!data) {
            return res.status(404).json({ success: false, message: 'Siswa tidak ditemukan' });
        }
        res.status(200).json({ success: true, message: 'Data siswa BrainUp', data });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat mengambil data', error: error.message });
    }
};

exports.update = async (req, res) => {
    try {
        const {nama, jenis_kelamin, kelas, sekolah, email} = req.body;
        await Siswa.updateSiswa(req.params.id, [nama, jenis_kelamin, kelas, sekolah, email]);
        res.status(200).json({ success: true, message: 'Siswa berhasil diupdate' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat update data', error: error.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await Siswa.deleteSiswa(req.params.id);
        res.status(200).json({ success: true, message: 'Siswa berhasil dihapus' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat hapus data', error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const siswa = await Siswa.findSiswaByEmail(email);

        if (!siswa) {
            return res.status(401).json({ success: false, message: 'Email tidak ditemukan' });
        }

        const match = await bcrypt.compare(password, siswa.password);
        if (!match) {
            return res.status(401).json({ success: false, message: 'Password salah' });
        }

        const token = jwt.sign(
            { id: siswa.id, role: 'siswa' },
            process.env.JWT_SECRET,
            { expiresIn: '1d' }
        );

        res.status(200).json({
            success: true,
            message: 'Login berhasil',
            token,
            data: { id: siswa.id, nama: siswa.nama, email: siswa.email }
        });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan saat login', error: error.message });
    }
};

// ✅ TAMBAHAN: simpan OneSignal Subscription ID
exports.updateOneSignalId = async (req, res) => {
    try {
        const { subscription_id } = req.body;
        const { id } = req.params;

        if (!subscription_id) {
            return res.status(400).json({ success: false, message: 'subscription_id wajib diisi' });
        }

        await db.execute(
            'UPDATE siswa SET onesignal_subscription_id = ? WHERE id = ?',
            [subscription_id, id]
        );

        res.json({ success: true, message: 'OneSignal ID updated' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};