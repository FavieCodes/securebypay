import 'package:flutter/material.dart';

/// Recreates the dot-pattern world map from the Figma design entirely
/// in code — no image asset needed. The dot grid below was vectorized
/// directly from the reference screenshot (each row is a hex-packed
/// bitmask, 1 = draw a dot, 0 = empty ocean), so the silhouette matches
/// the original continents rather than being a generic approximation.
class WorldMapDotsPainter extends CustomPainter {
  static const int _cols = 80;
  static const int _rows = 76;

  // Each entry is one row of the map, packed 4-bits-per-hex-char.
  static const String _hexRows =
      '007bc064000000010000,2ce18a7e00000200c000,cc9f7ffc000004000800,'
      '02787fff000024000480,0010fffe000000000480,d011fffe0018000007c0,'
      'd2e1fffe00c000000fc0,0387fffc007000201c85,20807ffc004000001fbf,'
      '00007ff0000000009fbf,d2007ff0000001009fff,2d807ffc000001087fff,'
      '2f807fe0000001039fff,02c07fe00000010ecfff,02e07fe00000010ecfff,'
      'ec70ffd0000000c27fff,fd603fe0000602199fff,c0f07f80000fc5feffff,'
      'b3e8fe00001fe3ffffff,33e8fe00001fe3ffffff,10e07812007b87ffffff,'
      '0260700c0073dfffffff,0300600000f45fffffff,0300000000c45fffffff,'
      '0f60000001c7bfffffff,0fe000000173e7fffffe,cfe000002047ffffffff,'
      'dff000001087ffffffff,dff000001087fffffffe,dff8000090fffffffffe,'
      'ff00000019ffffffffff,fd18000007ffffffffff,bf0000001fffdbcffbff,'
      '3f0000001fffdb8ffbff,1c8000000fcf9f1effff,f0000000394781cfffff,'
      'f0000000f894bdefffff,e0000000f0007fc3ffff,e0000000f00a7f83ffff,'
      'c000000021b007ffffff,800000003f801fffffff,000000007ff207ffffff,'
      '00000000fff607ffffff,00000000ffffffefffff,80000001fffffbe0ffff,'
      '20000003fffff9f20fff,c0000007fffffdff07f8,80000007fffffdff07e0,'
      '1200000ffffffcfe03e0,00000003fffffe3800c0,0000000ffffffec000c0,'
      '20000003ffffff080040,20000003ffffff000040,ff000001fffffff00020,'
      'ff800000f1ffffe00000,fff80000007fffc00000,fff80000007fe7000000,'
      'fff80000007fe7000000,ffff0000007fe6000000,ffffe000003fde000000,'
      'fffff800001fde000000,ffffe000001fde000000,ffffe000001ffe000000,'
      'ffffc000000ffa000000,3fffc000003ffe100000,1fffc000001ffc300000,'
      '1fffc000001ffc300000,0fffc000001ff8200000,0fff0000000ff8e00000,'
      '0ffc0000000fe0000000,0ffc0000000fe0000000,0ffc0000000fe0000000,'
      '0ff800000007c0000000,0ff80000000780000000,0fe00000000000000000,'
      '1fe00000000000000000';

  static List<List<bool>>? _cachedGrid;

  static List<List<bool>> get _grid {
    if (_cachedGrid != null) return _cachedGrid!;
    final rows = _hexRows.split(',');
    final grid = <List<bool>>[];
    for (final hexRow in rows) {
      final bits = <bool>[];
      for (final char in hexRow.split('')) {
        final nibble = int.parse(char, radix: 16);
        for (int b = 3; b >= 0; b--) {
          bits.add((nibble >> b) & 1 == 1);
        }
      }
      grid.add(bits.take(_cols).toList());
    }
    _cachedGrid = grid;
    return grid;
  }

  final Color dotColor;

  /// What fraction of the panel's height the dot pattern occupies,
  /// measured from the top. In the Figma reference the map covers the
  /// top ~68.7% of the panel, leaving a deliberate plain-color band at
  /// the bottom for the headline/subtext to sit on with breathing
  /// room — matching that fraction (rather than stretching the dots
  /// across the full panel height) is what keeps that bottom margin
  /// proportioned correctly instead of oversized or missing.
  final double mapHeightFraction;

  WorldMapDotsPainter({
    this.dotColor = Colors.white,
    this.mapHeightFraction = 465 / 677,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = _grid;
    final paint = Paint()..color = dotColor.withValues(alpha: 0.35);
    final mapHeight = size.height * mapHeightFraction;
    final cellW = size.width / _cols;
    final cellH = mapHeight / _rows;
    final radius = (cellW < cellH ? cellW : cellH) * 0.32;

    for (int r = 0; r < _rows; r++) {
      final row = grid[r];
      for (int c = 0; c < row.length; c++) {
        if (!row[c]) continue;
        final cx = (c + 0.5) * cellW;
        final cy = (r + 0.5) * cellH;
        canvas.drawCircle(Offset(cx, cy), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WorldMapDotsPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor ||
      oldDelegate.mapHeightFraction != mapHeightFraction;
}