const db = require('../config/db');
const Jadwal = require('../models/jadwalModel');
const { scheduleAllReminders } = require('../services/notificationService');

// Helper: hitung tanggal pertemuan berdasarkan hari
const getHariIndex = (hari) => {
  const map = {
    'Minggu': 0, 'Senin': 1, 'Selasa': 2, 'Rabu': 3,
    'Kamis': 4, 'Jumat': 5, 'Sabtu': 6
  };
  return map[hari];
};

const getNextTanggal = (hariTarget, tanggalMulai) => {
  const date = new Date(tanggalMulai);
  const hariIndex = getHariIndex(hariTarget);
  const diff = (hariIndex - date.getDay() + 7) % 7;
  date.setDate(date.getDate() + diff);
  return date;
};

const create = async (req, res) => {
  try {
    const guruId = req.user.id;
    const {
      mata_pelajaran, hari, tanggal_mulai,
      jam_mulai, jam_selesai, jumlah_minggu, siswa_ids
    } = req.body;

    // 1. Insert jadwal
    const jadwalId = await Jadwal.createJadwal([
      guruId, mata_pelajaran, hari, tanggal_mulai,
      jam_mulai, jam_selesai, jumlah_minggu || 1
    ]);

    // 2. Tambah peserta
    if (Array.isArray(siswa_ids) && siswa_ids.length > 0) {
      for (const siswaId of siswa_ids) {
        await Jadwal.addParticipant(jadwalId, siswaId);
      }
    }

    // 3. Generate pertemuan mingguan
    const pertemuanList = [];
    let tanggalPertemuan = getNextTanggal(hari, tanggal_mulai);

    for (let i = 0; i < (jumlah_minggu || 1); i++) {
      const tanggalStr = tanggalPertemuan.toISOString().split('T')[0];
      await Jadwal.createPertemuan(jadwalId, tanggalStr, i + 1);
      pertemuanList.push({
        tanggal: tanggalStr,
        pertemuan_ke: i + 1
      });
      // Tambah 7 hari untuk minggu berikutnya
      tanggalPertemuan.setDate(tanggalPertemuan.getDate() + 7);
    }

    console.log(`📅 ${pertemuanList.length} pertemuan dibuat untuk jadwal ${jadwalId}`);

    // 4. Schedule semua reminder
    if (Array.isArray(siswa_ids) && siswa_ids.length > 0) {
      const placeholders = siswa_ids.map(() => '?').join(',');
      const [rows] = await db.execute(
        `SELECT onesignal_subscription_id FROM siswa 
         WHERE id IN (${placeholders}) 
         AND onesignal_subscription_id IS NOT NULL`,
        siswa_ids
      );

      const subscriptionIds = rows.map(r => r.onesignal_subscription_id);
      console.log('📱 Subscription IDs:', subscriptionIds);

      if (subscriptionIds.length > 0) {
        await scheduleAllReminders(jadwalId, subscriptionIds, { mata_pelajaran, jam_mulai }, pertemuanList);
      }
    }

    res.status(201).json({
      success: true,
      message: `Jadwal berhasil dibuat dengan ${pertemuanList.length} pertemuan`,
      jadwal_id: jadwalId,
      pertemuan: pertemuanList
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Gagal membuat jadwal', error: error.message });
  }
};

const getByGuru = async (req, res) => {
  try {
    const data = await Jadwal.getJadwalByGuru(req.user.id);
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

const getBySiswa = async (req, res) => {
  try {
    const data = await Jadwal.getJadwalBySiswa(req.user.id);
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

const getById = async (req, res) => {
  try {
    const data = await Jadwal.getJadwalById(req.params.id);
    if (!data) return res.status(404).json({ success: false, message: 'Jadwal tidak ditemukan' });

    // Ambil list pertemuan
    const pertemuan = await Jadwal.getPertemuanByJadwal(req.params.id);
    res.json({ success: true, data: { ...data, pertemuan } });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

const update = async (req, res) => {
  try {
    const guruId = req.user.id;
    const {
      mata_pelajaran, hari, tanggal_mulai,
      jam_mulai, jam_selesai, jumlah_minggu, siswa_ids
    } = req.body;

    const jadwal = await Jadwal.getJadwalById(req.params.id);
    if (!jadwal) return res.status(404).json({ success: false, message: 'Jadwal tidak ditemukan' });

    // Update jadwal
    await Jadwal.updateJadwal(req.params.id, guruId, [
      mata_pelajaran, hari, tanggal_mulai, jam_mulai, jam_selesai, jumlah_minggu || 1
    ]);

    // Reset participants & pertemuan
    await Jadwal.deleteParticipants(req.params.id);
    await Jadwal.deletePertemuan(req.params.id);

    if (Array.isArray(siswa_ids) && siswa_ids.length > 0) {
      for (const siswaId of siswa_ids) {
        await Jadwal.addParticipant(req.params.id, siswaId);
      }
    }

    // Regenerate pertemuan
    const pertemuanList = [];
    let tanggalPertemuan = getNextTanggal(hari, tanggal_mulai);

    for (let i = 0; i < (jumlah_minggu || 1); i++) {
      const tanggalStr = tanggalPertemuan.toISOString().split('T')[0];
      await Jadwal.createPertemuan(req.params.id, tanggalStr, i + 1);
      pertemuanList.push({ tanggal: tanggalStr, pertemuan_ke: i + 1 });
      tanggalPertemuan.setDate(tanggalPertemuan.getDate() + 7);
    }

    // Reschedule reminder
    if (Array.isArray(siswa_ids) && siswa_ids.length > 0) {
      const placeholders = siswa_ids.map(() => '?').join(',');
      const [rows] = await db.execute(
        `SELECT onesignal_subscription_id FROM siswa 
         WHERE id IN (${placeholders}) 
         AND onesignal_subscription_id IS NOT NULL`,
        siswa_ids
      );

      const subscriptionIds = rows.map(r => r.onesignal_subscription_id);
      if (subscriptionIds.length > 0) {
        await scheduleAllReminders(req.params.id, subscriptionIds, { mata_pelajaran, jam_mulai }, pertemuanList);
      }
    }

    res.json({ success: true, message: 'Jadwal berhasil diupdate' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

const remove = async (req, res) => {
  try {
    const guruId = req.user.id;
    const jadwal = await Jadwal.getJadwalById(req.params.id);
    if (!jadwal) return res.status(404).json({ success: false, message: 'Jadwal tidak ditemukan' });

    await db.execute('DELETE FROM absensi WHERE jadwal_id = ?', [req.params.id]);
    await Jadwal.deletePertemuan(req.params.id);
    await Jadwal.deleteParticipants(req.params.id);
    await Jadwal.deleteJadwal(req.params.id, guruId);

    res.json({ success: true, message: 'Jadwal berhasil dihapus' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = { create, getByGuru, getBySiswa, getById, update, remove };