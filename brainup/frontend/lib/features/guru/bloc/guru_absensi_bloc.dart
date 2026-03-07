import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/guru_repository.dart';
import 'guru_absensi_event.dart';
import 'guru_absensi_state.dart';

class GuruAbsensiBloc
    extends
        Bloc<GuruAbsensiEvent, GuruAbsensiState> {
  final GuruRepository repository;

  GuruAbsensiBloc(this.repository)
    : super(AbsensiInitial()) {
    on<LoadAbsensi>(_onLoadAbsensi);
    on<ScanQrEvent>(_onScanQr);
  }

  Future<void> _onLoadAbsensi(
    LoadAbsensi event,
    Emitter<GuruAbsensiState> emit,
  ) async {
    emit(AbsensiLoading());
    try {
      final rekap = await repository
          .getRekapAbsensi(event.jadwalId);
      emit(AbsensiLoaded(rekap));
    } catch (e) {
      emit(AbsensiError(e.toString()));
    }
  }

  Future<void> _onScanQr(
    ScanQrEvent event,
    Emitter<GuruAbsensiState> emit,
  ) async {
    // ✅ EMIT LOADING DULU
    emit(AbsensiLoading());

    try {
      // ✅ SCAN QR
      await repository.scanQr(event.qrToken);

      // ✅ EMIT SUCCESS (BlocListener akan tangkap ini)
      emit(
        AbsensiScanSuccess('Absensi berhasil!'),
      );

      // ✅ DELAY SEBENTAR BIAR SUCCESS MUNCUL
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // ✅ RELOAD DATA
      final rekap = await repository
          .getRekapAbsensi(event.jadwalId);
      emit(AbsensiLoaded(rekap));
    } catch (e) {
      // ✅ EMIT ERROR
      emit(AbsensiError(e.toString()));

      // ✅ DELAY SEBENTAR
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // ✅ RELOAD DATA LAGI (MESKIPUN ERROR, TETAP TAMPILKAN DATA)
      try {
        final rekap = await repository
            .getRekapAbsensi(event.jadwalId);
        emit(AbsensiLoaded(rekap));
      } catch (_) {
        // Ignore jika reload gagal
      }
    }
  }
}
