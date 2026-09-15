import 'package:flutter/material.dart';

import '../models/barang_tani.dart';

class KeranjangPage extends StatefulWidget {
  final Map<BarangTani, int> keranjang;
  final VoidCallback onKeranjangChanged;

  const KeranjangPage({
    super.key,
    required this.keranjang,
    required this.onKeranjangChanged,
  });

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
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
  // TOTAL ITEM
  // ===================================================================

  int get totalItem {
    return widget.keranjang.values.fold(
      0,
      (total, jumlah) => total + jumlah,
    );
  }

  // ===================================================================
  // SUBTOTAL
  // ===================================================================

  double get subtotal {
    double total = 0;

    for (final entry in widget.keranjang.entries) {
      total += entry.key.harga * entry.value;
    }

    return total;
  }

  // ===================================================================
  // DISKON
  // ===================================================================

  double get persentaseDiskon {
    if (totalItem >= 25) {
      return 0.10;
    }

    if (totalItem >= 10) {
      return 0.05;
    }

    return 0;
  }

  double get jumlahDiskon {
    return subtotal * persentaseDiskon;
  }

  double get totalPembayaran {
    return subtotal - jumlahDiskon;
  }

  // ===================================================================
  // UBAH JUMLAH
  // ===================================================================

  void ubahJumlah(
    BarangTani barang,
    int jumlah,
  ) {
    if (jumlah <= 0) {
      hapusBarang(barang);
      return;
    }

    if (jumlah > barang.stok) {
      jumlah = barang.stok;
    }

    setState(() {
      widget.keranjang[barang] = jumlah;
    });

    widget.onKeranjangChanged();
  }

  // ===================================================================
  // HAPUS BARANG
  // ===================================================================

