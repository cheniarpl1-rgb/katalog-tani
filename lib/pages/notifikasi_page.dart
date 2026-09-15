import 'package:flutter/material.dart';

// =====================================================================
// MODEL NOTIFIKASI
// =====================================================================

class AgriNotification {
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  bool isRead;

  AgriNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.isRead = false,
  });
}

// =====================================================================
// NOTIFIKASI PAGE
// =====================================================================

class NotifikasiPage extends StatefulWidget {
  final List<AgriNotification> notifikasi;
  final VoidCallback onReadAll;

  const NotifikasiPage({
    super.key,
    required this.notifikasi,
    required this.onReadAll,
  });

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  // ===================================================================
  // FORMAT WAKTU
  // ===================================================================

  String formatWaktu(DateTime time) {
    final DateTime sekarang = DateTime.now();
    final Duration difference = sekarang.difference(time);

    if (difference.isNegative) {
      return 'Baru saja';
    }

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return '${time.day.toString().padLeft(2, '0')}/'
        '${time.month.toString().padLeft(2, '0')}/'
        '${time.year}';
  }

  // ===================================================================
  // TANDAI SEMUA DIBACA
  // ===================================================================

  void tandaiSemuaDibaca() {
    if (widget.notifikasi.isEmpty) {
      return;
    }

    for (final AgriNotification item in widget.notifikasi) {
      item.isRead = true;
    }

    widget.onReadAll();

    if (mounted) {
      setState(() {});
    }
  }

  // ===================================================================
  // TANDAI SATU NOTIFIKASI DIBACA
  // ===================================================================

  void tandaiDibaca(AgriNotification notification) {
    if (notification.isRead) {
      return;
    }

    setState(() {
      notification.isRead = true;
    });

    widget.onReadAll();
  }

  // ===================================================================
  // BUILD
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    final int belumDibaca = widget.notifikasi
        .where((AgriNotification item) => !item.isRead)
        .length;

