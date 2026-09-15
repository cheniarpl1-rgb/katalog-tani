import 'package:flutter/material.dart';

import 'models/barang_tani.dart';
import 'widgets/barang_tani_card.dart';
import 'pages/detail_barang_page.dart';
import 'pages/keranjang_page.dart';
import 'pages/notifikasi_page.dart';

void main() {
  runApp(const AgriMartApp());
}

// =====================================================================
// AGRIMART APP
// =====================================================================

class AgriMartApp extends StatelessWidget {
  const AgriMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF536DFE);
    const Color secondaryColor = Color(0xFFB14EFF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriMart Brantas',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF070A16),
        fontFamily: 'Roboto',
      ),
      home: const BerandaPage(),
    );
  }
}

// =====================================================================
// BERANDA
// =====================================================================

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late final TextEditingController searchController;

  String kataKunci = '';

  // ===================================================================
  // KERANJANG
  // ===================================================================

  final Map<BarangTani, int> keranjang = <BarangTani, int>{};

  // ===================================================================
  // NOTIFIKASI
  // ===================================================================

  final List<AgriNotification> notifikasi = <AgriNotification>[];

  // ===================================================================
  // DAFTAR PRODUK
  // ===================================================================

  final List<BarangTani> daftarBarang = <BarangTani>[
    BarangTani(
      nama: 'Biochar Sekam Premium',
      kategori: 'Media Tanam',
      harga: 12000,
      satuan: 'Karung',
      satuanStok: 'Karung',
      gambar:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=900&q=85',
      stok: 324,
    ),

    BarangTani(
      nama: 'Cocopeat Serat Kelapa',
      kategori: 'Media Tanam',
      harga: 9500,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=900&q=85',
      stok: 1024,
    ),

    BarangTani(
      nama: 'Pupuk Kascing Organik',
      kategori: 'Pupuk',
      harga: 28000,
      satuan: 'Karung',
      satuanStok: 'Karung',
      gambar:
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=900&q=85',
      stok: 196,
    ),

    BarangTani(
      nama: 'Pupuk Mimba Anti Hama',
      kategori: 'Pupuk',
      harga: 22000,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=900&q=85',
      stok: 0,
    ),

    BarangTani(
      nama: 'Starter Kit Tanam Sayur',
      kategori: 'Benih & Budidaya',
      harga: 68000,
      satuan: 'Kit',
      satuanStok: 'Kit',
      gambar:
          'https://images.unsplash.com/photo-1497250681960-ef046c08a56e?auto=format&fit=crop&w=900&q=85',
      stok: 49,
    ),

    BarangTani(
      nama: 'Pupuk Cair Vermi',
      kategori: 'Pupuk Cair',
      harga: 47000,
      satuan: 'Botol',
      satuanStok: 'Botol',
      gambar:
          'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?auto=format&fit=crop&w=900&q=85',
      stok: 121,
    ),

    BarangTani(
      nama: 'Nutrisi Daun Hijau Max',
      kategori: 'Pupuk',
      harga: 17500,
      satuan: 'Botol',
      satuanStok: 'Botol',
      gambar:
          'https://images.unsplash.com/photo-1591857177580-dc82b9ac4e1e?auto=format&fit=crop&w=900&q=85',
      stok: 676,
    ),

    BarangTani(
      nama: 'Media Tanam Siap Pakai',
      kategori: 'Media Tanam',
      harga: 13500,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://images.unsplash.com/photo-1591857177580-dc82b9ac4e1e?auto=format&fit=crop&w=900&q=85',
      stok: 25,
    ),
  ];

  // ===================================================================
  // INIT
  // ===================================================================

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  // ===================================================================
  // SEARCH
  // ===================================================================

  void _onSearchChanged() {
    if (!mounted) {
      return;
    }

    final String keyword =
        searchController.text.trim().toLowerCase();

    if (keyword == kataKunci) {
      return;
    }

    setState(() {
      kataKunci = keyword;
    });
  }

  // ===================================================================
  // DISPOSE
  // ===================================================================

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  // ===================================================================
  // TOTAL ITEM KERANJANG
  // ===================================================================

  int get totalItemKeranjang {
    return keranjang.values.fold<int>(
      0,
      (int total, int jumlah) {
        return total + jumlah;
      },
    );
  }

  // ===================================================================
  // TAMBAH KE KERANJANG
  // ===================================================================

  void tambahKeKeranjang(
    BarangTani barang,
    int jumlah,
  ) {
    if (jumlah <= 0) {
      return;
    }

    if (barang.stok <= 0) {
      return;
    }

    setState(() {
      final int jumlahLama = keranjang[barang] ?? 0;
      final int jumlahBaru = jumlahLama + jumlah;

      final int jumlahFinal =
          jumlahBaru > barang.stok
              ? barang.stok
              : jumlahBaru;

      keranjang[barang] = jumlahFinal;

      notifikasi.insert(
        0,
        AgriNotification(
          title: 'Barang masuk keranjang',
          message:
              '$jumlah ${barang.satuanStok} ${barang.nama} berhasil ditambahkan.',
          icon: Icons.shopping_cart_rounded,
          primaryColor: const Color(0xFF00F5A0),
          secondaryColor: const Color(0xFF00D9FF),
          time: DateTime.now(),
        ),
      );
    });
  }

  // ===================================================================
  // BUKA KERANJANG
  // ===================================================================

  Future<void> bukaKeranjang() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return KeranjangPage(
            keranjang: keranjang,
            onKeranjangChanged: () {
              if (!mounted) {
                return;
              }

              setState(() {});
            },
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===================================================================
  // BUKA NOTIFIKASI
  // ===================================================================

  Future<void> bukaNotifikasi() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return NotifikasiPage(
            notifikasi: notifikasi,
            onReadAll: _tandaiSemuaNotifikasiDibaca,
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ===================================================================
  // TANDAI NOTIFIKASI
  // ===================================================================

  void _tandaiSemuaNotifikasiDibaca() {
    if (notifikasi.isEmpty) {
      return;
    }

    setState(() {
      for (final AgriNotification item in notifikasi) {
        item.isRead = true;
      }
    });
  }

  // ===================================================================
  // DETAIL
  // ===================================================================

  void bukaDetailBarang(
    BuildContext context,
    BarangTani barang,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return DetailBarangPage(
            barang: barang,
            onAddToCart: (int jumlah) {
              tambahKeKeranjang(
                barang,
                jumlah,
              );
            },
          );
        },
      ),
    );
  }

  // ===================================================================
  // FILTER + SORT
  // ===================================================================

  List<BarangTani> get barangTersaring {
    final List<BarangTani> hasil;

    if (kataKunci.isEmpty) {
      hasil = List<BarangTani>.from(
        daftarBarang,
      );
    } else {
      hasil = daftarBarang.where(
        (BarangTani barang) {
          final String nama =
              barang.nama.toLowerCase();

          final String kategori =
              barang.kategori.toLowerCase();

          return nama.contains(kataKunci) ||
              kategori.contains(kataKunci);
        },
      ).toList();
    }

    hasil.sort(
      (BarangTani a, BarangTani b) {
        final bool aHabis = a.stok <= 0;
        final bool bHabis = b.stok <= 0;

        if (aHabis != bHabis) {
          return aHabis ? 1 : -1;
        }

        return 0;
      },
    );

    return hasil;
  }

  // ===================================================================
  // STATISTIK
  // ===================================================================

  int hitungTotalStok() {
    return daftarBarang.fold<int>(
      0,
      (int total, BarangTani barang) {
        return total + barang.stok;
      },
    );
  }

  int hitungStokTersedia() {
    return daftarBarang.where(
      (BarangTani barang) {
        return barang.stok > 0;
      },
    ).length;
  }

  int hitungStokHabis() {
    return daftarBarang.where(
      (BarangTani barang) {
        return barang.stok <= 0;
      },
    ).length;
  }

  // ===================================================================
  // BUILD
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    final List<BarangTani> hasil =
        barangTersaring;

    final int jumlahNotifikasiBelumDibaca =
        notifikasi.where(
      (AgriNotification item) {
        return !item.isRead;
      },
    ).length;

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFF070A16),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF090D20),
              Color(0xFF070A16),
              Color(0xFF050710),
            ],
          ),
        ),

        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            // =========================================================
            // HEADER
            // =========================================================

            SliverToBoxAdapter(
              child: _LuxuryHeader(
                searchController: searchController,
                kataKunci: kataKunci,
                totalItemKeranjang:
                    totalItemKeranjang,
                jumlahNotifikasi:
                    jumlahNotifikasiBelumDibaca,
                onCartPressed:
                    bukaKeranjang,
                onNotificationPressed:
                    bukaNotifikasi,
              ),
            ),

            // =========================================================
            // STATISTIK
            // =========================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  0,
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: _LuxuryStatisticCard(
                        icon:
                            Icons.inventory_2_rounded,
                        title: 'Jenis Barang',
                        value:
                            '${daftarBarang.length}',
                        subtitle: 'Produk',
                        iconColor:
                            const Color(0xFFB9C4FF),
                        primaryColor:
                            const Color(0xFF536DFE),
                        secondaryColor:
                            const Color(0xFF9C4DFF),
                        darkColor:
                            const Color(0xFF17114A),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _LuxuryStatisticCard(
                        icon:
                            Icons.warehouse_rounded,
                        title: 'Total Stok',
                        value:
                            '${hitungTotalStok()}',
                        subtitle: 'Unit',
                        iconColor:
                            const Color(0xFFB9FFE7),
                        primaryColor:
                            const Color(0xFF00F5A0),
                        secondaryColor:
                            const Color(0xFF00B8D4),
                        darkColor:
                            const Color(0xFF063D3A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // STATUS
            // =========================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  0,
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: _LuxuryStatusCard(
                        icon:
                            Icons.check_circle_rounded,
                        title: 'Tersedia',
                        value:
                            '${hitungStokTersedia()}',
                        primaryColor:
                            const Color(0xFFFF4ECD),
                        secondaryColor:
                            const Color(0xFF9C27FF),
                        darkColor:
                            const Color(0xFF3A0D46),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _LuxuryStatusCard(
                        icon:
                            Icons.warning_rounded,
                        title: 'Stok Habis',
                        value:
                            '${hitungStokHabis()}',
                        primaryColor:
                            const Color(0xFFFFD166),
                        secondaryColor:
                            const Color(0xFFFF5A36),
                        darkColor:
                            const Color(0xFF4A170D),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // JUDUL PRODUK
            // =========================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  30,
                  16,
                  15,
                ),

                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          begin:
                              Alignment.topCenter,
                          end:
                              Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00F5A0),
                            Color(0xFF536DFE),
                            Color(0xFFD06BFF),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(
                              0xFF536DFE,
                            ).withValues(
                              alpha: 0.60,
                            ),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            kataKunci.isEmpty
                                ? 'Produk Pertanian'
                                : 'Hasil Pencarian',

                            style:
                                const TextStyle(
                              color:
                                  Color(0xFFF7F8FF),
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${hasil.length} barang ditampilkan',

                            style:
                                const TextStyle(
                              color:
                                  Color(0xFF8992B2),
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 10,
                      ),

                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF1B2250),
                            Color(0xFF24163F),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(14),

                        border: Border.all(
                          color:
                              const Color(
                            0xFF536DFE,
                          ).withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),

                      child: const Icon(
                        Icons.grid_view_rounded,
                        color:
                            Color(0xFFAEB8FF),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // PRODUK
            // =========================================================

            if (hasil.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _LuxuryEmptyState(),
              )
            else if (screenWidth < 600)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  40,
                ),

                sliver: SliverList(
                  delegate:
                      SliverChildBuilderDelegate(
                    (
                      BuildContext context,
                      int index,
                    ) {
                      final BarangTani barang =
                          hasil[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        child: BarangTaniCard(
                          barang: barang,
                          onTap: () {
                            bukaDetailBarang(
                              context,
                              barang,
                            );
                          },
                        ),
                      );
                    },

                    childCount: hasil.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  40,
                ),

                sliver: SliverGrid(
                  delegate:
                      SliverChildBuilderDelegate(
                    (
                      BuildContext context,
                      int index,
                    ) {
                      final BarangTani barang =
                          hasil[index];

                      return BarangTaniCard(
                        barang: barang,
                        onTap: () {
                          bukaDetailBarang(
                            context,
                            barang,
                          );
                        },
                      );
                    },

                    childCount: hasil.length,
                  ),

                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        screenWidth < 950
                            ? 2
                            : 3,

                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,

                    childAspectRatio:
                        screenWidth < 950
                            ? 0.76
                            : 0.82,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// HEADER
// =====================================================================

class _LuxuryHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String kataKunci;
  final int totalItemKeranjang;
  final int jumlahNotifikasi;
  final VoidCallback onCartPressed;
  final VoidCallback onNotificationPressed;

  const _LuxuryHeader({
    required this.searchController,
    required this.kataKunci,
    required this.totalItemKeranjang,
    required this.jumlahNotifikasi,
    required this.onCartPressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top:
            MediaQuery.paddingOf(context).top +
                14,
        left: 20,
        right: 20,
        bottom: 30,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B1030),
            Color(0xFF171D4C),
            Color(0xFF321653),
            Color(0xFF11152D),
          ],
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,

                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF00F5A0),
                      Color(0xFF536DFE),
                      Color(0xFFD06BFF),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(
                        0xFF536DFE,
                      ).withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 20,
                      offset:
                          const Offset(0, 8),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.agriculture_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'AgriMart',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 1),

                    Text(
                      'BRANTAS • PREMIUM AGRI STORE',

                      style: TextStyle(
                        color:
                            Color(0xFFAAB4F0),
                        fontSize: 8.5,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              _HeaderActionButton(
                icon:
                    Icons.shopping_bag_rounded,
                badge:
                    totalItemKeranjang,
                gradient: const [
                  Color(0xFF00F5A0),
                  Color(0xFF00A6FF),
                ],
                shadowColor:
                    const Color(0xFF00F5A0),
                tooltip: 'Keranjang',
                onPressed:
                    onCartPressed,
              ),

              const SizedBox(width: 9),

              _HeaderActionButton(
                icon:
                    Icons.notifications_rounded,
                badge:
                    jumlahNotifikasi,
                gradient: const [
                  Color(0xFFFF4ECD),
                  Color(0xFF8E44FF),
                ],
                shadowColor:
                    const Color(0xFFFF4ECD),
                tooltip: 'Notifikasi',
                onPressed:
                    onNotificationPressed,
              ),
            ],
          ),

          const SizedBox(height: 26),

          const Text(
            'Selamat datang 👋',

            style: TextStyle(
              color: Color(0xFFB8C0F0),
              fontSize: 13,
              fontWeight:
                  FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Kelola kebutuhan\npertanianmu dengan mudah.',

            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight:
                  FontWeight.w900,
              height: 1.12,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: searchController,
            textInputAction:
                TextInputAction.search,

            style: const TextStyle(
              color: Color(0xFFF7F8FF),
              fontWeight:
                  FontWeight.w600,
            ),

            decoration:
                InputDecoration(
              filled: true,

              fillColor:
                  const Color(0xFF171D38),

              hintText:
                  'Cari produk atau kategori...',

              hintStyle:
                  const TextStyle(
                color:
                    Color(0xFF858DAA),
                fontSize: 14,
              ),

              prefixIcon:
                  const Icon(
                Icons.search_rounded,
                color:
                    Color(0xFF7C8CFF),
              ),

              suffixIcon:
                  kataKunci.isNotEmpty
                      ? IconButton(
                          onPressed:
                              searchController
                                  .clear,
                          icon:
                              const Icon(
                            Icons.close_rounded,
                            color:
                                Color(
                              0xFF9CA4C1,
                            ),
                          ),
                        )
                      : null,

              contentPadding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 18,
                vertical: 17,
              ),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                borderSide:
                    BorderSide.none,
              ),

              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                borderSide:
                    BorderSide(
                  color:
                      const Color(
                    0xFF7180FF,
                  ).withValues(
                    alpha: 0.18,
                  ),
                ),
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                borderSide:
                    const BorderSide(
                  color:
                      Color(0xFF7C8CFF),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HEADER BUTTON
// =====================================================================

class _HeaderActionButton
    extends StatelessWidget {
  final IconData icon;
  final int badge;
  final List<Color> gradient;
  final Color shadowColor;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.icon,
    required this.badge,
    required this.gradient,
    required this.shadowColor,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46,
          height: 46,

          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: gradient,
            ),

            shape: BoxShape.circle,

            boxShadow: [
              BoxShadow(
                color:
                    shadowColor
                        .withValues(
                  alpha: 0.40,
                ),
                blurRadius: 18,
                offset:
                    const Offset(0, 7),
              ),
            ],
          ),

          child: IconButton(
            tooltip: tooltip,
            onPressed: onPressed,

            icon: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),

        if (badge > 0)
          Positioned(
            top: -5,
            right: -5,

            child: Container(
              constraints:
                  const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 5,
              ),

              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFFFFD166),
                    Color(0xFFFF5A36),
                  ],
                ),

                shape: BoxShape.circle,

                border: Border.all(
                  color:
                      const Color(
                    0xFF171D4C,
                  ),
                  width: 2,
                ),
              ),

              child: Center(
                child: Text(
                  badge > 99
                      ? '99+'
                      : '$badge',

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// =====================================================================
// STATISTIC CARD
// =====================================================================

class _LuxuryStatisticCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color iconColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color darkColor;

  const _LuxuryStatisticCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(
        minHeight: 165,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(25),

        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,

          colors: [
            Color.alphaBlend(
              primaryColor.withValues(
                alpha: 0.28,
              ),
              const Color(
                0xFF15172B,
              ),
            ),

            Color.alphaBlend(
              secondaryColor.withValues(
                alpha: 0.20,
              ),
              darkColor,
            ),

            const Color(
              0xFF080A17,
            ),
          ],
        ),

        border:
            Border.all(
          color:
              primaryColor.withValues(
            alpha: 0.38,
          ),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color:
                primaryColor.withValues(
              alpha: 0.22,
            ),
            blurRadius: 28,
            offset:
                const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 48,
            height: 48,

            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,

            style: TextStyle(
              color:
                  primaryColor.withValues(
                alpha: 0.90,
              ),
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Flexible(
                child: Text(
                  value,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color:
                        Color(0xFFF8FAFF),
                    fontSize: 27,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 5,
                ),

                child: Text(
                  subtitle,

                  style:
                      const TextStyle(
                    color:
                        Color(0xFF8C95B4),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// STATUS CARD
// =====================================================================

class _LuxuryStatusCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color darkColor;

  const _LuxuryStatusCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),

        gradient:
            LinearGradient(
          colors: [
            Color.alphaBlend(
              primaryColor.withValues(
                alpha: 0.25,
              ),
              const Color(
                0xFF15172B,
              ),
            ),

            Color.alphaBlend(
              secondaryColor.withValues(
                alpha: 0.18,
              ),
              darkColor,
            ),

            const Color(
              0xFF080A16,
            ),
          ],
        ),

        border:
            Border.all(
          color:
              primaryColor.withValues(
            alpha: 0.35,
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),

              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title == 'Tersedia'
                      ? 'Produk siap'
                      : 'Perlu restock',

                  style:
                      const TextStyle(
                    color:
                        Color(0xFF8A93B1),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Text(
            value,

            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _LuxuryEmptyState
    extends StatelessWidget {
  const _LuxuryEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 100,
              height: 100,

              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF536DFE),
                    Color(0xFF8E44FF),
                    Color(0xFF24104D),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(31),
              ),

              child: const Icon(
                Icons.search_off_rounded,
                size: 47,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Barang tidak ditemukan',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    Color(0xFFF5F7FF),
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Coba gunakan nama barang atau kategori lain.',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    Color(0xFF7E86A5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}