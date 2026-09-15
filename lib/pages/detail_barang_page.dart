import 'package:flutter/material.dart';

import '../models/barang_tani.dart';
import '../widgets/pemilih_jumlah.dart';

class DetailBarangPage extends StatefulWidget {
  final BarangTani barang;
  final ValueChanged<int>? onAddToCart;

  const DetailBarangPage({
    super.key,
    required this.barang,
    this.onAddToCart,
  });

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  int jumlah = 1;

  double get hargaSatuan => widget.barang.harga.toDouble();

  double get subtotal => hargaSatuan * jumlah;

  double get persentaseDiskon {
    if (jumlah >= 25) {
      return 0.10;
    }

    if (jumlah >= 10) {
      return 0.05;
    }

    return 0;
  }

  double get jumlahDiskon => subtotal * persentaseDiskon;

  double get totalHarga => subtotal - jumlahDiskon;

  bool get stokTersedia => widget.barang.stok > 0;

  // ===================================================================
  // UBAH JUMLAH
  // ===================================================================

  void ubahJumlah(int value) {
    if (!stokTersedia) return;

    setState(() {
      jumlah = value.clamp(1, widget.barang.stok);
    });
  }

  // ===================================================================
  // FORMAT RUPIAH
  // ===================================================================

  String formatRupiah(double value) {
    final String angka = value.round().toString();
    final StringBuffer hasil = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      if (i > 0 && (angka.length - i) % 3 == 0) {
        hasil.write('.');
      }

      hasil.write(angka[i]);
    }