    final bool kosong = widget.notifikasi.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF050714),

      // ===============================================================
      // APP BAR
      // ===============================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF4ECD),
                    Color(0xFF8E44FF),
                    Color(0xFF536DFE),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4ECD)
                        .withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            if (!kosong) ...[
              const SizedBox(width: 9),

              Container(
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 27,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00F5A0),
                      Color(0xFF00C9FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F5A0)
                          .withValues(alpha: 0.22),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Text(
                  '${widget.notifikasi.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),

        actions: [
          if (belumDibaca > 0)
            Container(
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00F5A0)
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF00F5A0)
                      .withValues(alpha: 0.18),
                ),
              ),
              child: TextButton.icon(
                onPressed: tandaiSemuaDibaca,
                icon: const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFF00F5A0),
                  size: 18,
                ),
                label: const Text(
                  'Baca semua',
                  style: TextStyle(
                    color: Color(0xFF00F5A0),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

          const SizedBox(width: 8),
        ],
      ),

      // ===============================================================
      // BODY
      // ===============================================================

      body: Stack(
        children: [
          // Background glow kanan atas
          const Positioned(
            top: -100,
            right: -90,
            child: _BackgroundGlow(
              color: Color(0xFF8E44FF),
              size: 250,
              opacity: 0.08,
            ),
          ),

          // Background glow kiri tengah
          const Positioned(
            top: 190,
            left: -130,
            child: _BackgroundGlow(
              color: Color(0xFF00C9FF),
              size: 270,
              opacity: 0.06,
            ),
          ),

          // Background glow kanan bawah
          const Positioned(
            bottom: -110,
            right: -90,
            child: _BackgroundGlow(
              color: Color(0xFFFF4ECD),
              size: 260,
              opacity: 0.07,
            ),
          ),

          if (kosong)
            const _EmptyNotification()
          else
            ListView.separated(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                35,
              ),

              itemCount: widget.notifikasi.length,

              separatorBuilder: (_, __) {
                return const SizedBox(height: 12);
              },

              itemBuilder: (context, index) {
                final AgriNotification notification =
                    widget.notifikasi[index];

                return _NotificationCard(
                  notification: notification,
                  time: formatWaktu(notification.time),
                  onTap: () {
                    tandaiDibaca(notification);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// BACKGROUND GLOW
// =====================================================================

class _BackgroundGlow extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _BackgroundGlow({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: size * 0.6,
              spreadRadius: size * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// NOTIFICATION CARD
// =====================================================================

class _NotificationCard extends StatelessWidget {
  final AgriNotification notification;
  final String time;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = notification.primaryColor;
    final Color secondary = notification.secondaryColor;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,

        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary.withValues(alpha: 0.28),
                secondary.withValues(alpha: 0.18),
                const Color(0xFF151B3A),
                const Color(0xFF0A0F24),
              ],
            ),

            borderRadius: BorderRadius.circular(26),

            border: Border.all(
              color: primary.withValues(alpha: 0.32),
              width: 1.1,
            ),

            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: secondary.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(8, 15),
              ),
            ],
          ),

          child: Container(
            margin: const EdgeInsets.all(1.2),

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =======================================================
                // ICON
                // =======================================================

                Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primary,
                        secondary,
                      ],
                    ),

                    borderRadius: BorderRadius.circular(19),

                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),

                  child: Icon(
                    notification.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 13),

                // =======================================================
                // CONTENT
                // =======================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // =================================================
                      // TITLE
                      // =================================================

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Expanded(
                            child: Text(
                              notification.title,

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          if (!notification.isRead)
                            Container(
                              width: 9,
                              height: 9,

                              margin: const EdgeInsets.only(
                                top: 4,
                              ),

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primary,
                                    secondary,
                                  ],
                                ),

                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: primary
                                        .withValues(alpha: 0.65),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // =================================================
                      // MESSAGE
                      // =================================================

                      Text(
                        notification.message,

                        maxLines: 4,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Color(0xFFB7BED5),
                          fontSize: 12,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 11),

                      // =================================================
                      // TIME + STATUS
                      // =================================================

                      Row(
                        children: [
                          Container(
                            width: 27,
                            height: 27,

                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,

                              border: Border.all(
                                color:
                                    primary.withValues(alpha: 0.18),
                              ),
                            ),

                            child: Icon(
                              Icons.schedule_rounded,
                              color: primary,
                              size: 14,
                            ),
                          ),

                          const SizedBox(width: 7),

                          Flexible(
                            child: Text(
                              time,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          if (!notification.isRead) ...[
                            const SizedBox(width: 8),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                color: primary
                                    .withValues(alpha: 0.12),

                                borderRadius:
                                    BorderRadius.circular(20),

                                border: Border.all(
                                  color: primary
                                      .withValues(alpha: 0.18),
                                ),
                              ),

                              child: Text(
                                'BARU',

                                style: TextStyle(
                                  color: primary,
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
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// EMPTY NOTIFICATION
// =====================================================================

class _EmptyNotification extends StatelessWidget {
  const _EmptyNotification();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // ===========================================================
            // ICON
            // ===========================================================

            Container(
              width: 120,
              height: 120,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF4ECD),
                    Color(0xFF8E44FF),
                    Color(0xFF536DFE),
                    Color(0xFF00C9FF),
                  ],
                ),

                borderRadius: BorderRadius.circular(38),

                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.2,
                ),

                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4ECD)
                        .withValues(alpha: 0.28),
                    blurRadius: 38,
                    offset: const Offset(0, 12),
                  ),

                  BoxShadow(
                    color: const Color(0xFF536DFE)
                        .withValues(alpha: 0.18),
                    blurRadius: 55,
                  ),
                ],
              ),

              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 58,
              ),
            ),

            const SizedBox(height: 27),

            // ===========================================================
            // TITLE
            // ===========================================================

            const Text(
              'Belum ada notifikasi',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 9),

            // ===========================================================
            // DESCRIPTION
            // ===========================================================

            const Text(
              'Notifikasi aktivitas AgriMart akan\nmuncul di sini.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Color(0xFF858DAA),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            // ===========================================================
            // INFO BADGE
            // ===========================================================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 11,
              ),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8E44FF)
                        .withValues(alpha: 0.14),
                    const Color(0xFF00C9FF)
                        .withValues(alpha: 0.10),
                  ],
                ),

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),

              child: const Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF00F5A0),
                    size: 17,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Semua aktivitas akan tampil di sini',

                    style: TextStyle(
                      color: Color(0xFFB7BED5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
}