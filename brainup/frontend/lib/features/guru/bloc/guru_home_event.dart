abstract class GuruHomeEvent {}

class LoadGuruJadwal extends GuruHomeEvent {}

class LoadSiswa extends GuruHomeEvent {}

class CreateGuruJadwal extends GuruHomeEvent {
  final String mataPelajaran;
  final String hari;
  final String tanggalMulai;
  final String jamMulai;
  final String jamSelesai;
  final int jumlahMinggu;
  final List<int> siswaIds;

  CreateGuruJadwal({
    required this.mataPelajaran,
    required this.hari,
    required this.tanggalMulai,
    required this.jamMulai,
    required this.jamSelesai,
    required this.jumlahMinggu,
    required this.siswaIds,
  });
}

class EditGuruJadwal extends GuruHomeEvent {
  final int id;
  final String mataPelajaran;
  final String hari;
  final String tanggalMulai;
  final String jamMulai;
  final String jamSelesai;
  final int jumlahMinggu;
  final List<int> siswaIds;

  EditGuruJadwal({
    required this.id,
    required this.mataPelajaran,
    required this.hari,
    required this.tanggalMulai,
    required this.jamMulai,
    required this.jamSelesai,
    required this.jumlahMinggu,
    required this.siswaIds,
  });
}

class DeleteGuruJadwal extends GuruHomeEvent {
  final int id;
  DeleteGuruJadwal(this.id);
}
