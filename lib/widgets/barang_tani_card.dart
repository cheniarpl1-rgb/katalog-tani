import 'package:flutter/material.dart';
import '../models/barang_tani.dart';

class BarangTaniCard extends StatelessWidget {
  final BarangTani barang;
  final VoidCallback onTap;

  const BarangTaniCard({
    super.key,
    required this.barang,
    required this.onTap,
  });

  // ================================================================
  // FORMAT RUPIAH
  // ================================================================
  String formatRupiah(int angka) {
    final String text = angka.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(text[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  // ================================================================
  // PALET WARNA PRODUK
  // ================================================================
  _CardPalette paletteProduk() {
    final String nama = barang.nama.toLowerCase();
    final String kategori = barang.kategori.toLowerCase();

    // ==============================================================
    // BIOCHAR SEKAM PADI
    // ==============================================================
    if (nama.contains('biochar')) {
      return const _CardPalette(
        Color(0xFF795548),
        Color(0xFFA1887F),
        Color(0xFF43A047),
      );
    }

    // ==============================================================
    // COCOPEAT
    // ==============================================================
    if (nama.contains('cocopeat')) {
      return const _CardPalette(
        Color(0xFFD2691E),
        Color(0xFFFFA726),
        Color(0xFF66BB6A),
      );
    }

    // ==============================================================
    // VERMICOMPOST
    // ==============================================================
    if (nama.contains('vermicompost')) {
      return const _CardPalette(
        Color(0xFF8D6E63),
        Color(0xFF43A047),
        Color(0xFFA5D6A7),
      );
    }

    // ==============================================================
    // NEEM CAKE
    // ==============================================================
    if (nama.contains('neem')) {
      return const _CardPalette(
        Color(0xFF558B2F),
        Color(0xFF8BC34A),
        Color(0xFFD4E157),
      );
    }

    // ==============================================================
    // MICROGREENS STARTER KIT
    // ==============================================================
    if (nama.contains('microgreens')) {
      return const _CardPalette(
        Color(0xFF00C853),
        Color(0xFF00E676),
        Color(0xFF64DD17),
      );
    }

    // ==============================================================
    // VERMIWASH
    // ==============================================================
    if (nama.contains('vermiwash')) {
      return const _CardPalette(
        Color(0xFF009688),
        Color(0xFF00BFA5),
        Color(0xFF26C6DA),
      );
    }

    // ==============================================================
    // NUTRISI DAUN HIJAU
    // ==============================================================
    if (nama.contains('nutrisi')) {
      return const _CardPalette(
        Color(0xFF00C853),
        Color(0xFF00E676),
        Color(0xFFFFD166),
      );
    }

    // ==============================================================
    // POTTING MIX
    // ==============================================================
    if (nama.contains('potting mix')) {
      return const _CardPalette(
        Color(0xFF6D4C41),
        Color(0xFF8D6E63),
        Color(0xFF66BB6A),
      );
    }

    // ==============================================================
    // FALLBACK BERDASARKAN KATEGORI
    // ==============================================================
    if (kategori.contains('media tanam')) {
      return const _CardPalette(
        Color(0xFF795548),
        Color(0xFFA1887F),
        Color(0xFF66BB6A),
      );
    }

    if (kategori.contains('pupuk cair')) {
      return const _CardPalette(
        Color(0xFF009688),
        Color(0xFF00BCD4),
        Color(0xFF00E676),
      );
    }

    if (kategori.contains('pupuk')) {
      return const _CardPalette(
        Color(0xFF43A047),
        Color(0xFF8BC34A),
        Color(0xFFFFD166),
      );
    }

    if (kategori.contains('benih') ||
        kategori.contains('budidaya')) {
      return const _CardPalette(
        Color(0xFF00C853),
        Color(0xFF00E676),
        Color(0xFF69F0AE),
      );
    }

    return const _CardPalette(
      Color(0xFF00D9FF),
      Color(0xFF536DFE),
      Color(0xFFB14EFF),
    );
  }

  // ================================================================
  // ICON KATEGORI
  // ================================================================
  IconData iconKategori(String kategori) {
    final String value = kategori.toLowerCase();

    if (value.contains('media tanam')) {
      return Icons.layers_rounded;
    }

    if (value.contains('pupuk cair')) {
      return Icons.water_drop_rounded;
    }

    if (value.contains('pupuk')) {
      return Icons.eco_rounded;
    }

    if (value.contains('benih') ||
        value.contains('budidaya')) {
      return Icons.grass_rounded;
    }

    if (value.contains('alat')) {
      return Icons.handyman_rounded;
    }

    return Icons.inventory_2_rounded;
  }

  // ================================================================
  // ICON PRODUK
  // ================================================================
  IconData iconProduk() {
    final String nama = barang.nama.toLowerCase();

    if (nama.contains('biochar')) {
      return Icons.grain_rounded;
    }

    if (nama.contains('cocopeat')) {
      return Icons.spa_rounded;
    }

    if (nama.contains('vermicompost')) {
      return Icons.compost_rounded;
    }

    if (nama.contains('neem')) {
      return Icons.eco_rounded;
    }

    if (nama.contains('microgreens')) {
      return Icons.grass_rounded;
    }

    if (nama.contains('vermiwash')) {
      return Icons.water_drop_rounded;
    }

    if (nama.contains('nutrisi')) {
      return Icons.spa_rounded;
    }

    if (nama.contains('potting mix')) {
      return Icons.layers_rounded;
    }

    return iconKategori(barang.kategori);
  }

  // ================================================================
  // PALET STOK HABIS
  // ================================================================
  _CardPalette paletteHabis() {
    return const _CardPalette(
      Color(0xFF727780),
      Color(0xFF4B5059),
      Color(0xFF292D34),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================
  @override
  Widget build(BuildContext context) {
    final bool stokHabis = barang.stok <= 0;

    final _CardPalette palette =
        stokHabis ? paletteHabis() : paletteProduk();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: palette.primary.withValues(alpha: 0.12),
        highlightColor: Colors.white.withValues(alpha: 0.035),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            // ========================================================
            // BACKGROUND
            // ========================================================
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: stokHabis
                  ? const [
                      Color(0xFF22262D),
                      Color(0xFF171A20),
                      Color(0xFF0E1015),
                    ]
                  : [
                      palette.primary.withValues(alpha: 0.25),
                      palette.secondary.withValues(alpha: 0.16),
                      const Color(0xFF11162A),
                      const Color(0xFF080A14),
                    ],
            ),

            border: Border.all(
              color: stokHabis
                  ? Colors.white.withValues(alpha: 0.09)
                  : palette.primary.withValues(alpha: 0.42),
              width: 1.2,
            ),

            boxShadow: [
              BoxShadow(
                color: stokHabis
                    ? Colors.black.withValues(alpha: 0.30)
                    : palette.primary.withValues(alpha: 0.16),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
              if (!stokHabis)
                BoxShadow(
                  color: palette.secondary.withValues(alpha: 0.08),
                  blurRadius: 40,
                  spreadRadius: 1,
                ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====================================================
                // AREA GAMBAR
                // ====================================================
                AspectRatio(
                  aspectRatio: 1.22,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),

                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // =================================================
                        // BACKGROUND GAMBAR
                        // =================================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                palette.primary
                                    .withValues(alpha: 0.22),
                                palette.secondary
                                    .withValues(alpha: 0.12),
                                const Color(0xFF090D1A),
                              ],
                            ),
                          ),
                        ),

                        // =================================================
                        // IMAGE
                        // =================================================
                        Image.network(
                          barang.gambar,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,

                          // ------------------------------------------------
                          // LOADING
                          // ------------------------------------------------
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? progress,
                          ) {
                            if (progress == null) {
                              if (stokHabis) {
                                return ColorFiltered(
                                  colorFilter:
                                      const ColorFilter.matrix([
                                    0.35,
                                    0.35,
                                    0.35,
                                    0,
                                    0,
                                    0.35,
                                    0.35,
                                    0.35,
                                    0,
                                    0,
                                    0.35,
                                    0.35,
                                    0.35,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ]),
                                  child: child,
                                );
                              }

                              return child;
                            }

                            double? value;

                            if (progress.expectedTotalBytes != null &&
                                progress.expectedTotalBytes! > 0) {
                              value =
                                  progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!;
                            }

                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    palette.primary
                                        .withValues(alpha: 0.20),
                                    palette.secondary
                                        .withValues(alpha: 0.10),
                                    const Color(0xFF0B1022),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    value: value,
                                    color: stokHabis
                                        ? const Color(0xFF8B9098)
                                        : palette.primary,
                                  ),
                                ),
                              ),
                            );
                          },

