import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() =>
      _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> guruList = [];
  List<dynamic> filteredGuruList = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController _searchController =
      TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchGuru();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchGuru() async {
    try {
      setState(() => isLoading = true);

      final response = await http.get(
        Uri.parse(
          'http://192.168.137.1:3000/api/guru',
        ),
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(
          response.body,
        );

        debugPrint("API Response: $responseBody");
        debugPrint(
          "Response Type: ${responseBody.runtimeType}",
        );

        List<dynamic> dataList = [];

        // Handle berbagai format response
        if (responseBody is List) {
          dataList = responseBody;
        } else if (responseBody is Map) {
          if (responseBody.containsKey('data')) {
            dataList =
                responseBody['data'] as List;
          } else {
            dataList = [responseBody];
          }
        }

        setState(() {
          guruList = dataList;
          filteredGuruList = dataList;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        throw Exception(
          'Failed to load guru: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching guru: $e');
      if (mounted) {
        _showErrorSnackbar(
          'Gagal memuat data guru',
        );
      }
    }
  }

  void _filterGuru(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredGuruList = guruList;
      } else {
        filteredGuruList = guruList.where((guru) {
          final nama = (guru["nama"] ?? "")
              .toString()
              .toLowerCase();
          final nip = (guru["nip"] ?? "")
              .toString()
              .toLowerCase();
          final searchLower = query.toLowerCase();
          return nama.contains(searchLower) ||
              nip.contains(searchLower);
        }).toList();
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(),
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          "${filteredGuruList.length} guru ditemukan",
                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _searchController
                                .clear();
                            _filterGuru('');
                          },
                          child: const Text(
                            'Hapus Filter',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF6366F1),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Memuat data guru...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredGuruList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                            24,
                          ),
                      decoration: BoxDecoration(
                        color:
                            Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        searchQuery.isEmpty
                            ? Icons
                                  .people_outline_rounded
                            : Icons
                                  .search_off_rounded,
                        size: 64,
                        color:
                            Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? "Tidak Ada Data Guru"
                          : "Guru Tidak Ditemukan",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      searchQuery.isEmpty
                          ? "Belum ada data guru yang tersedia"
                          : "Coba kata kunci pencarian lain",
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),
              sliver: SliverList(
                delegate:
                    SliverChildBuilderDelegate(
                      (context, index) {
                        final guru =
                            filteredGuruList[index];
                        return _buildGuruCard(
                          guru,
                          index,
                        );
                      },
                      childCount:
                          filteredGuruList.length,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: 20,
          bottom: 16,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Guru",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            if (!isLoading)
              Text(
                "${guruList.length} Total Guru",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                0xFF6366F1,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF6366F1),
              size: 20,
            ),
          ),
          onPressed: fetchGuru,
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterGuru,
        decoration: InputDecoration(
          hintText: "Cari nama atau NIP guru...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _filterGuru('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
        ),
      ),
    );
  }

  Widget _buildGuruCard(
    Map<String, dynamic> guru,
    int index,
  ) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
    ];
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              _showGuruDetail(context, guru),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'guru_${guru["id"]}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end:
                            Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                      boxShadow: [
                        BoxShadow(
                          color: color
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(
                          guru["nama"] ?? "-",
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        guru["nama"] ?? "-",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                            decoration: BoxDecoration(
                              color: color
                                  .withOpacity(
                                    0.1,
                                  ),
                              borderRadius:
                                  BorderRadius.circular(
                                    6,
                                  ),
                            ),
                            child: Text(
                              "NIP: ${guru["nip"] ?? "-"}",
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (guru["email"] !=
                          null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .email_outlined,
                              size: 14,
                              color: Colors
                                  .grey
                                  .shade500,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                guru["email"] ??
                                    "-",
                                style: TextStyle(
                                  color: Colors
                                      .grey
                                      .shade600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0])
          .toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "?";
  }

  void _showGuruDetail(
    BuildContext context,
    Map<String, dynamic> guru,
  ) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
    ];
    final color =
        colors[(guru["id"] ?? 0) % colors.length];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height:
            MediaQuery.of(context).size.height *
            0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF8F9FD),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(
                top: 12,
                bottom: 20,
              ),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                    BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'guru_${guru["id"]}',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.3),
                        borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(
                            guru["nama"] ?? "-",
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    guru["nama"] ?? "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                    ),
                    child: Text(
                      "NIP: ${guru["nip"] ?? "-"}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _detailItem(
                        icon: Icons.wc_rounded,
                        label: "Jenis Kelamin",
                        value:
                            guru["jenis_kelamin"] ??
                            "-",
                        color: color,
                        isFirst: true,
                      ),
                      _detailItem(
                        icon: Icons
                            .location_on_outlined,
                        label: "Tempat Lahir",
                        value:
                            guru["tempat_lahir"] ??
                            "-",
                        color: color,
                      ),
                      _detailItem(
                        icon: Icons.cake_outlined,
                        label: "Tanggal Lahir",
                        value:
                            guru["tanggal_lahir"]
                                ?.split("T")[0] ??
                            "-",
                        color: color,
                      ),
                      _detailItem(
                        icon:
                            Icons.email_outlined,
                        label: "Email",
                        value:
                            guru["email"] ?? "-",
                        color: color,
                      ),
                      _detailItem(
                        icon:
                            Icons.school_outlined,
                        label:
                            "Pendidikan Terakhir",
                        value:
                            guru["pendidikan_terakhir"] ??
                            "-",
                        color: color,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tutup",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.shade200,
                ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
