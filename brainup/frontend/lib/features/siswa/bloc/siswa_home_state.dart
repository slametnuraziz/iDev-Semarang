abstract class SiswaHomeState {}

class SiswaHomeInitial extends SiswaHomeState {}

class SiswaHomeLoading extends SiswaHomeState {}

class SiswaHomeLoaded extends SiswaHomeState {
  final List<dynamic> jadwal;
  SiswaHomeLoaded(this.jadwal);
}

class SiswaProfileLoaded extends SiswaHomeState {
  // <--- baru
  final Map<String, dynamic> profile;
  SiswaProfileLoaded(this.profile);
}

class SiswaHomeError extends SiswaHomeState {
  final String message;
  SiswaHomeError(this.message);
}
