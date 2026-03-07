import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/siswa_repository.dart';
import 'siswa_home_event.dart';
import 'siswa_home_state.dart';

class SiswaHomeBloc
    extends Bloc<SiswaHomeEvent, SiswaHomeState> {
  final SiswaRepository repository;

  SiswaHomeBloc(this.repository)
    : super(SiswaHomeInitial()) {
    on<LoadSiswaJadwal>(_loadJadwal);
    on<LoadSiswaProfile>(
      _loadProfile,
    ); // <--- handler baru
  }

  Future<void> _loadJadwal(
    LoadSiswaJadwal event,
    Emitter<SiswaHomeState> emit,
  ) async {
    emit(SiswaHomeLoading());
    try {
      final jadwal = await repository
          .getJadwalSiswa();
      emit(SiswaHomeLoaded(jadwal));
    } catch (e) {
      emit(SiswaHomeError(e.toString()));
    }
  }

  Future<void> _loadProfile(
    LoadSiswaProfile event,
    Emitter<SiswaHomeState> emit,
  ) async {
    emit(SiswaHomeLoading());
    try {
      final profile = await repository
          .getProfileSiswa();
      emit(SiswaProfileLoaded(profile));
    } catch (e) {
      emit(SiswaHomeError(e.toString()));
    }
  }
}
