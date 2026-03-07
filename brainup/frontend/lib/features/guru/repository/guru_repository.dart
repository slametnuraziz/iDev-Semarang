import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';
import '../../../core/storage/hive_storage.dart';

class GuruRepository {
  Future<List<dynamic>> getJadwalGuru() async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/guru',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception(
        'Gagal mengambil jadwal (${response.statusCode})',
      );
    }
  }

  // ✅ UPDATED: tanggal → hari + tanggal_mulai + jumlah_minggu
  Future<void> createJadwal({
    required String mataPelajaran,
    required String hari,
    required String tanggalMulai,
    required String jamMulai,
    required String jamSelesai,
    required int jumlahMinggu,
    required List<int> siswaIds,
  }) async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/jadwal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mata_pelajaran': mataPelajaran,
        'hari': hari,
        'tanggal_mulai': tanggalMulai,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'jumlah_minggu': jumlahMinggu,
        'siswa_ids': siswaIds,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        'Gagal membuat jadwal (${response.statusCode})',
      );
    }
  }

  Future<void> editJadwal({
    required int id,
    required String mataPelajaran,
    required String hari,
    required String tanggalMulai,
    required String jamMulai,
    required String jamSelesai,
    required int jumlahMinggu,
    required List<int> siswaIds,
  }) async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final res = await http.put(
      Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/$id',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mata_pelajaran': mataPelajaran,
        'hari': hari,
        'tanggal_mulai': tanggalMulai,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'jumlah_minggu': jumlahMinggu,
        'siswa_ids': siswaIds,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Gagal edit jadwal: ${res.body}',
      );
    }
  }

  Future<List<dynamic>> getSiswa() async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/siswa'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception(
        'Gagal mengambil list siswa (${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>>
  getProfileGuru() async {
    final token = HiveStorage.getToken();
    final id = HiveStorage.getUserId();
    if (token == null || id == null)
      throw Exception(
        'Token atau ID tidak tersedia',
      );

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/guru/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'] ?? {};
    } else {
      throw Exception(
        'Gagal mengambil profile (${response.statusCode})',
      );
    }
  }

  Future<void> deleteJadwal(int id) async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final res = await http.delete(
      Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/$id',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Gagal hapus jadwal: ${res.body}',
      );
    }
  }

  Future<List<dynamic>> getRekapAbsensi(
    int jadwalId,
  ) async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/absensi/jadwal/$jadwalId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception(
        'Gagal mengambil rekap (${response.statusCode})',
      );
    }
  }

  Future<void> scanQr(String qrToken) async {
    final token = HiveStorage.getToken();
    if (token == null)
      throw Exception('Token kosong');

    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/absensi/scan',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'qr_token': qrToken}),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(
        body['message'] ?? 'Gagal absen',
      );
    }
  }
}