    return 'Rp$hasil';
  }

  // ===================================================================
  // MASUKKAN KE KERANJANG
  // ===================================================================

  void masukkanKeKeranjang() {
    if (!stokTersedia) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          content: const _LuxuryErrorSnackBar(
            message: 'Maaf, stok barang sedang habis.',
          ),
        ),
      );

      return;
    }

    widget.onAddToCart?.call(jumlah);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 18),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: _LuxurySuccessSnackBar(
          jumlah: jumlah,
          satuan: widget.barang.satuan,
          namaBarang: widget.barang.nama,
          total: formatRupiah(totalHarga),
          diskonAktif: persentaseDiskon > 0,
        ),
      ),
    );
  }

  // ===================================================================
  // WARNA ACCENT
  // ===================================================================

  Color get accentColor {
    switch (widget.barang.kategori.toLowerCase()) {
      case 'bibit':
        return const Color(0xFF00F5A0);

      case 'pupuk':
        return const Color(0xFFD06BFF);

      case 'alat':
        return const Color(0xFF62A8FF);

      default:
        return const Color(0xFFFFC857);
    }
  }

  // ===================================================================
  // HERO GRADIENT
  // ===================================================================

  List<Color> get heroGradient {
    switch (widget.barang.kategori.toLowerCase()) {
      case 'bibit':
        return const [
          Color(0xFF00695C),
          Color(0xFF00BFA5),
          Color(0xFF00F5A0),
          Color(0xFF00D9FF),
        ];

      case 'pupuk':
        return const [
          Color(0xFF4A148C),
          Color(0xFF8E44FF),
          Color(0xFFD06BFF),
          Color(0xFFFF4ECD),
        ];

      case 'alat':
        return const [
          Color(0xFF172A88),
          Color(0xFF4169E1),
          Color(0xFF62A8FF),
          Color(0xFF00D9FF),
        ];

      default:
        return const [
          Color(0xFFE65100),
          Color(0xFFFF6D00),
          Color(0xFFFF9800),
          Color(0xFFFFD166),
        ];
    }
  }

  // ===================================================================
  // ICON KATEGORI
  // ===================================================================

  IconData get kategoriIcon {
    switch (widget.barang.kategori.toLowerCase()) {
      case 'bibit':
        return Icons.eco_rounded;

      case 'pupuk':
        return Icons.grass_rounded;

      case 'alat':
        return Icons.handyman_rounded;

      default:
        return Icons.inventory_2_rounded;
    }
  }

  // ===================================================================
  // BUILD
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    final bool sedangDiskon = persentaseDiskon > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF050714),

      // ===============================================================
      // APP BAR
      // ===============================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Rincian Barang',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      // ===============================================================
      // BODY
      // ===============================================================

      body: Stack(
        children: [
          // =============================================================
          // BACKGROUND GLOW
          // =============================================================

          const Positioned(
            top: -130,
            right: -110,
            child: _BackgroundGlow(
              size: 330,
              color: Color(0xFF536DFE),
            ),
          ),

          const Positioned(
            top: 280,
            left: -160,
            child: _BackgroundGlow(
              size: 360,
              color: Color(0xFF00F5A0),
            ),
          ),

          const Positioned(
            bottom: -170,
            right: -130,
            child: _BackgroundGlow(
              size: 360,
              color: Color(0xFFD06BFF),
            ),
          ),

          // =============================================================
          // CONTENT
          // =============================================================

          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                18,
                8,
                18,
                35,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =======================================================
                  // HERO PRODUK + GAMBAR
                  // =======================================================

                  _HeroProductCard(
                    barang: widget.barang,
                    accentColor: accentColor,
                    gradientColors: heroGradient,
                    icon: kategoriIcon,
                  ),

                  const SizedBox(height: 20),

                  // =======================================================
                  // INFORMASI BARANG
                  // =======================================================

                  const _SectionTitle(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Informasi Barang',
                  ),

                  const SizedBox(height: 11),

                  _InfoCard(
                    icon: Icons.category_rounded,
                    label: 'Kategori',
                    value: widget.barang.kategori,
                    color: accentColor,
                  ),

                  _InfoCard(
                    icon: Icons.payments_rounded,
                    label: 'Harga Satuan',
                    value: formatRupiah(hargaSatuan),
                    color: const Color(0xFF00D9FF),
                  ),

                  _InfoCard(
                    icon: Icons.inventory_2_rounded,
                    label: 'Stok Tersedia',
                    value:
                        '${widget.barang.stok} ${widget.barang.satuan}',
                    color: stokTersedia
                        ? const Color(0xFF00F5A0)
                        : const Color(0xFFFF4567),
                  ),

                  _InfoCard(
                    icon: stokTersedia
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    label: 'Status',
                    value: stokTersedia
                        ? 'Tersedia'
                        : 'STOK HABIS',
                    color: stokTersedia
                        ? const Color(0xFF00F5A0)
                        : const Color(0xFFFF4567),
                    isLast: true,
                  ),

                  const SizedBox(height: 20),

                  // =======================================================
                  // ATUR PEMBELIAN
                  // =======================================================

                  const _SectionTitle(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Atur Pembelian',
                  ),

                  const SizedBox(height: 11),

                  _QuantityCard(
                    jumlah: jumlah,
                    stok: widget.barang.stok,
                    satuan: widget.barang.satuan,
                    accentColor: accentColor,
                    onChanged: ubahJumlah,
                  ),

                  const SizedBox(height: 14),

                  _DiscountInfoCard(
                    jumlah: jumlah,
                    sedangDiskon: sedangDiskon,
                    persentaseDiskon: persentaseDiskon,
                  ),

                  const SizedBox(height: 20),

                  // =======================================================
                  // RINGKASAN HARGA
                  // =======================================================

                  _PriceSummaryCard(
                    subtotal: subtotal,
                    diskon: jumlahDiskon,
                    total: totalHarga,
                    formatRupiah: formatRupiah,
                    accentColor: accentColor,
                  ),

                  const SizedBox(height: 20),

                  // =======================================================
                  // BUTTON KERANJANG
                  // =======================================================

                  _LuxuryCartButton(
                    enabled: stokTersedia,
                    accentColor: accentColor,
                    onPressed: masukkanKeKeranjang,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// LUXURY SUCCESS SNACKBAR
// =====================================================================

class _LuxurySuccessSnackBar extends StatelessWidget {
  final int jumlah;
  final String satuan;
  final String namaBarang;
  final String total;
  final bool diskonAktif;

  const _LuxurySuccessSnackBar({
    required this.jumlah,
    required this.satuan,
    required this.namaBarang,
    required this.total,
    required this.diskonAktif,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C896),
            Color(0xFF00A6FF),
            Color(0xFF536DFE),
            Color(0xFF8E44FF),
            Color(0xFFFF4ECD),
          ],
          stops: [
            0.0,
            0.25,
            0.52,
            0.78,
            1.0,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F5A0)
                .withValues(alpha: 0.30),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFFFF4ECD)
                .withValues(alpha: 0.22),
            blurRadius: 35,
            offset: const Offset(8, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -25,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -45,
            left: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00F5A0)
                        .withValues(alpha: 0.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.30),
                      Colors.white.withValues(alpha: 0.10),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.20),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Berhasil masuk keranjang! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$jumlah $satuan • $namaBarang',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.90),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.payments_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            total,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (diskonAktif) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Text(
                              'DISKON AKTIF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
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
// LUXURY ERROR SNACKBAR
// =====================================================================

class _LuxuryErrorSnackBar extends StatelessWidget {
  final String message;

  const _LuxuryErrorSnackBar({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF416C),
            Color(0xFFFF4B2B),
            Color(0xFFFF7A18),
            Color(0xFFFFC857),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF416C)
                .withValues(alpha: 0.30),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.30),
              ),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HERO PRODUCT CARD
// =====================================================================

class _HeroProductCard extends StatelessWidget {
  final BarangTani barang;
  final Color accentColor;
  final List<Color> gradientColors;
  final IconData icon;

  const _HeroProductCard({
    required this.barang,
    required this.accentColor,
    required this.gradientColors,
    required this.icon,
  });

  bool get stokHabis => barang.stok <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stokHabis
              ? const [
                  Color(0xFF41444B),
                  Color(0xFF303239),
                  Color(0xFF22242A),
                  Color(0xFF15171C),
                ]
              : [
                  gradientColors[0],
                  gradientColors[1],
                  gradientColors[2],
                  gradientColors[3].withValues(alpha: 0.78),
                ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: stokHabis
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.24),
          width: 1.2,
        ),
        boxShadow: stokHabis
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.30),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 32,
                  spreadRadius: 1,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: gradientColors[3]
                      .withValues(alpha: 0.18),
                  blurRadius: 40,
                  offset: const Offset(10, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // ===========================================================
            // DECORATIVE GLOW
            // ===========================================================

            if (!stokHabis) ...[
              Positioned(
                top: -55,
                right: -45,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -65,
                left: -45,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // ===========================================================
            // CONTENT
            // ===========================================================

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // TOP BAR
                  // =====================================================

                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: stokHabis
                                ? [
                                    Colors.white.withValues(alpha: 0.12),
                                    Colors.white.withValues(alpha: 0.05),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.32),
                                    Colors.white.withValues(alpha: 0.10),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: stokHabis ? 0.10 : 0.32,
                            ),
                          ),
                          boxShadow: stokHabis
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.white.withValues(
                                      alpha: 0.15,
                                    ),
                                    blurRadius: 22,
                                  ),
                                ],
                        ),
                        child: Icon(
                          icon,
                          size: 31,
                          color: stokHabis
                              ? const Color(0xFF9A9EA7)
                              : Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: stokHabis
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: stokHabis ? 0.10 : 0.28,
                            ),
                          ),
                        ),
                        child: Text(
                          stokHabis
                              ? 'STOK HABIS'
                              : barang.kategori.toUpperCase(),
                          style: TextStyle(
                            color: stokHabis
                                ? const Color(0xFFB4B7BE)
                                : Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // =====================================================
                  // PRODUCT IMAGE
                  // =====================================================

                  _ProductImage(
                    imageUrl: barang.gambar,
                    icon: icon,
                    stokHabis: stokHabis,
                  ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // PRODUCT NAME
                  // =====================================================

                  Text(
                    barang.nama,
                    style: TextStyle(
                      color: stokHabis
                          ? const Color(0xFFB5B8BF)
                          : Colors.white,
                      fontSize: 23,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    stokHabis
                        ? 'Produk sedang tidak tersedia untuk pembelian.'
                        : 'Produk berkualitas untuk kebutuhan pertanian Anda.',
                    style: TextStyle(
                      color: stokHabis
                          ? const Color(0xFF777C85)
                          : Colors.white.withValues(alpha: 0.82),
                      fontSize: 12.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =====================================================
                  // PRICE + STOCK
                  // =====================================================

                  Row(
                    children: [
                      Icon(
                        Icons.payments_rounded,
                        color: stokHabis
                            ? const Color(0xFF777C85)
                            : Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _formatSimpleRupiah(
                          barang.harga.toDouble(),
                        ),
                        style: TextStyle(
                          color: stokHabis
                              ? const Color(0xFF858992)
                              : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '/${barang.satuan}',
                        style: TextStyle(
                          color: stokHabis
                              ? const Color(0xFF696E77)
                              : Colors.white.withValues(alpha: 0.72),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =====================================================
                  // STOCK BADGE
                  // =====================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: stokHabis
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: stokHabis
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          stokHabis
                              ? Icons.remove_circle_outline_rounded
                              : Icons.inventory_2_rounded,
                          size: 15,
                          color: stokHabis
                              ? const Color(0xFF858992)
                              : Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          stokHabis
                              ? 'Stok 0 ${barang.satuan}'
                              : 'Stok ${barang.stok} ${barang.satuan}',
                          style: TextStyle(
                            color: stokHabis
                                ? const Color(0xFF858992)
                                : Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatSimpleRupiah(double value) {
    final String angka = value.round().toString();
    final StringBuffer hasil = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      if (i > 0 && (angka.length - i) % 3 == 0) {
        hasil.write('.');
      }

      hasil.write(angka[i]);
    }

    return 'Rp$hasil';
  }
}

// =====================================================================
// PRODUCT IMAGE
// =====================================================================

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final bool stokHabis;

  const _ProductImage({
    required this.imageUrl,
    required this.icon,
    required this.stokHabis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 205,
      decoration: BoxDecoration(
        color: stokHabis
            ? Colors.black.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: stokHabis ? 0.08 : 0.18,
          ),
        ),
        boxShadow: stokHabis
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ===========================================================
            // IMAGE
            // ===========================================================

            _NetworkProductImage(
              imageUrl: imageUrl,
              icon: icon,
              stokHabis: stokHabis,
            ),

            // ===========================================================
            // IMAGE OVERLAY
            // ===========================================================

            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: stokHabis ? 0.20 : 0.08,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===========================================================
            // IMAGE LABEL
            // ===========================================================

            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      stokHabis
                          ? Icons.visibility_off_rounded
                          : Icons.photo_rounded,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      stokHabis ? 'TIDAK TERSEDIA' : 'PRODUK',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.90),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
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
// NETWORK PRODUCT IMAGE
// =====================================================================

class _NetworkProductImage extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final bool stokHabis;

  const _NetworkProductImage({
    required this.imageUrl,
    required this.icon,
    required this.stokHabis,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _ImageFallback(
        icon: icon,
        stokHabis: stokHabis,
      );
    }

    final Widget image = Image.network(
      imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.high,

      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: AlwaysStoppedAnimation<Color>(
                stokHabis
                    ? const Color(0xFF777C85)
                    : Colors.white,
              ),
            ),
          ),
        );
      },

      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return _ImageFallback(
          icon: icon,
          stokHabis: stokHabis,
        );
      },
    );

    if (!stokHabis) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: image,
      );
    }

    // ===============================================================
    // GRAYSCALE UNTUK PRODUK STOK HABIS
    // ===============================================================

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: Opacity(
        opacity: 0.65,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: image,
        ),
      ),
    );
  }
}

