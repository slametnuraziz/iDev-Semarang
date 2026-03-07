const axios = require('axios');

const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;

// Kirim semua reminder untuk semua pertemuan sekaligus
exports.scheduleAllReminders = async (jadwalId, subscriptionIds, jadwal, pertemuanList) => {
  const results = [];

  for (const pertemuan of pertemuanList) {
    const tanggalStr = pertemuan.tanggal instanceof Date
      ? pertemuan.tanggal.toISOString().split('T')[0]
      : pertemuan.tanggal.toString().split('T')[0];

    const jamStr = jadwal.jam_mulai.toString().substring(0, 8);
    const jadwalDateTime = new Date(`${tanggalStr}T${jamStr}`);

    if (isNaN(jadwalDateTime.getTime())) {
      console.error('❌ Invalid date:', tanggalStr, jamStr);
      continue;
    }

    // ✅ Reminder 1: H-1 hari (jam 07:00 pagi sehari sebelumnya)
    const reminderH1 = new Date(jadwalDateTime);
    reminderH1.setDate(reminderH1.getDate() - 1);
    reminderH1.setHours(7, 0, 0, 0);

    // ✅ Reminder 2: 15 menit sebelum jadwal
    const reminder15Min = new Date(jadwalDateTime.getTime() - 15 * 60 * 1000);

    const now = new Date();

    // Kirim reminder H-1
    if (reminderH1 > now) {
      const res1 = await sendNotification(
        subscriptionIds,
        '📅 Reminder Jadwal Besok',
        `${jadwal.mata_pelajaran} besok jam ${jamStr.substring(0, 5)} (Pertemuan ${pertemuan.pertemuan_ke})`,
        jadwalId,
        reminderH1.toISOString()
      );
      console.log(`✅ Reminder H-1 pertemuan ${pertemuan.pertemuan_ke}:`, res1?.id);
      results.push(res1);
    }

    // Kirim reminder 15 menit
    if (reminder15Min > now) {
      const res2 = await sendNotification(
        subscriptionIds,
        '📚 Jadwal Segera Dimulai',
        `${jadwal.mata_pelajaran} dimulai 15 menit lagi (Pertemuan ${pertemuan.pertemuan_ke})`,
        jadwalId,
        reminder15Min.toISOString()
      );
      console.log(`✅ Reminder 15min pertemuan ${pertemuan.pertemuan_ke}:`, res2?.id);
      results.push(res2);
    }
  }

  return results;
};

// Helper kirim notifikasi
const sendNotification = async (subscriptionIds, title, message, jadwalId, sendAfter) => {
  try {
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONESIGNAL_APP_ID,
        include_subscription_ids: subscriptionIds,
        headings: { en: title },
        contents: { en: message },
        data: {
          type: 'jadwal_reminder',
          jadwal_id: jadwalId.toString(),
          deep_link: `brainup://jadwal/${jadwalId}`,
        },
        send_after: sendAfter,
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Basic ${ONESIGNAL_REST_API_KEY}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error('❌ Send error:', error.response?.data || error.message);
  }
};

exports.sendInstantNotification = async (subscriptionIds, title, message, data = {}) => {
  try {
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONESIGNAL_APP_ID,
        include_subscription_ids: subscriptionIds,
        headings: { en: title },
        contents: { en: message },
        data,
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Basic ${ONESIGNAL_REST_API_KEY}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error('❌ Notification error:', error.response?.data || error.message);
  }
};