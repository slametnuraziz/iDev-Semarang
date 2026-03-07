const db = require('../config/db');

exports.createJadwal = async (data) => {
  const [result] = await db.execute(
    `INSERT INTO jadwal 
     (guru_id, mata_pelajaran, hari, tanggal_mulai, jam_mulai, jam_selesai, jumlah_minggu)
     VALUES (?,?,?,?,?,?,?)`,
    data
  );
  return result.insertId;
};

exports.addParticipant = async (jadwalId, siswaId) => {
  await db.execute(
    `INSERT INTO participants (jadwal_id, siswa_id) VALUES (?, ?)`,
    [jadwalId, siswaId]
  );
};

exports.createPertemuan = async (jadwalId, tanggal, pertemuanKe) => {
  const [result] = await db.execute(
    `INSERT INTO pertemuan (jadwal_id, tanggal, pertemuan_ke) VALUES (?, ?, ?)`,
    [jadwalId, tanggal, pertemuanKe]
  );
  return result.insertId;
};

exports.getJadwalByGuru = async (guruId) => {
  const [rows] = await db.execute(
    `SELECT j.*, COUNT(DISTINCT p.siswa_id) AS total_siswa,
            COUNT(DISTINCT pt.id) AS total_pertemuan
     FROM jadwal j
     LEFT JOIN participants p ON p.jadwal_id = j.id
     LEFT JOIN pertemuan pt ON pt.jadwal_id = j.id
     WHERE j.guru_id = ?
     GROUP BY j.id`,
    [guruId]
  );
  return rows;
};

exports.getJadwalById = async (id) => {
  const [rows] = await db.execute(
    `SELECT j.*, g.nama AS guru_nama
     FROM jadwal j
     JOIN guru g ON g.id = j.guru_id
     WHERE j.id = ?`,
    [id]
  );
  return rows[0];
};

exports.getPertemuanByJadwal = async (jadwalId) => {
  const [rows] = await db.execute(
    `SELECT * FROM pertemuan WHERE jadwal_id = ? ORDER BY tanggal ASC`,
    [jadwalId]
  );
  return rows;
};

exports.getJadwalBySiswa = async (siswaId) => {
  const [rows] = await db.execute(
    `SELECT j.*, g.nama AS guru_nama
     FROM jadwal j
     JOIN participants p ON p.jadwal_id = j.id
     JOIN guru g ON g.id = j.guru_id
     WHERE p.siswa_id = ?`,
    [siswaId]
  );
  return rows;
};

exports.updateJadwal = async (id, guruId, data) => {
  const [result] = await db.execute(
    `UPDATE jadwal 
     SET mata_pelajaran=?, hari=?, tanggal_mulai=?, jam_mulai=?, jam_selesai=?, jumlah_minggu=?
     WHERE id=? AND guru_id=?`,
    [...data, id, guruId]
  );
  return result;
};

exports.deleteParticipants = async (jadwalId) => {
  await db.execute(`DELETE FROM participants WHERE jadwal_id=?`, [jadwalId]);
};

exports.deletePertemuan = async (jadwalId) => {
  await db.execute(`DELETE FROM pertemuan WHERE jadwal_id=?`, [jadwalId]);
};

exports.deleteJadwal = async (id, guruId) => {
  const [result] = await db.execute(
    `DELETE FROM jadwal WHERE id=? AND guru_id=?`,
    [id, guruId]
  );
  return result;
};