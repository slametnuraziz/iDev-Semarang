const db = require('../config/db');

exports.createAbsensi = async (jadwalId, siswaId, guruId) => {
  const [result] = await db.execute(
    `INSERT INTO absensi (jadwal_id, siswa_id, guru_id, status, waktu_absen)
     VALUES (?, ?, ?, 'hadir', NOW())`,
    [jadwalId, siswaId, guruId]
  );
  return result;
};

exports.checkAlreadyAbsen = async (jadwalId, siswaId) => {
  const [rows] = await db.execute(
    `SELECT id FROM absensi WHERE jadwal_id=? AND siswa_id=?`,
    [jadwalId, siswaId]
  );
  return rows.length > 0;
};

exports.getAbsensiByJadwal = async (jadwalId) => {
  const [rows] = await db.execute(
    `SELECT s.id AS siswa_id, s.nama, a.status, a.waktu_absen
     FROM participants p
     JOIN siswa s ON s.id = p.siswa_id
     LEFT JOIN absensi a 
       ON a.siswa_id = s.id AND a.jadwal_id = p.jadwal_id
     WHERE p.jadwal_id = ?`,
    [jadwalId]
  );
  return rows;
};
