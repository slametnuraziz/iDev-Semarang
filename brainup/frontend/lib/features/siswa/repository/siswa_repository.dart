import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';
import '../../../core/storage/hive_storage.dart';

class SiswaRepository {
  // ===================== GET JADWAL SISWA =====================
  Future<List<Map<String, dynamic>>>
  getJadwalSiswa() async {
    final token = HiveStorage.getToken();
    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Silakan login ulang.',
      );
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/jadwal/siswa',
    );
    print('Fetching Jadwal Siswa: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data,
        );
      } else {
        return [];
      }
    } else if (response.statusCode == 403) {
      throw Exception(
        'Akses ditolak (403). Pastikan token benar dan role siswa.',
      );
    } else {
      throw Exception(
        'Gagal mengambil jadwal (${response.statusCode})',
      );
    }
  }

  // ===================== GET PROFILE SISWA =====================
  Future<Map<String, dynamic>>
  getProfileSiswa() async {
    final token = HiveStorage.getToken();
    final id = HiveStorage.getUserId();
    if (token == null || id == null) {
      throw Exception(
        'Token atau ID tidak tersedia. Silakan login ulang.',
      );
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/siswa/$id',
    );
    print('Fetching Profile Siswa: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {};
      }
    } else if (response.statusCode == 403) {
      throw Exception(
        'Akses ditolak (403). Pastikan token benar dan role siswa.',
      );
    } else {
      throw Exception(
        'Gagal mengambil profile (${response.statusCode})',
      );
    }
  }

  // ===================== GENERATE QR TOKEN =====================
  Future<String> generateQrToken(
    int jadwalId,
  ) async {
    final token = HiveStorage.getToken();
    if (token == null) {
      throw Exception('Token kosong');
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/absensi/token',
    );

    print(
      'Generating QR for jadwal_id: $jadwalId',
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'jadwal_id': jadwalId}),
    );

    print(
      'QR Response status: ${response.statusCode}',
    );
    print('QR Response body: ${response.body}');

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['qr_token'];
    } else {
      throw Exception(
        body['message'] ?? 'Gagal generate QR',
      );
    }
  }
}
