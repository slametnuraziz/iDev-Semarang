abstract class GuruHomeState {}

class GuruHomeInitial extends GuruHomeState {}

class GuruHomeLoading extends GuruHomeState {}

class GuruHomeLoaded extends GuruHomeState {
  final List<dynamic> jadwal;
  final List<dynamic>
  siswaList; // optional, untuk UI
  GuruHomeLoaded(
    this.jadwal, {
    this.siswaList = const [],
  });
}

class GuruHomeError extends GuruHomeState {
  final String message;
  GuruHomeError(this.message);
}