                          // ------------------------------------------------
                          // ERROR
                          // ------------------------------------------------
                          errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return _FallbackImage(
                              palette: palette,
                              icon: iconProduk(),
                              stokHabis: stokHabis,
                            );
                          },
                        ),

                        // =================================================
                        // OVERLAY GAMBAR
                        // =================================================
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.03),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // =================================================
                        // BADGE KATEGORI
                        // =================================================
                        Positioned(
                          top: 9,
                          left: 9,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 120,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  palette.primary,
                                  palette.secondary,
                                  palette.tertiary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: stokHabis
                                  ? const []
                                  : [
                                      BoxShadow(
                                        color: palette.primary
                                            .withValues(alpha: 0.30),
                                        blurRadius: 13,
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  iconKategori(barang.kategori),
                                  color: Colors.white,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    barang.kategori.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // =================================================
                        // BADGE STOK
                        // =================================================
                        Positioned(
                          top: 9,
                          right: 9,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 100,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: stokHabis
                                  ? const Color(0xFF5B6068)
                                  : const Color(0xFF050A13)
                                      .withValues(alpha: 0.86),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: stokHabis
                                    ? Colors.white
                                        .withValues(alpha: 0.14)
                                    : palette.primary
                                        .withValues(alpha: 0.32),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  stokHabis
                                      ? Icons.remove_circle_rounded
                                      : Icons.inventory_2_rounded,
                                  size: 10,
                                  color: stokHabis
                                      ? const Color(0xFFD2D4D8)
                                      : const Color(0xFFB8FFE8),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    stokHabis
                                        ? 'HABIS'
                                        : 'STOK ${barang.stok}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: stokHabis
                                          ? const Color(0xFFD2D4D8)
                                          : const Color(0xFFB8FFE8),
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // =================================================
                        // TOMBOL DETAIL
                        // =================================================
                        Positioned(
                          right: 9,
                          bottom: 9,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  palette.primary,
                                  palette.secondary,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: stokHabis
                                  ? const []
                                  : [
                                      BoxShadow(
                                        color: palette.primary
                                            .withValues(alpha: 0.38),
                                        blurRadius: 15,
                                      ),
                                    ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),

                        // =================================================
                        // LABEL RESTOCK
                        // =================================================
                        if (stokHabis)
                          Positioned(
                            left: 9,
                            bottom: 9,
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 125,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.black.withValues(alpha: 0.70),
                                borderRadius:
                                    BorderRadius.circular(11),
                                border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: 0.10),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    color: Color(0xFFC5C8CE),
                                    size: 11,
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'SEGERA RESTOCK',
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFC5C8CE),
                                        fontSize: 6.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ====================================================
                // JARAK
                // ====================================================
                const SizedBox(height: 10),

                // ====================================================
                // NAMA PRODUK
                // ====================================================
                Text(
                  barang.nama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: stokHabis
                        ? const Color(0xFF999DA5)
                        : const Color(0xFFF5F7FF),
                    fontSize: 13.5,
                    height: 1.20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                // ====================================================
                // JARAK
                // ====================================================
                const SizedBox(height: 6),

                // ====================================================
                // SATUAN
                // ====================================================
                Row(
                  children: [
                    Icon(
                      Icons.sell_rounded,
                      color: stokHabis
                          ? const Color(0xFF777B83)
                          : palette.primary,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'per ${barang.satuan}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stokHabis
                              ? const Color(0xFF6E727A)
                              : const Color(0xFF858DAA),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // ====================================================
                // JARAK
                // ====================================================
                const SizedBox(height: 7),

                // ====================================================
                // HARGA
                // ====================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        formatRupiah(barang.harga),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stokHabis
                              ? const Color(0xFF777B83)
                              : palette.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: stokHabis
                            ? Colors.white.withValues(alpha: 0.035)
                            : palette.primary
                                .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: stokHabis
                              ? Colors.white.withValues(alpha: 0.07)
                              : palette.primary
                                  .withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(
                        Icons.visibility_rounded,
                        color: stokHabis
                            ? const Color(0xFF70747C)
                            : palette.primary,
                        size: 14,
                      ),
                    ),
                  ],
                ),

                // ====================================================
                // BOTTOM SAFE SPACE
                // ====================================================
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// CLASS PALET WARNA
// ====================================================================

class _CardPalette {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  const _CardPalette(
    this.primary,
    this.secondary,
    this.tertiary,
  );
}

// ====================================================================
// FALLBACK GAMBAR
// ====================================================================

class _FallbackImage extends StatelessWidget {
  final _CardPalette palette;
  final IconData icon;
  final bool stokHabis;

  const _FallbackImage({
    required this.palette,
    required this.icon,
    required this.stokHabis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stokHabis
              ? const [
                  Color(0xFF3A3E46),
                  Color(0xFF252930),
                  Color(0xFF111318),
                ]
              : [
                  palette.primary.withValues(alpha: 0.45),
                  palette.secondary.withValues(alpha: 0.28),
                  const Color(0xFF090D1E),
                ],
        ),
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: stokHabis
                  ? const [
                      Color(0xFF5B6068),
                      Color(0xFF353941),
                    ]
                  : [
                      palette.primary,
                      palette.secondary,
                      palette.tertiary,
                    ],
            ),
            shape: BoxShape.circle,
            boxShadow: stokHabis
                ? const []
                : [
                    BoxShadow(
                      color:
                          palette.primary.withValues(alpha: 0.30),
                      blurRadius: 25,
                    ),
                  ],
          ),
          child: Icon(
            icon,
            color: stokHabis
                ? const Color(0xFFB8BBC1)
                : Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}