  void hapusBarang(BarangTani barang) {
    setState(() {
      widget.keranjang.remove(barang);
    });

    widget.onKeranjangChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF416C),
                Color(0xFFFF4ECD),
                Color(0xFF8E44FF),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF416C)
                    .withValues(alpha: 0.35),
                blurRadius: 25,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.30),
                  ),
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${barang.nama} dihapus dari keranjang.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ===================================================================
  // KOSONGKAN KERANJANG
  // ===================================================================

  void kosongkanKeranjang() {
    if (widget.keranjang.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: const Color(0xFF080A18).withValues(alpha: 0.72),
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          content: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF416C),
                  Color(0xFFFF4ECD),
                  Color(0xFF8E44FF),
                  Color(0xFF536DFE),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4ECD)
                      .withValues(alpha: 0.35),
                  blurRadius: 35,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Kosongkan Keranjang?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Semua barang di keranjang akan dihapus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.keranjang.clear();
                          });

                          widget.onKeranjangChanged();

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              margin: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                18,
                              ),
                              content: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00F5A0),
                                      Color(0xFF00D9FF),
                                      Color(0xFF536DFE),
                                      Color(0xFFD06BFF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00D9FF)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Keranjang berhasil dikosongkan.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF416C),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Kosongkan',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================================================================
  // BUILD
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    final bool kosong = widget.keranjang.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF050714),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Keranjang',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            if (!kosong) ...[
              const SizedBox(width: 9),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00F5A0),
                      Color(0xFF00D9FF),
                      Color(0xFF536DFE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9FF)
                          .withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Text(
                  '$totalItem',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!kosong)
            IconButton(
              tooltip: 'Kosongkan keranjang',
              onPressed: kosongkanKeranjang,
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: Color(0xFFFF5A7D),
              ),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          const Positioned(
            top: -100,
            right: -100,
            child: _BackgroundGlow(
              color: Color(0xFF8E44FF),
              size: 280,
            ),
          ),
          const Positioned(
            top: 180,
            left: -130,
            child: _BackgroundGlow(
              color: Color(0xFF00D9FF),
              size: 250,
            ),
          ),
          const Positioned(
            bottom: 100,
            right: -100,
            child: _BackgroundGlow(
              color: Color(0xFFFF4ECD),
              size: 240,
            ),
          ),
          kosong
              ? const _EmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          20,
                        ),
                        itemCount: widget.keranjang.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final entry =
                              widget.keranjang.entries.elementAt(index);

                          return _CartItemCard(
                            barang: entry.key,
                            jumlah: entry.value,
                            formatRupiah: formatRupiah,
                            onDecrease: () {
                              ubahJumlah(
                                entry.key,
                                entry.value - 1,
                              );
                            },
                            onIncrease: () {
                              ubahJumlah(
                                entry.key,
                                entry.value + 1,
                              );
                            },
                            onDelete: () {
                              hapusBarang(entry.key);
                            },
                          );
                        },
                      ),
                    ),
                    _CartSummary(
                      subtotal: subtotal,
                      diskon: jumlahDiskon,
                      total: totalPembayaran,
                      persentaseDiskon: persentaseDiskon,
                      formatRupiah: formatRupiah,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// =====================================================================
// CART ITEM
// =====================================================================

class _CartItemCard extends StatelessWidget {
  final BarangTani barang;
  final int jumlah;
  final String Function(double) formatRupiah;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.barang,
    required this.jumlah,
    required this.formatRupiah,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  });

  Color get accentColor {
    switch (barang.kategori.toLowerCase()) {
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

  Color get secondaryColor {
    switch (barang.kategori.toLowerCase()) {
      case 'bibit':
        return const Color(0xFF00D9FF);
      case 'pupuk':
        return const Color(0xFFFF4ECD);
      case 'alat':
        return const Color(0xFF536DFE);
      default:
        return const Color(0xFFFF7A18);
    }
  }

  IconData get icon {
    switch (barang.kategori.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final double totalBarang =
        barang.harga.toDouble() * jumlah.toDouble();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.24),
            secondaryColor.withValues(alpha: 0.12),
            const Color(0xFF151B38),
            const Color(0xFF0A0F24),
          ],
          stops: const [
            0.0,
            0.32,
            0.70,
            1.0,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.38),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.16),
            blurRadius: 30,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: secondaryColor.withValues(alpha: 0.08),
            blurRadius: 45,
            offset: const Offset(10, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------
              // ICON PRODUK
              // ---------------------------------------------------------

              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor,
                      secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.38),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 13),

              // ---------------------------------------------------------
              // INFO PRODUK
              // ---------------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Text(
                        barang.kategori.toUpperCase(),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      barang.nama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${formatRupiah(barang.harga.toDouble())}/${barang.satuan}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA6AEC9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------------------------------------------------
              // DELETE
              // ---------------------------------------------------------

              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: onDelete,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF416C)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFFF416C)
                            .withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF6B8A),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // -------------------------------------------------------------
          // QUANTITY
          // -------------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.025),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Jumlah',
                  style: TextStyle(
                    color: Color(0xFF9CA5C3),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                _QuantityButton(
                  icon: Icons.remove_rounded,
                  color: const Color(0xFFFF4ECD),
                  onPressed: onDecrease,
                ),

                Container(
                  width: 46,
                  alignment: Alignment.center,
                  child: Text(
                    '$jumlah',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                _QuantityButton(
                  icon: Icons.add_rounded,
                  color: const Color(0xFF00F5A0),
                  onPressed: jumlah < barang.stok
                      ? onIncrease
                      : null,
                ),

                const Spacer(),

                // -------------------------------------------------------
                // TOTAL BARANG
                // -------------------------------------------------------

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Color(0xFF7F89A8),
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatRupiah(totalBarang),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
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
// QUANTITY BUTTON
// =====================================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _QuantityButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool aktif = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            gradient: aktif
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withValues(alpha: 0.48),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF34394D),
                      Color(0xFF252A3B),
                    ],
                  ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: aktif
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.30),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: aktif
                ? Colors.white
                : Colors.white.withValues(alpha: 0.30),
            size: 19,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// SUMMARY
