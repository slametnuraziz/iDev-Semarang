const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Guru = require('../models/guruModel');

exports.create = async (req, res) => {
    try {
        const {nama, nip, jenis_kelamin, pendidikan_terakhir, email, password} = req.body;
        const hash = await bcrypt.hash(password, 10);

        await Guru.createGuru([
            nama, nip, jenis_kelamin, pendidikan_terakhir, email, hash
        ]);

        res.status(201).json({
            success: true,
            message: 'Guru berhasil ditambahkan'
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahaan saat menambahkan guru',
            error: error.message
        });
    }
};

exports.getAll = async (req, res) => {
    try {
        const data = await Guru.getAllGuru();
        res.status(200).json({
            success: true,
            message: 'Data guru BrainUp',
            data: data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan saat mengambil data guru',
            error: error.message
        });
    }
};

exports.getById = async (req, res) => {
    try {
        const data = await Guru.getGuruById(req.params.id);

        if (!data) {
            return res.status(404).json({
                success: false,
                message: 'Guru tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Data guru BrainUp',
            data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan saat mengambil data guru',
            error: error.message
        });
    }
};

exports.update = async (req, res) => {
    try {
        const { nama, nip, jenis_kelamin, pendidikan_terakhir, email} = req.body;
        await Guru.updateGuru(req.params.id, [
            nama, nip, jenis_kelamin, pendidikan_terakhir, email
        ]);
        res.status(201).json({
            success: true, 
            message: 'Guru berhasil diupdate',
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan saat update guru',
            error: error.message
        });
    }
};

exports.delete = async (req, res) => {
    try {
        await Guru.deleteGuru(req.params.id);
        res.status(201).json({
            success: true,
            message: 'Guru berhasil dihapus'
        });
    } catch (error) {
        res.status(500).json({
            success: false, 
            message: 'Terjadi kesalahan saat hapus guru',
            error: error.message
        })
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const guru = await Guru.findGuruByEmail(email);

        if (!guru) {
            return res.status(401).json({
                success: false,
                message: 'Guru belum terdaftar di BrainUp'
            });
        }

        const match = await bcrypt.compare(password, guru.password);

        if (!match) {
            return res.status(401).json({
                success: false,
                message: 'Password salah'
            });
        }

        const token = jwt.sign(
            { id: guru.id, role: 'guru' },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );

        res.status(200).json({
            success: true,
            message: 'Login berhasil',
            token,
            data: {
                id: guru.id,
                nama: guru.nama,
                email: guru.email
            }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan saat login',
            error: error.message
        });
    }
};