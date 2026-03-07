abstract class SiswaAbsensiState {}

class AbsensiSiswaInitial
    extends SiswaAbsensiState {}

class AbsensiSiswaLoading
    extends SiswaAbsensiState {}

class AbsensiSiswaQrReady
    extends SiswaAbsensiState {
  final String qrToken;

  AbsensiSiswaQrReady(this.qrToken);
}

class AbsensiSiswaError
    extends SiswaAbsensiState {
  final String message;

  AbsensiSiswaError(this.message);
}
