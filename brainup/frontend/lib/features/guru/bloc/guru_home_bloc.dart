import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/guru_repository.dart';
import 'guru_home_event.dart';
import 'guru_home_state.dart';

class GuruHomeBloc
    extends Bloc<GuruHomeEvent, GuruHomeState> {
  final GuruRepository repository;
  List<dynamic> siswaList = [];

  GuruHomeBloc(this.repository)
    : super(GuruHomeInitial()) {
    on<LoadGuruJadwal>(_loadJadwal);
    on<LoadSiswa>(_loadSiswa);
    on<CreateGuruJadwal>(_createJadwal);
    on<EditGuruJadwal>(_editJadwal);
    on<DeleteGuruJadwal>(_deleteJadwal);
  }

  Future<void> _loadJadwal(
    LoadGuruJadwal event,
    Emitter<GuruHomeState> emit,
  ) async {
    emit(GuruHomeLoading());
    try {
      final jadwal = await repository
          .getJadwalGuru();
      emit(
        GuruHomeLoaded(
          jadwal,
          siswaList: siswaList,
        ),
      );
    } catch (e) {
      emit(GuruHomeError(e.toString()));
    }
  }

  Future<void> _loadSiswa(
    LoadSiswa event,
    Emitter<GuruHomeState> emit,
  ) async {
    try {
      siswaList = await repository.getSiswa();
    } catch (_) {
      siswaList = [];
    }
  }

  Future<void> _createJadwal(
    CreateGuruJadwal event,
    Emitter<GuruHomeState> emit,
  ) async {
    emit(GuruHomeLoading());
    try {
      await repository.createJadwal(
        mataPelajaran: event.mataPelajaran,
        hari: event.hari,
        tanggalMulai: event.tanggalMulai,
        jamMulai: event.jamMulai,
        jamSelesai: event.jamSelesai,
        jumlahMinggu: event.jumlahMinggu,
        siswaIds: event.siswaIds,
      );
      final jadwal = await repository
          .getJadwalGuru();
      emit(
        GuruHomeLoaded(
          jadwal,
          siswaList: siswaList,
        ),
      );
    } catch (e) {
      emit(GuruHomeError(e.toString()));
    }
  }

  Future<void> _editJadwal(
    EditGuruJadwal event,
    Emitter<GuruHomeState> emit,
  ) async {
    emit(GuruHomeLoading());
    try {
      await repository.editJadwal(
        id: event.id,
        mataPelajaran: event.mataPelajaran,
        hari: event.hari,
        tanggalMulai: event.tanggalMulai,
        jamMulai: event.jamMulai,
        jamSelesai: event.jamSelesai,
        jumlahMinggu: event.jumlahMinggu,
        siswaIds: event.siswaIds,
      );
      final jadwal = await repository
          .getJadwalGuru();
      emit(
        GuruHomeLoaded(
          jadwal,
          siswaList: siswaList,
        ),
      );
    } catch (e) {
      emit(GuruHomeError(e.toString()));
    }
  }

  Future<void> _deleteJadwal(
    DeleteGuruJadwal event,
    Emitter<GuruHomeState> emit,
  ) async {
    emit(GuruHomeLoading());
    try {
      await repository.deleteJadwal(event.id);
      final jadwal = await repository
          .getJadwalGuru();
      emit(
        GuruHomeLoaded(
          jadwal,
          siswaList: siswaList,
        ),
      );
    } catch (e) {
      emit(GuruHomeError(e.toString()));
    }
  }
}
