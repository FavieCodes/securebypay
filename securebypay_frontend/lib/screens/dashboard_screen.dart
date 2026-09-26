import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../state/auth_state.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

void _showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.rocket_launch_rounded, color: AppColors.primaryPurple, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF171717),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This feature is coming soon. Stay tuned!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF737373),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      );
    },
  );
}

class _NavItemData {
  final IconData icon;
  final String title;

  const _NavItemData(this.icon, this.title);
}

const List<_NavItemData> _navItems = [
  _NavItemData(Icons.grid_view_rounded, 'Dashboard'),
  _NavItemData(Icons.local_shipping_outlined, 'Shipments'),
  _NavItemData(Icons.public_outlined, 'Our Services'),
  _NavItemData(Icons.notifications_none_rounded, 'Notifications'),
  _NavItemData(Icons.account_balance_wallet_outlined, 'Wallet'),
  _NavItemData(Icons.location_on_outlined, 'My Addresses'),
  _NavItemData(Icons.card_giftcard_outlined, 'Invite & Earn'),
  _NavItemData(Icons.help_outline_rounded, 'Help Center'),
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(context);
    final auth = context.watch<AuthState>();
    final currentItem = _navItems[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      drawer: isDesktop
          ? null
          : Drawer(
              child: _Sidebar(
                auth: auth,
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  _onSelectItem(index);
                  Navigator.of(context).pop();
                },
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isDesktop) ...[
                Row(
                  children: [
                    const Spacer(),
                    Builder(
                      builder: (ctx) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isDesktop)
                        SizedBox(
                          width: 220,
                          child: _Sidebar(
                            auth: auth,
                            selectedIndex: _selectedIndex,
                            onItemSelected: _onSelectItem,
                          ),
                        ),
                      Expanded(
                        child: _selectedIndex == 0
                            ? const _MainContent()
                            : _ComingSoonContent(
                                item: currentItem,
                                onGoBack: () => _onSelectItem(0),
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
    );
  }
}

/// A circular avatar that shows the user's photo when one is set, and falls back to their initials otherwise.
class InitialsAvatar extends StatelessWidget {
  final AppUser? user;
  final String? photoUrl;
  final double radius;
  final Color background;
  final Color foreground;

  const InitialsAvatar({
    super.key,
    required this.user,
    this.photoUrl,
    this.radius = 18,
    this.background = AppColors.primaryPurple,
    this.foreground = Colors.white,
  });

  String get _initials {
    final first = (user?.firstName ?? '').trim();
    final last = (user?.lastName ?? '').trim();
    final a = first.isNotEmpty ? first[0] : '';
    final b = last.isNotEmpty ? last[0] : '';
    final initials = ('$a$b').toUpperCase();
    return initials.isNotEmpty ? initials : 'U';
  }

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.inputBorder,
        backgroundImage: NetworkImage(photoUrl!),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      child: Text(
        _initials,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.75,
        ),
      ),
    );
  }
}

class _AvatarUploadButton extends StatefulWidget {
  final AuthState auth;
  const _AvatarUploadButton({required this.auth});

  @override
  State<_AvatarUploadButton> createState() => _AvatarUploadButtonState();
}

class _AvatarUploadButtonState extends State<_AvatarUploadButton> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _uploading = true);
    final bytes = await picked.readAsBytes();
    final mimeType = picked.mimeType ?? 'image/jpeg';
    final dataUri = 'data:$mimeType;base64,${base64Encode(bytes)}';

    final ok = await widget.auth.uploadAvatar(dataUri);

    if (!mounted) return;
    setState(() => _uploading = false);
    if (!ok && widget.auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.auth.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _uploading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _uploading ? null : _pickAndUpload,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InitialsAvatar(
              user: widget.auth.user,
              photoUrl: widget.auth.user?.profilePictureUrl,
              radius: 18,
            ),
            if (_uploading)
              Positioned.fill(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black45,
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final AuthState auth;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _Sidebar({
    required this.auth,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 90),
          Expanded(
            child: ListView.builder(
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = index == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Material(
                    color: isSelected ? AppColors.activeNavBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onItemSelected(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            children: [
              _AvatarUploadButton(auth: auth),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  auth.user != null
                      ? '${auth.user!.firstName}\n${auth.user!.lastName}'
                      : 'Firstname\nLastname',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            icon: const Icon(Icons.logout, size: 18, color: AppColors.textSecondary),
            label: const Text('Logout', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonContent extends StatelessWidget {
  final _NavItemData item;
  final VoidCallback onGoBack;

  const _ComingSoonContent({
    required this.item,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32),
      color: AppColors.background,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 48,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'COMING SOON',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warningText,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'We are working hard to build the ${item.title} feature. Check back soon for exciting updates!',
                  style: AppTextStyles.subheading,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onGoBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShipmentData {
  final String trackingId;
  final String sender;
  final String receiver;
  final String pickupFrom;
  final String deliveryTo;
  final String amount;
  final String status;
  final String processingTime;
  final bool isPaid;

  const _ShipmentData({
    required this.trackingId,
    required this.sender,
    required this.receiver,
    required this.pickupFrom,
    required this.deliveryTo,
    required this.amount,
    required this.status,
    required this.processingTime,
    this.isPaid = false,
  });
}

const List<_ShipmentData> _shipments = [
  _ShipmentData(
    trackingId: 'MAF-100-234-291',
    sender: 'Bunmi Tanny',
    receiver: 'Mercy',
    pickupFrom: 'Lagos Nigeria',
    deliveryTo: 'Oyo Nigeria',
    amount: '₦3000',
    status: 'In-Transit',
    processingTime: '10 hours',
    isPaid: true,
  ),
  _ShipmentData(
    trackingId: 'MAF-100-234-291',
    sender: 'Bunmi Tanny',
    receiver: 'Mercy',
    pickupFrom: 'Lagos Nigeria',
    deliveryTo: 'Oyo Nigeria',
    amount: '₦3000',
    status: 'Delayed',
    processingTime: '10 hours',
  ),
  _ShipmentData(
    trackingId: 'MAF-100-234-291',
    sender: 'Bunmi Tanny',
    receiver: 'Mercy',
    pickupFrom: 'Lagos Nigeria',
    deliveryTo: 'Oyo Nigeria',
    amount: '₦3000',
    status: 'In-Transit',
    processingTime: '10 hours',
  ),
];

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invite & Earn',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF171717),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 453,
              child: Text(
                'Keep track of your addresses,  location updates. Edit, Delete, Update and see all '
                'your saved addresses',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 20 / 12,
                  letterSpacing: 0,
                  color: Color(0xFF737373),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _ShipmentBanner(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Overview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const Spacer(),
                const _PeriodDropdown(),
              ],
            ),
            const SizedBox(height: 12),
            if (isMobile)
              Column(
                children: [
                  const _BalanceCard(width: double.infinity),
                  const SizedBox(height: 16),
                  _StatCard(
                    icon: Icons.local_shipping_outlined,
                    iconBg: AppColors.shipmentIconBg,
                    iconFg: AppColors.shipmentIconFg,
                    title: 'Total Shipment',
                    value: '34',
                    changePercent: '90%',
                    vsLastMonth: '4',
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  _StatCard(
                    icon: Icons.arrow_upward_rounded,
                    iconBg: AppColors.exportIconBg,
                    iconFg: AppColors.exportIconFg,
                    title: 'Total Exports',
                    value: '34',
                    changePercent: '90%',
                    vsLastMonth: '4',
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  _StatCard(
                    icon: Icons.arrow_downward_rounded,
                    iconBg: AppColors.importIconBg,
                    iconFg: AppColors.importIconFg,
                    title: 'Total Import',
                    value: '34',
                    changePercent: '90%',
                    vsLastMonth: '4',
                    width: double.infinity,
                  ),
                ],
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _BalanceCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _StatCard(
                        icon: Icons.local_shipping_outlined,
                        iconBg: AppColors.shipmentIconBg,
                        iconFg: AppColors.shipmentIconFg,
                        title: 'Total Shipment',
                        value: '34',
                        changePercent: '90%',
                        vsLastMonth: '4',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _StatCard(
                        icon: Icons.arrow_upward_rounded,
                        iconBg: AppColors.exportIconBg,
                        iconFg: AppColors.exportIconFg,
                        title: 'Total Exports',
                        value: '34',
                        changePercent: '90%',
                        vsLastMonth: '4',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _StatCard(
                        icon: Icons.arrow_downward_rounded,
                        iconBg: AppColors.importIconBg,
                        iconFg: AppColors.importIconFg,
                        title: 'Total Import',
                        value: '34',
                        changePercent: '90%',
                        vsLastMonth: '4',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Recent shipment',
                  style: TextStyle(
                    fontFamily: AppTextStyles.heading.fontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.inputBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: AppTextStyles.body.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.0,
                          letterSpacing: 0,
                          color: const Color(0xFF737373),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _GrowthChartCard(),
            const SizedBox(height: 24),
            for (final entry in _shipments.asMap().entries)
              _ShipmentTile(
                data: entry.value,
                initiallyExpanded: entry.key != _shipments.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

/// One banner slide's content.
class _BannerSlideData {
  final String headline;
  const _BannerSlideData(this.headline);
}

// Edit these to change what the slider shows.
const List<_BannerSlideData> _bannerSlides = [
  _BannerSlideData('KEEP UP WITH YOUR\nBUSINESS NEEDS'),
  _BannerSlideData('Fast, Secure Deliveries\nAcross 300+ Countries!'),
  _BannerSlideData('Manage Every Shipment\nFrom One Dashboard!'),
];

/// The promo card at the top of the dashboard 
class _ShipmentBanner extends StatefulWidget {
  const _ShipmentBanner();

  @override
  State<_ShipmentBanner> createState() => _ShipmentBannerState();
}

class _ShipmentBannerState extends State<_ShipmentBanner> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _bannerSlides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    // A manual jump (tapping a dot) restarts the auto-play clock
    _startAutoPlay();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerSlides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _BannerSlide(data: _bannerSlides[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerSlides.length, (i) {
            final active = i == _currentPage;
            return GestureDetector(
              onTap: () => _goToPage(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.primaryPurple : AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// A single slide
class _BannerSlide extends StatelessWidget {
  final _BannerSlideData data;
  const _BannerSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF16183D), Color(0xFF262B5E)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalStripesPainter()),
          ),
          Positioned(
            right: -40,
            top: -30,
            bottom: -30,
            width: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/shipment_globe.png',
              height: double.infinity,
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 56, bottom: 24),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                data.headline.toUpperCase(),
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 42.47,
                  fontWeight: FontWeight.w900,
                  height: 43.99 / 42.47,
                  letterSpacing: -0.02 * 42.47,
                  fontFamily: AppTextStyles.heading.fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1.0;
    const spacing = 18.0;
    final span = size.width + size.height;
    for (double x = -size.height; x < span; x += spacing) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BalanceCard extends StatelessWidget {
  final double? width;
  const _BalanceCard({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          const Text('₦3,000,000.28',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _showComingSoonDialog(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primaryPurple),
            child: const Text('Fund Wallet'),
          ),
        ],
      ),
    );
  }
}

/// One of the three "Total Shipment / Total Exports / Total Import" cards.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String value;
  final String changePercent;
  final String vsLastMonth;
  final double? width;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.value,
    required this.changePercent,
    required this.vsLastMonth,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: iconFg),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTextStyles.subheading)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_upward_rounded, size: 12, color: AppColors.exportIconFg),
              Text(
                '+$changePercent',
                style: TextStyle(fontSize: 11, color: AppColors.exportIconFg, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'Vs last month: '),
                TextSpan(
                  text: vsLastMonth,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Company Growth" card 
class _GrowthChartCard extends StatefulWidget {
  const _GrowthChartCard();

  @override
  State<_GrowthChartCard> createState() => _GrowthChartCardState();
}

class _GrowthChartCardState extends State<_GrowthChartCard> {
  String _range = 'Year';

  static const Map<String, List<double>> _series = {
    // Matches the reference curve: gentle wave up through x=8, a dip, 
    'Year': [280, 330, 300, 365, 340, 430, 335, 480, 390, 630, 130, 990],
    'Month': [180, 260, 220, 300, 260, 340, 300, 260, 220, 420, 200, 460],
    'Week': [300, 260, 340, 300, 380, 420, 360, 400, 340, 460, 320, 500],
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Company Growth', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              _RangeToggle(selected: _range, onChanged: (r) => setState(() => _range = r)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: CustomPaint(
              painter: _GrowthChartPainter(values: _series[_range]!, isMobile: isMobile),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "This Month ⌄" dropdown
class _PeriodDropdown extends StatefulWidget {
  const _PeriodDropdown();

  @override
  State<_PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<_PeriodDropdown> {
  static const _options = ['This Week', 'This Month', 'This Year'];
  String _selected = 'This Month';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: _selected,
      onSelected: (value) => setState(() => _selected = value),
      itemBuilder: (context) =>
          _options.map((o) => PopupMenuItem<String>(value: o, child: Text(o))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selected, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _RangeToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _RangeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Year', 'Month', 'Week'].map((label) {
          final isSelected = label == selected;
          return GestureDetector(
            onTap: () => onChanged(label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  final List<double> values;
  final bool isMobile;

  const _GrowthChartPainter({required this.values, this.isMobile = false});

  @override
  void paint(Canvas canvas, Size size) {
    const maxY = 1000.0;
    const gridValues = [1000, 800, 600, 400, 200];
    const leftPad = 36.0;
    const bottomPad = 20.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad;

    final gridPaint = Paint()
      ..color = AppColors.inputBorder
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(color: AppColors.textSecondary, fontSize: 10);

    for (final g in gridValues) {
      final y = chartH - (g / maxY) * chartH;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: '$g', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    if (values.isEmpty) return;

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = leftPad + (chartW / (values.length - 1)) * i;
      final y = chartH - (values[i] / maxY) * chartH;
      points.add(Offset(x, y));
    }

    // Smooth curve through the points, using a Catmull-Rom spline converted to cubic Beziers.
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i == 0 ? points[i] : points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

      final cp1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final cp2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, chartH)
      ..lineTo(points.first.dx, chartH)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.25),
          AppColors.primaryPurple.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartH));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Month markers, thinned out on narrow screens so labels don't overlap.
    final step = isMobile ? 2 : 1;
    for (int i = 0; i < points.length; i += step) {
      final tp = TextPainter(
        text: TextSpan(text: '${i + 1}', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(points[i].dx - tp.width / 2, chartH + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _GrowthChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.isMobile != isMobile;
}

class _ShipmentTile extends StatefulWidget {
  final _ShipmentData data;
  final bool initiallyExpanded;
  const _ShipmentTile({required this.data, this.initiallyExpanded = true});

  @override
  State<_ShipmentTile> createState() => _ShipmentTileState();
}

class _ShipmentTileState extends State<_ShipmentTile> {
  late bool _expanded = widget.initiallyExpanded;

  _ShipmentData get data => widget.data;

  Color get _statusColor {
    switch (data.status) {
      case 'Delayed':
        return const Color(0xFF003337);
      case 'Paid':
        return AppColors.link;
      default:
        return AppColors.warningText;
    }
  }

  Color get _statusBg {
    switch (data.status) {
      case 'Delayed':
        return const Color(0xFFC0FBFF);
      case 'Paid':
        return const Color(0xFFE9E9FB);
      default:
        return AppColors.warningBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    final processingTimeColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Processing time',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF3A3A3A)),
            const SizedBox(width: 8),
            Text(
              data.processingTime,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
      ],
    );

    const viewMoreTextStyle = TextStyle(
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 1.0,
      color: Color(0xFF262A48),
    );

    final viewMoreButton = OutlinedButton(
      onPressed: () => _showComingSoonDialog(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.inputBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('View More', style: viewMoreTextStyle),
    );

    final actionButton = data.isPaid
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEDED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Paid',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.0,
                color: Color(0xFF808080),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: () => _showComingSoonDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF32385E),
              fixedSize: const Size(89.66667175292969, 32),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Pay Now',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0x80DBD7D7), width: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 79,
                    runSpacing: 16,
                    children: [
                      _topField('Tracking ID', data.trackingId, valueColor: const Color(0xFF5A65AB)),
                      _topField('Sender', data.sender, valueColor: const Color(0xFF3A3A3A)),
                      _topField('Receiver', data.receiver, valueColor: const Color(0xFF171717)),
                    ],
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x80DBD7D7), width: 0.5),
                ),
              ),
              child: isMobile
                  ? Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        _locationValue('Pick Up From', data.pickupFrom),
                        _locationValue('Delivery To', data.deliveryTo),
                        _amountValue('Amount', data.amount),
                        _statusField(data.status),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 126, child: _locationValue('Pick Up From', data.pickupFrom)),
                        SizedBox(width: 126, child: _locationValue('Delivery To', data.deliveryTo)),
                        SizedBox(width: 62, child: _amountValue('Amount', data.amount)),
                        SizedBox(width: 73, child: _statusField(data.status)),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  processingTimeColumn,
                  const SizedBox(height: 16),
                  Row(children: [viewMoreButton, const SizedBox(width: 8), actionButton]),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  processingTimeColumn,
                  Row(children: [viewMoreButton, const SizedBox(width: 8), actionButton]),
                ],
              ),
          ],
        ],
      ),
    );
  }

  // Tracking ID / Sender / Receiver header fields
  Widget _topField(String label, String value, {required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 0,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // Amount field
  Widget _amountValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF171717),
          ),
        ),
      ],
    );
  }

  // Status field
  Widget _statusField(String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: _statusBg, borderRadius: BorderRadius.circular(8)),
          child: Text(
            status,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.0,
              color: _statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _NigeriaFlagIcon(),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF171717),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A small, code-drawn Nigerian flag (green-white-green) 
class _NigeriaFlagIcon extends StatelessWidget {
  final double width;
  final double height;
  const _NigeriaFlagIcon({this.width = 16, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            Expanded(child: Container(color: const Color(0xFF008751))),
            Expanded(child: Container(color: Colors.white)),
            Expanded(child: Container(color: const Color(0xFF008751))),
          ],
        ),
      ),
    );
  }
}