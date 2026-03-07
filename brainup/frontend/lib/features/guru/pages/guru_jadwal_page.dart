import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/guru_home_bloc.dart';
import '../bloc/guru_home_event.dart';
import '../bloc/guru_home_state.dart';
import 'guru_absensi_page.dart';

class GuruJadwalPage extends StatefulWidget {
  const GuruJadwalPage({super.key});

  @override
  State<GuruJadwalPage> createState() =>
      _GuruJadwalPageState();
}

class _GuruJadwalPageState
    extends State<GuruJadwalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((
      _,
    ) {
      if (mounted) {
        final bloc = context.read<GuruHomeBloc>();
        bloc.add(LoadSiswa());
        bloc.add(LoadGuruJadwal());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body:
          BlocBuilder<
            GuruHomeBloc,
            GuruHomeState
          >(
            builder: (context, state) {
              if (state is GuruHomeLoading) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                );
              }
              if (state is GuruHomeLoaded) {
                return RefreshIndicator(
                  color: const Color(0xFF6366F1),
                  onRefresh: () async => context
                      .read<GuruHomeBloc>()
                      .add(LoadGuruJadwal()),
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(
                          20,
                          60,
                          20,
                          120,
                        ),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        "Daftar Jadwal Mengajar",
                      ),
                      const SizedBox(height: 16),
                      if (state.jadwal.isEmpty)
                        _buildEmptyState()
                      else
                        ...state.jadwal.map(
                          (j) => _buildJadwalCard(
                            context,
                            j,
                          ),
                        ),
                    ],
                  ),
                );
              }
              if (state is GuruHomeError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return const SizedBox();
            },
          ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 90,
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(
            0xFF6366F1,
          ),
          elevation: 4,
          onPressed: () =>
              _showJadwalDialog(context),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "ATUR SESI",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6366F1),
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Jadwal Mengajar",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalCard(
    BuildContext context,
    Map<String, dynamic> j,
  ) {
    // Tampilkan hari + jumlah minggu
    final hari = j['hari'] ?? '-';
    final jumlahMinggu = j['jumlah_minggu'] ?? 1;
    final jamMulai = j['jam_mulai'] ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Color(0xFF6366F1),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      j['mata_pelajaran'] ?? '-',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.repeat_rounded,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Setiap $hari • $jamMulai • $jumlahMinggu minggu",
                          style: TextStyle(
                            color:
                                Colors.grey[500],
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _confirmDelete(
                  context,
                  j['id'],
                ),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                visualDensity:
                    VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF6366F1,
                    ),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GuruAbsensiPage(
                              jadwalId: j['id'],
                              mataPelajaran:
                                  j['mata_pelajaran'] ??
                                  '-',
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    "Absensi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                  side: const BorderSide(
                    color: Color(0xFF6366F1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                onPressed: () =>
                    _showJadwalDialog(
                      context,
                      jadwal: j,
                    ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  void _showJadwalDialog(
    BuildContext context, {
    Map<String, dynamic>? jadwal,
  }) {
    final isEdit = jadwal != null;
    final mataPelajaranC = TextEditingController(
      text: jadwal?['mata_pelajaran'],
    );
    final tanggalMulaiC = TextEditingController(
      text: jadwal?['tanggal_mulai']
          ?.toString()
          .substring(0, 10),
    );
    final jamMulaiC = TextEditingController(
      text: jadwal?['jam_mulai'],
    );
    final jamSelesaiC = TextEditingController(
      text: jadwal?['jam_selesai'],
    );

    // Hari pilihan
    const daftarHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    String selectedHari =
        jadwal?['hari'] ?? 'Senin';
    int jumlahMinggu =
        jadwal?['jumlah_minggu'] ?? 4;

    final bloc = context.read<GuruHomeBloc>();
    final selectedSiswa = <int>{};

    if (isEdit &&
        jadwal!['participants'] != null) {
      for (var s in jadwal['participants']) {
        selectedSiswa.add(s['id']);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setST) => Container(
          height:
              MediaQuery.of(context).size.height *
              0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom +
                24,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEdit
                    ? "Edit Sesi Mengajar"
                    : "Tambah Sesi Baru",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // Mata Pelajaran
                      _buildInputField(
                        mataPelajaranC,
                        "Mata Pelajaran",
                        Icons.book_outlined,
                      ),
                      const SizedBox(height: 16),

                      // ✅ Pilih Hari
                      const Text(
                        "Hari",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                          color: Color(
                            0xFF1E293B,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: daftarHari.map((
                          hari,
                        ) {
                          final isSelected =
                              selectedHari ==
                              hari;
                          return ChoiceChip(
                            label: Text(hari),
                            selected: isSelected,
                            onSelected: (_) =>
                                setST(
                                  () =>
                                      selectedHari =
                                          hari,
                                ),
                            selectedColor:
                                const Color(
                                  0xFF6366F1,
                                ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(
                                      0xFF1E293B,
                                    ),
                              fontWeight:
                                  FontWeight.w600,
                              fontSize: 13,
                            ),
                            backgroundColor:
                                const Color(
                                  0xFFF1F5F9,
                                ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),
                              side:
                                  BorderSide.none,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Mulai
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now(),
                            firstDate:
                                DateTime.now(),
                            lastDate:
                                DateTime.now().add(
                                  const Duration(
                                    days: 365,
                                  ),
                                ),
                            builder: (context, child) => Theme(
                              data:
                                  Theme.of(
                                    context,
                                  ).copyWith(
                                    colorScheme:
                                        const ColorScheme.light(
                                          primary:
                                              Color(
                                                0xFF6366F1,
                                              ),
                                        ),
                                  ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setST(() {
                              tanggalMulaiC.text =
                                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: _buildInputField(
                            tanggalMulaiC,
                            "Tanggal Mulai",
                            Icons
                                .calendar_today_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Jam Mulai & Selesai
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked =
                                    await showTimePicker(
                                      context:
                                          context,
                                      initialTime:
                                          TimeOfDay.now(),
                                    );
                                if (picked !=
                                    null) {
                                  setST(() {
                                    jamMulaiC
                                            .text =
                                        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: _buildInputField(
                                  jamMulaiC,
                                  "Mulai",
                                  Icons
                                      .access_time,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked =
                                    await showTimePicker(
                                      context:
                                          context,
                                      initialTime:
                                          TimeOfDay.now(),
                                    );
                                if (picked !=
                                    null) {
                                  setST(() {
                                    jamSelesaiC
                                            .text =
                                        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: _buildInputField(
                                  jamSelesaiC,
                                  "Selesai",
                                  Icons
                                      .access_time,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ✅ Jumlah Minggu
                      const Text(
                        "Jumlah Minggu",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                          color: Color(
                            0xFF1E293B,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (jumlahMinggu >
                                  1)
                                setST(
                                  () =>
                                      jumlahMinggu--,
                                );
                            },
                            icon: const Icon(
                              Icons
                                  .remove_circle_outline,
                              color: Color(
                                0xFF6366F1,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFF1F5F9,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            child: Text(
                              "$jumlahMinggu minggu",
                              style:
                                  const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 15,
                                    color: Color(
                                      0xFF1E293B,
                                    ),
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (jumlahMinggu <
                                  52)
                                setST(
                                  () =>
                                      jumlahMinggu++,
                                );
                            },
                            icon: const Icon(
                              Icons
                                  .add_circle_outline,
                              color: Color(
                                0xFF6366F1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Peserta Didik
                      const Text(
                        "Peserta Didik",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 15,
                          color: Color(
                            0xFF1E293B,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: bloc.siswaList
                            .map(
                              (
                                s,
                              ) => CheckboxListTile(
                                contentPadding:
                                    EdgeInsets
                                        .zero,
                                title: Text(
                                  s['nama'] ??
                                      '-',
                                  style:
                                      const TextStyle(
                                        fontSize:
                                            14,
                                      ),
                                ),
                                value:
                                    selectedSiswa
                                        .contains(
                                          s['id'],
                                        ),
                                activeColor:
                                    const Color(
                                      0xFF6366F1,
                                    ),
                                onChanged: (v) => setST(
                                  () => v!
                                      ? selectedSiswa
                                            .add(
                                              s['id'],
                                            )
                                      : selectedSiswa
                                            .remove(
                                              s['id'],
                                            ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF6366F1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                  ),
                  onPressed: () {
                    if (isEdit) {
                      bloc.add(
                        EditGuruJadwal(
                          id: jadwal!['id'],
                          mataPelajaran:
                              mataPelajaranC.text,
                          hari: selectedHari,
                          tanggalMulai:
                              tanggalMulaiC.text,
                          jamMulai:
                              jamMulaiC.text,
                          jamSelesai:
                              jamSelesaiC.text,
                          jumlahMinggu:
                              jumlahMinggu,
                          siswaIds: selectedSiswa
                              .toList(),
                        ),
                      );
                    } else {
                      bloc.add(
                        CreateGuruJadwal(
                          mataPelajaran:
                              mataPelajaranC.text,
                          hari: selectedHari,
                          tanggalMulai:
                              tanggalMulaiC.text,
                          jamMulai:
                              jamMulaiC.text,
                          jamSelesai:
                              jamSelesaiC.text,
                          jumlahMinggu:
                              jumlahMinggu,
                          siswaIds: selectedSiswa
                              .toList(),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    isEdit
                        ? "Simpan Perubahan"
                        : "Buat Jadwal",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: const Color(0xFF6366F1),
        ),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF6366F1),
            width: 2,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    int id,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Hapus Jadwal?"),
        content: const Text(
          "Data jadwal yang dihapus tidak dapat dikembalikan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GuruHomeBloc>().add(
                DeleteGuruJadwal(id),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
            ),
            child: const Text(
              "Hapus",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum ada jadwal mengajar",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
