import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/siswa_repository.dart';
import 'siswa_absensi_event.dart';
import 'siswa_absensi_state.dart';

class SiswaAbsensiBloc
    extends
        Bloc<
          SiswaAbsensiEvent,
          SiswaAbsensiState
        > {
  final SiswaRepository repository;

  SiswaAbsensiBloc(this.repository)
    : super(AbsensiSiswaInitial()) {
    on<GenerateQrSiswa>(_onGenerateQr);
    on<ResetQrSiswa>(_onResetQr);
  }

  Future<void> _onGenerateQr(
    GenerateQrSiswa event,
    Emitter<SiswaAbsensiState> emit,
  ) async {
    emit(AbsensiSiswaLoading());
    try {
      final qrToken = await repository
          .generateQrToken(event.jadwalId);
      emit(AbsensiSiswaQrReady(qrToken));
    } catch (e) {
      emit(AbsensiSiswaError(e.toString()));
    }
  }

  void _onResetQr(
    ResetQrSiswa event,
    Emitter<SiswaAbsensiState> emit,
  ) {
    emit(AbsensiSiswaInitial());
  }
}
