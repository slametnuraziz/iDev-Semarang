const db = require('../config/db');

exports.getAllSiswa = async () => {
    const [rows] = await db.execute(
        'SELECT id, nama, jenis_kelamin, kelas, sekolah, email FROM siswa'
    );
    return rows;
}

exports.getSiswaById = async (id) => {
    const [rows] = await db.execute(
        'SELECT id, nama, jenis_kelamin, kelas, sekolah, email FROM siswa WHERE id = ?', 
        [id]
    );
    return rows[0];
};

exports.findSiswaByEmail = async (email) => {
    const [rows] = await db.execute(
        'SELECT * FROM siswa WHERE email = ?', 
        [email]
    );
    return rows[0];
};

exports.createSiswa = async (data) => {
    const sql = `
        INSERT INTO siswa 
        (nama, jenis_kelamin, kelas, sekolah, email, password) 
        VALUES (?, ?, ?, ?, ?, ?)
    `;
    const [result] = await db.execute(sql, data);
    return result;
};

exports.updateSiswa = async (id, data) => {
    const sql = `
        UPDATE siswa 
        SET nama = ?, jenis_kelamin = ?, kelas = ?, sekolah = ?, email = ?
        WHERE id = ?
    `;
    const [result] = await db.execute(sql, [...data, id]);
    return result;
};

exports.deleteSiswa = async (id) => {
    const [result] = await db.execute(
        'DELETE FROM siswa WHERE id = ?',
        [id]
    );
    return result;
};