// =====================================================================

class _CartSummary extends StatelessWidget {
  final double subtotal;
  final double diskon;
  final double total;
  final double persentaseDiskon;
  final String Function(double) formatRupiah;

  const _CartSummary({
    required this.subtotal,
    required this.diskon,
    required this.total,
    required this.persentaseDiskon,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        19,
        20,
        24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF24245B),
            Color(0xFF171B48),
            Color(0xFF111638),
            Color(0xFF0C1029),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF8E44FF).withValues(alpha: 0.35),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF536DFE).withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Ringkasan Belanja',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                if (persentaseDiskon > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00F5A0),
                          Color(0xFF00D9FF),
                          Color(0xFF536DFE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9FF)
                              .withValues(alpha: 0.30),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Text(
                      'DISKON ${(persentaseDiskon * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            _SummaryRow(
              label: 'Subtotal',
              value: formatRupiah(subtotal),
            ),

            const SizedBox(height: 8),

            _SummaryRow(
              label: 'Diskon',
              value: diskon > 0
                  ? '-${formatRupiah(diskon)}'
                  : formatRupiah(0),
              valueColor: const Color(0xFF00F5A0),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(
                color: Color(0xFF343B68),
                height: 1,
              ),
            ),

            _SummaryRow(
              label: 'Total Pembayaran',
              value: formatRupiah(total),
              large: true,
              valueColor: const Color(0xFF8C9EFF),
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------
            // CHECKOUT
            // -----------------------------------------------------------

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8E44FF)
                        .withValues(alpha: 0.40),
                    blurRadius: 28,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF00F5A0),
                        Color(0xFF00D9FF),
                        Color(0xFF536DFE),
                        Color(0xFF8E44FF),
                        Color(0xFFFF4ECD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          margin: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            18,
                          ),
                          content: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF00F5A0),
                                  Color(0xFF00D9FF),
                                  Color(0xFF536DFE),
                                  Color(0xFFD06BFF),
                                  Color(0xFFFF4ECD),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: 0.30,
                                ),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00D9FF)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 28,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.30,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Checkout Siap!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Fitur pembayaran siap dikembangkan.',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(
                      Icons.shopping_cart_checkout_rounded,
                    ),
                    label: const Text(
                      'Lanjutkan ke Checkout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
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
}

// =====================================================================
// SUMMARY ROW
// =====================================================================

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool large;

  const _SummaryRow({
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
                  : const Color(0xFF9AA3C0),
              fontSize: large ? 15 : 13,
              fontWeight: large
                  ? FontWeight.w900
                  : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: large ? 20 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// EMPTY CART
// =====================================================================

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 80,
          left: -80,
          child: _BackgroundGlow(
            color: Color(0xFF00F5A0),
            size: 180,
          ),
        ),
        const Positioned(
          bottom: 120,
          right: -80,
          child: _BackgroundGlow(
            color: Color(0xFFFF4ECD),
            size: 190,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00F5A0),
                        Color(0xFF00D9FF),
                        Color(0xFF536DFE),
                        Color(0xFFD06BFF),
                        Color(0xFFFF4ECD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D9FF)
                            .withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 58,
                  ),
                ),

                const SizedBox(height: 27),

                const Text(
                  'Keranjang masih kosong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 9),

                const Text(
                  'Yuk pilih produk pertanian terbaik\n'
                  'untuk dimasukkan ke keranjang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8E97B5),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 27),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF536DFE)
                            .withValues(alpha: 0.35),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00F5A0),
                          Color(0xFF00D9FF),
                          Color(0xFF536DFE),
                          Color(0xFF8E44FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(
                        Icons.storefront_rounded,
                      ),
                      label: const Text(
                        'Belanja Sekarang',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// BACKGROUND GLOW
// =====================================================================

class _BackgroundGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _BackgroundGlow({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.13),
              blurRadius: size * 0.70,
              spreadRadius: size * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}