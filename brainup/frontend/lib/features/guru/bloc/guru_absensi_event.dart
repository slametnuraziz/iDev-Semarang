abstract class GuruAbsensiEvent {}

class LoadAbsensi extends GuruAbsensiEvent {
  final int jadwalId;
  LoadAbsensi(this.jadwalId);
}

class ScanQrEvent extends GuruAbsensiEvent {
  final String qrToken;
  final int jadwalId;

  ScanQrEvent(this.qrToken, this.jadwalId);
}
