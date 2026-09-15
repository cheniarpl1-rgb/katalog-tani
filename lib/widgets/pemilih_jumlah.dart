import 'package:flutter/material.dart';

class PemilihJumlah extends StatefulWidget {
  final int stok;
  final ValueChanged<int>? onChanged;

  const PemilihJumlah({
    super.key,
    required this.stok,
    this.onChanged,
  });

  @override
  State<PemilihJumlah> createState() => _PemilihJumlahState();
}

class _PemilihJumlahState extends State<PemilihJumlah> {
  int jumlah = 1;

  @override
  void initState() {
    super.initState();

    if (widget.stok <= 0) {
      jumlah = 0;
    }
  }

  @override
  void didUpdateWidget(covariant PemilihJumlah oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stok <= 0) {
      jumlah = 0;
    } else if (jumlah <= 0) {
      jumlah = 1;
    } else if (jumlah > widget.stok) {
      jumlah = widget.stok;
    }
  }

  // ================================================================
  // TAMBAH JUMLAH
  // ================================================================

  void tambah() {
    if (widget.stok <= 0) {
      return;
    }

    if (jumlah < widget.stok) {
      setState(() {
        jumlah++;
      });

      widget.onChanged?.call(jumlah);
    }
  }

  // ================================================================
  // KURANG JUMLAH
  // ================================================================

  void kurang() {
    if (jumlah > 1) {
      setState(() {
        jumlah--;
      });

      widget.onChanged?.call(jumlah);
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final bool stokHabis = widget.stok <= 0;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF20284B),
            Color(0xFF11172F),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: stokHabis
              ? const Color(0xFF3A4057)
              : const Color(0xFF3C4A78),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==========================================================
          // TOMBOL KURANG
          // ==========================================================

          _QuantityButton(
            icon: Icons.remove_rounded,
            enabled: !stokHabis && jumlah > 1,
            onPressed: kurang,
          ),

          // ==========================================================
          // JUMLAH
          // ==========================================================

          Container(
            constraints: const BoxConstraints(
              minWidth: 38,
            ),
            alignment: Alignment.center,
            child: Text(
              '$jumlah',
              style: TextStyle(
                color: stokHabis
                    ? const Color(0xFF6C7288)
                    : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // ==========================================================
          // TOMBOL TAMBAH
          // ==========================================================

          _QuantityButton(
            icon: Icons.add_rounded,
            enabled: !stokHabis && jumlah < widget.stok,
            onPressed: tambah,
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// TOMBOL JUMLAH
// ====================================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [
                      Color(0xFF536DFE),
                      Color(0xFF7C4DFF),
                    ],
                  )
                : null,
            color: enabled
                ? null
                : const Color(0xFF252A3C),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: enabled
                ? Colors.white
                : const Color(0xFF666D83),
          ),
        ),
      ),
    );
  }
}