// =====================================================================
// IMAGE FALLBACK
// =====================================================================

class _ImageFallback extends StatelessWidget {
  final IconData icon;
  final bool stokHabis;

  const _ImageFallback({
    required this.icon,
    required this.stokHabis,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(
            alpha: stokHabis ? 0.05 : 0.12,
          ),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: stokHabis ? 0.08 : 0.18,
            ),
          ),
        ),
        child: Icon(
          icon,
          size: 46,
          color: stokHabis
              ? const Color(0xFF777C85)
              : Colors.white,
        ),
      ),
    );
  }
}

// =====================================================================
// SECTION TITLE
// =====================================================================

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF536DFE),
                Color(0xFF7C4DFF),
                Color(0xFFD06BFF),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF536DFE)
                    .withValues(alpha: 0.28),
                blurRadius: 16,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// INFO CARD
// =====================================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isLast;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : 10,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.22),
            const Color(0xFF171D3A),
            const Color(0xFF0B1024),
          ],
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: color.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.38),
                  color.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9BA4C2),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

// =====================================================================
// QUANTITY CARD
// =====================================================================

class _QuantityCard extends StatelessWidget {
  final int jumlah;
  final int stok;
  final String satuan;
  final Color accentColor;
  final ValueChanged<int> onChanged;

