abstract class SiswaAbsensiEvent {}

class GenerateQrSiswa extends SiswaAbsensiEvent {
  final int jadwalId;

  GenerateQrSiswa(this.jadwalId);
}

class ResetQrSiswa extends SiswaAbsensiEvent {}
