import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'world_map_painter.dart';

/// The two-pane layout used by both the Sign Up and Sign In screens:
/// a white form panel on the left and a purple decorative panel (the
/// dot-pattern world map, drawn entirely in code via
/// [WorldMapDotsPainter]) with a headline on the right. On
/// tablet/mobile the decorative panel is hidden so the form takes the
/// full width — the Flutter equivalent of a CSS media query
/// collapsing a grid to one column.
class AuthLayout extends StatelessWidget {
  final String breadcrumb;
  final Widget formContent;
  final String panelHeadline;
  final String panelSubtext;

  const AuthLayout({
    super.key,
    required this.breadcrumb,
    required this.formContent,
    required this.panelHeadline,
    required this.panelSubtext,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: isDesktop ? 5 : 10,
                  child: Container(
                    color: AppColors.panelBackground,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 453),
                          child: formContent,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isDesktop)
                  Expanded(
                    flex: 5,
                    child: _DecorativePanel(
                      headline: panelHeadline,
                      subtext: panelSubtext,
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

class _DecorativePanel extends StatelessWidget {
  final String headline;
  final String subtext;

  const _DecorativePanel({required this.headline, required this.subtext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryPurple,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dot-pattern world map, drawn entirely in code — vectorized
          // from the Figma export, no binary asset shipped.
          CustomPaint(painter: WorldMapDotsPainter()),
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppTextStyles.heading.fontFamily,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtext,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: AppTextStyles.body.fontFamily,
                    height: 1.5,
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