  const _QuantityCard({
    required this.jumlah,
    required this.stok,
    required this.satuan,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.22),
            const Color(0xFF182044),
            const Color(0xFF0A0F22),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.09),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jumlah Pembelian',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Stok tersedia: $stok $satuan',
                  style: const TextStyle(
                    color: Color(0xFF8B94B2),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PemilihJumlah(
            stok: stok,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// DISCOUNT INFO CARD
// =====================================================================

class _DiscountInfoCard extends StatelessWidget {
  final int jumlah;
  final bool sedangDiskon;
  final double persentaseDiskon;

  const _DiscountInfoCard({
    required this.jumlah,
    required this.sedangDiskon,
    required this.persentaseDiskon,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = sedangDiskon
        ? const Color(0xFF00F5A0)
        : const Color(0xFFFFC857);

    String title;

    if (jumlah >= 25) {
      title = 'Diskon 10% aktif!';
    } else if (jumlah >= 10) {
      title = 'Diskon 5% aktif!';
    } else {
      title = 'Belum mendapat diskon';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.20),
            const Color(0xFF171D39),
            const Color(0xFF0B1024),
          ],
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.35),
                  color.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              sedangDiskon
                  ? Icons.local_offer_rounded
                  : Icons.discount_rounded,
              color: color,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sedangDiskon
                      ? 'Anda mendapat potongan '
                          '${(persentaseDiskon * 100).round()}%.'
                      : 'Beli 10+ dapat 5%, beli 25+ dapat 10%.',
                  style: const TextStyle(
                    color: Color(0xFF8B94B2),
                    fontSize: 11.5,
                    height: 1.35,
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

// =====================================================================
// PRICE SUMMARY CARD
// =====================================================================

class _PriceSummaryCard extends StatelessWidget {
  final double subtotal;
  final double diskon;
  final double total;
  final String Function(double) formatRupiah;
  final Color accentColor;

  const _PriceSummaryCard({
    required this.subtotal,
    required this.diskon,
    required this.total,
    required this.formatRupiah,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF24195A),
            const Color(0xFF15275B),
            accentColor.withValues(alpha: 0.18),
            const Color(0xFF0B1026),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF536DFE)
                .withValues(alpha: 0.16),
            blurRadius: 26,
            offset: const Offset(0, 11),
          ),
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(8, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF4ECD),
                      Color(0xFF8E44FF),
                      Color(0xFF536DFE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              const Text(
                'Ringkasan Harga',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PriceRow(
            label: 'Subtotal',
            value: formatRupiah(subtotal),
          ),
          const SizedBox(height: 10),
          _PriceRow(
            label: 'Diskon',
            value: diskon > 0
                ? '-${formatRupiah(diskon)}'
                : formatRupiah(0),
            valueColor: diskon > 0
                ? const Color(0xFF00F5A0)
                : const Color(0xFF7F89AA),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(
              color: Color(0xFF39415F),
              height: 1,
            ),
          ),
          _PriceRow(
            label: 'Total Pembayaran',
            value: formatRupiah(total),
            large: true,
            valueColor: const Color(0xFFFFD166),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PRICE ROW
// =====================================================================

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool large;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: large
                  ? Colors.white
                  : const Color(0xFF9BA4C2),
              fontSize: large ? 15 : 13,
              fontWeight:
                  large ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: large ? 20 : 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// LUXURY CART BUTTON
// =====================================================================

class _LuxuryCartButton extends StatelessWidget {
  final bool enabled;
  final Color accentColor;
  final VoidCallback onPressed;

  const _LuxuryCartButton({
    required this.enabled,
    required this.accentColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = enabled
        ? [
            accentColor,
            const Color(0xFF00D9FF),
            const Color(0xFF536DFE),
            const Color(0xFF8E44FF),
          ]
        : [
            const Color(0xFF292D42),
            const Color(0xFF1C2034),
          ];

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: enabled
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.28),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF8E44FF)
                      .withValues(alpha: 0.20),
                  blurRadius: 30,
                  offset: const Offset(8, 5),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                enabled
                    ? Icons.add_shopping_cart_rounded
                    : Icons.remove_shopping_cart_rounded,
                size: 23,
                color: enabled
                    ? Colors.white
                    : const Color(0xFF737A96),
              ),
              const SizedBox(width: 10),
              Text(
                enabled
                    ? 'Masukkan ke Keranjang'
                    : 'Stok Sedang Habis',
                style: TextStyle(
                  color: enabled
                      ? Colors.white
                      : const Color(0xFF737A96),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// BACKGROUND GLOW
// =====================================================================

class _BackgroundGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _BackgroundGlow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.06),
              color.withValues(alpha: 0.0),
            ],
            stops: const [
              0.0,
              0.45,
              1.0,
            ],
          ),
        ),
      ),
    );
  }
}