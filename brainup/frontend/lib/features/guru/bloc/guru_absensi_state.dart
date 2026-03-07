abstract class GuruAbsensiState {}

class AbsensiInitial extends GuruAbsensiState {}

class AbsensiLoading extends GuruAbsensiState {}

class AbsensiLoaded extends GuruAbsensiState {
  final List<dynamic> rekap;
  AbsensiLoaded(this.rekap);
}

class AbsensiScanSuccess
    extends GuruAbsensiState {
  final String message;
  AbsensiScanSuccess(this.message);
}

class AbsensiError extends GuruAbsensiState {
  final String message;
  AbsensiError(this.message);
}
