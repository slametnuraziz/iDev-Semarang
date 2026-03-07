const db = require('../config/db');

exports.getAllGuru = async () => {
    const [rows] = await db.execute(
        'SELECT id, nama, nip, jenis_kelamin, pendidikan_terakhir, email FROM guru'
    );
    return rows;
};

exports.findGuruByEmail = async (email) => {
    const [rows] = await db.execute(
        'SELECT * FROM guru WHERE email = ?',
        [email]
    );
    return rows[0];
};

exports.getGuruById = async (id) => {
    const [rows] = await db.execute(
        'SELECT id, nama, nip, jenis_kelamin, pendidikan_terakhir, email FROM guru WHERE id = ?',
        [id]
    );
    return rows[0];
};

exports.createGuru = async (data) => {
    const sql = `
        INSERT INTO guru 
        (nama, nip, jenis_kelamin, pendidikan_terakhir, email, password) 
        VALUES (?,?,?,?,?,?)
    `;
    const [result] = await db.execute(sql, data);
    return result;
};

exports.updateGuru = async (id, data) => {
    const sql = `
        UPDATE guru 
        SET nama = ?, nip = ?, jenis_kelamin = ?, pendidikan_terakhir = ?, email = ?
        WHERE id = ?
    `;
    const [result] = await db.execute(sql, [...data, id]);
    return result;
};

exports.deleteGuru = async (id) => {
    const [result] = await db.execute(
        'DELETE FROM guru WHERE id = ?',
        [id]
    );
    return result;
};
