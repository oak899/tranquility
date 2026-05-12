import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const Color kGold = Color(0xFFC49B63);
const Color kCharcoal = Color(0xFF1A1A1A);
const Color kCream = Color(0xFFF8F5F0);
const String kBookNowUrl =
    'https://www.orderonlinehub.com/servicesnostaff/tranquilityhydrotherapy_hf8w7q93ghgf8926q3vr9q2g8vrt6gq';

/// Social links from https://tranquilityhydrotherapy.com/index.html
const String kInstagramUrl = 'https://www.instagram.com/tranquility.oakbrook/';
const String kFacebookUrl = 'https://www.facebook.com/p/Tranquility-Hydrotherapy-61570059159325/';
const String kYelpUrl = 'https://www.yelp.com/biz/tranquility-hydrotherapy-oakbrook-terrace-2';

/// Opens in Google Maps (search) for the salon address.
const String kSalonGoogleMapsUrl =
    'https://www.google.com/maps/search/?api=1&query=17W580%20Butterfield%20Rd%20Suit%20G%2C%202F%2C%20Oakbrook%20Terrace%2C%20IL%2060181';

const String kSalonPhoneDisplay = '(630) 590-3188';
const String kSalonPhoneTel = 'tel:+16305903188';
const String kSalonEmailAddress = 'tranquilityhydrotherapy@gmail.com';
const String kSalonEmailMailto = 'mailto:tranquilityhydrotherapy@gmail.com';

/// Font Awesome 6 brands (`fab`), from bundled [assets/fonts/fa-brands-400.ttf].
/// We ship the full TTF so glyphs are not broken by Flutter's icon font tree-shaking
/// (which can corrupt subset fonts for `font_awesome_flutter` on web/release builds).
const IconData kBrandIconYelp = IconData(0xf1e9, fontFamily: 'TranquilityFaBrands');
const IconData kBrandIconFacebookF = IconData(0xf39e, fontFamily: 'TranquilityFaBrands');
const IconData kBrandIconInstagram = IconData(0xf16d, fontFamily: 'TranquilityFaBrands');

/// Brand marks resolved via public favicon endpoints (same sites as salon retail partners).
const String kOwayBrandIconUrl =
    'https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://pro.owayusa.com&size=128';
const String kGmCollinBrandIconUrl =
    'https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://gmcollin.com&size=128';

Future<bool> launchTranquilityBookingUrl() async {
  final Uri uri = Uri.parse(kBookNowUrl);
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> launchExternalUrl(String url) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

void main() {
  runApp(const TranquilityApp());
}

class TranquilityApp extends StatelessWidget {
  const TranquilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: kGold, brightness: Brightness.light);
    final ThemeData seed = ThemeData(colorScheme: scheme, useMaterial3: true);
    final TextTheme inter = GoogleFonts.interTextTheme(seed.textTheme);
    return MaterialApp(
      title: 'Tranquility Hydrotherapy',
      debugShowCheckedModeBanner: false,
      theme: seed.copyWith(
        scaffoldBackgroundColor: kCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: kCharcoal,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: kCharcoal,
          indicatorColor: kGold,
          iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.white)),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        textTheme: inter.copyWith(
          headlineSmall: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: kCharcoal,
            height: 1.12,
          ),
          titleLarge: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: kCharcoal,
            height: 1.15,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: kCharcoal,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: kCharcoal,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: const Color(0xFF57534E),
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: const Color(0xFF57534E),
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.45,
            color: const Color(0xFF78716C),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withOpacity(0.93),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
      ),
      home: const SiteShell(),
    );
  }
}

class SiteShell extends StatefulWidget {
  const SiteShell({super.key});
  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  int _index = 0;
  int _lastIndex = 0;

  Widget _body() {
    switch (_index) {
      case 0:
        return const HomePage();
      case 1:
        return const ServicesPage();
      case 2:
        return const MembershipPage();
      default:
        return const AboutPage();
    }
  }

  void _bookNow() {
    launchTranquilityBookingUrl().then((bool ok) {
      if (!mounted || ok) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the booking page.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final double dx = _index >= _lastIndex ? 0.08 : -0.08;
          final Animation<Offset> offset = Tween<Offset>(
            begin: Offset(dx, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_index),
          child: _index == 0
              ? _body()
              : SafeArea(
                  bottom: false,
                  child: _body(),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _AnimatedBookFab(onTap: _bookNow),
      bottomNavigationBar: BottomAppBar(
        color: kCharcoal,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 66,
          child: Row(
            children: <Widget>[
              _BottomTabButton(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: _index == 0,
                onTap: () => setState(() {
                  _lastIndex = _index;
                  _index = 0;
                }),
              ),
              _BottomTabButton(
                icon: Icons.water_drop_rounded,
                label: 'Services',
                selected: _index == 1,
                onTap: () => setState(() {
                  _lastIndex = _index;
                  _index = 1;
                }),
              ),
              const Spacer(),
              _BottomTabButton(
                icon: Icons.workspace_premium_rounded,
                label: 'Member',
                selected: _index == 2,
                onTap: () => setState(() {
                  _lastIndex = _index;
                  _index = 2;
                }),
              ),
              _BottomTabButton(
                icon: Icons.spa_rounded,
                label: 'About',
                selected: _index == 3,
                onTap: () => setState(() {
                  _lastIndex = _index;
                  _index = 3;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryScaffold extends StatelessWidget {
  const SecondaryScaffold({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kCharcoal,
          ),
        ),
        backgroundColor: kCream,
        foregroundColor: kCharcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: child,
    );
  }
}

class _HomeExperienceOffer {
  const _HomeExperienceOffer({
    required this.imageAsset,
    required this.kicker,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String kicker;
  final String title;
  final String subtitle;
}

/// Full-bleed art for the Home hero; one primary and one soft overlay are picked at random.
const List<String> _kHeroCoverPool = <String>[
  'assets/images/bg_4.jpg',
  'assets/images/bg_2.jpg',
  'assets/images/intro.jpg',
  'assets/images/about1.jpg',
  'assets/images/about2.jpg',
  'assets/images/about3.jpg',
  'assets/images/about4.jpg',
  'assets/images/about5.jpg',
  'assets/images/about6.jpg',
  'assets/images/membership.jpg',
];

const List<_HomeExperienceOffer> _kHomeExperiences = <_HomeExperienceOffer>[
  _HomeExperienceOffer(
    imageAsset: 'assets/images/about1.jpg',
    kicker: 'Relax',
    title: 'Relax & Unwind',
    subtitle: 'Deep relaxation and stress relief — your reset in Oak Brook.',
  ),
  _HomeExperienceOffer(
    imageAsset: 'assets/images/about2.jpg',
    kicker: 'Glow',
    title: 'Glow & Rejuvenate',
    subtitle: 'Scalp and skin care for a visible, healthy-looking glow.',
  ),
  _HomeExperienceOffer(
    imageAsset: 'assets/images/about4.jpg',
    kicker: 'Restore',
    title: 'Targeted Scalp Care',
    subtitle: 'Address oil, dryness, and thinning with a plan tailored to you.',
  ),
];

class _RevealStagger extends StatelessWidget {
  const _RevealStagger({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? _) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 28),
            child: child,
          ),
        );
      },
    );
  }
}

class _HomeImmersiveHero extends StatelessWidget {
  const _HomeImmersiveHero({
    required this.viewportHeight,
    required this.parallaxOffset,
    required this.primaryAsset,
    required this.overlayAsset,
    required this.logoAnim,
    required this.titleAnim,
    required this.subAnim,
    required this.badgeAnim,
  });

  /// Height of the visible body (fills first screen above bottom nav on phones).
  final double viewportHeight;
  final double parallaxOffset;
  final String primaryAsset;
  /// Optional second photo blended softly over [primaryAsset]; empty string means skip.
  final String overlayAsset;
  final Animation<double> logoAnim;
  final Animation<double> titleAnim;
  final Animation<double> subAnim;
  final Animation<double> badgeAnim;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final double topInset = mq.viewPadding.top;
    final double w = mq.size.width;
    // Full viewport hero again (user request): first fold is the cover.
    final double heroHeight = math.max(420, viewportHeight);
    final double parallax = (parallaxOffset * 0.32).clamp(0.0, 96.0);
    // Logo scales with hero height but stays readable on small phones / large phablets.
    final double logoMaxH = math.min(math.max(heroHeight * 0.24, 108.0), 216.0);
    final double titleSize = w < 360 ? 26.0 : (w < 420 ? 28.0 : 30.0);
    // Warm editorial grade (no cool green) so type + kGold read as one spa story.
    const Color kHeroShadow = Color(0xFF1A1410);
    const Color kHeroRich = Color(0xFF120F0D);
    const Color kHeroParchment = Color(0xFFF2E8DC);
    const Color kHeroMusk = Color(0xFFB8A99A);
    const Color kHeroGlass = Color(0xFF2A2622);
    const Color kHeroBorder = Color(0xFFD4B896);

    return ClipRect(
      child: SizedBox(
        height: heroHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, -parallax),
              child: Transform.scale(
                scale: 1.05,
                alignment: Alignment.center,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      primaryAsset,
                      key: ValueKey<String>(primaryAsset),
                      fit: BoxFit.cover,
                      height: heroHeight + 96,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                    if (overlayAsset.isNotEmpty)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Image.asset(
                            overlayAsset,
                            key: ValueKey<String>('overlay-$overlayAsset'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            color: const Color(0xFFFFF4E8).withOpacity(0.1),
                            colorBlendMode: BlendMode.softLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Warm film grade: anchors typography without fighting random hero photos.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const <double>[0.0, 0.32, 0.58, 1.0],
                  colors: <Color>[
                    kHeroShadow.withOpacity(0.42),
                    kHeroShadow.withOpacity(0.18),
                    kHeroRich.withOpacity(0.5),
                    kHeroRich.withOpacity(0.82),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: heroHeight * 0.35,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const <double>[0.0, 0.55, 1.0],
                      colors: <Color>[
                        kHeroRich.withOpacity(0.55),
                        kHeroRich.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: heroHeight * 0.18,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        kGold.withOpacity(0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 16, 24, 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _RevealStagger(
                    animation: logoAnim,
                    child: Transform.scale(
                      scale: 0.94 + 0.06 * logoAnim.value,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: kHeroGlass.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kHeroBorder.withOpacity(0.28)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.28),
                                  blurRadius: 22,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                              child: SizedBox(
                                height: logoMaxH,
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFE8D5C4),
                                    BlendMode.srcIn,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/logo.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: math.min(26, heroHeight * 0.045)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              kHeroGlass.withOpacity(0.52),
                              kHeroGlass.withOpacity(0.62),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: kHeroBorder.withOpacity(0.22)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.38),
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _RevealStagger(
                                animation: titleAnim,
                                child: Text(
                                  'Luxury head spa experience in Oak Brook',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                    color: kHeroParchment,
                                    height: 1.14,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _RevealStagger(
                                animation: subAnim,
                                child: Text(
                                  'Relax. Reset. See real results.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: kHeroMusk,
                                    height: 1.45,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                              SizedBox(height: math.min(18, heroHeight * 0.032)),
                              _RevealStagger(
                                animation: badgeAnim,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: kHeroRich.withOpacity(0.78),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: kGold.withOpacity(0.38)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.star_rounded, color: kGold, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            '4.9 rated · Loved by 1,000+ clients',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: kHeroParchment.withOpacity(0.92),
                                              letterSpacing: 0.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

class _EditorialPhotoBand extends StatelessWidget {
  const _EditorialPhotoBand({required this.asset, required this.caption, required this.animation});

  final String asset;
  final String caption;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return _RevealStagger(
      animation: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Image.asset(
              asset,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withOpacity(0.72),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 48, 18, 18),
                  child: Text(
                    caption,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFFFFBF5),
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

class _HomeExperienceCard extends StatelessWidget {
  const _HomeExperienceCard({required this.offer, required this.animation});

  final _HomeExperienceOffer offer;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return _RevealStagger(
      animation: animation,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              offer.imageAsset,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    offer.kicker.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: kGold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    offer.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: kCharcoal,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xFF57534E),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final ScrollController _scroll;
  late final AnimationController _entrance;
  late String _heroPrimaryAsset;
  late String _heroOverlayAsset;

  void _shuffleHeroArt() {
    final math.Random r = math.Random();
    final List<String> pool = _kHeroCoverPool;
    _heroPrimaryAsset = pool[r.nextInt(pool.length)];
    if (pool.length <= 1) {
      _heroOverlayAsset = '';
      return;
    }
    String pick;
    int guard = 0;
    do {
      pick = pool[r.nextInt(pool.length)];
      guard++;
    } while (pick == _heroPrimaryAsset && guard < 12);
    _heroOverlayAsset = pick == _heroPrimaryAsset ? '' : pick;
  }

  Animation<double> _seg(double start, double end) {
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _shuffleHeroArt();
    _scroll = ScrollController()..addListener(_onScroll);
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double px = _scroll.hasClients ? _scroll.offset : 0.0;
    final Animation<double> heroLogo = _seg(0.0, 0.28);
    final Animation<double> heroTitle = _seg(0.1, 0.38);
    final Animation<double> heroSub = _seg(0.18, 0.46);
    final Animation<double> heroBadge = _seg(0.26, 0.52);
    final Animation<double> wideA = _seg(0.4, 0.58);
    final Animation<double> exp0 = _seg(0.48, 0.66);
    final Animation<double> exp1 = _seg(0.54, 0.72);
    final Animation<double> exp2 = _seg(0.6, 0.78);
    final Animation<double> wideB = _seg(0.68, 0.84);
    final Animation<double> storiesH = _seg(0.74, 0.88);
    final Animation<double> storiesBlock = _seg(0.78, 0.95);
    final Animation<double> ctaAnim = _seg(0.82, 1.0);

    return _PageBackground(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double viewportH = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : MediaQuery.sizeOf(context).height;
          return RefreshIndicator(
            color: kGold,
            backgroundColor: kCream,
            onRefresh: () async {
              setState(_shuffleHeroArt);
              await Future<void>.delayed(const Duration(milliseconds: 280));
            },
            child: ListView(
              controller: _scroll,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: <Widget>[
                _HomeImmersiveHero(
                  viewportHeight: viewportH,
                  parallaxOffset: px,
                  primaryAsset: _heroPrimaryAsset,
                  overlayAsset: _heroOverlayAsset,
                  logoAnim: heroLogo,
                  titleAnim: heroTitle,
                  subAnim: heroSub,
                  badgeAnim: heroBadge,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _EditorialPhotoBand(
                      asset: 'assets/images/bg_2.jpg',
                      caption: 'Where luxury meets scalp health',
                      animation: wideA,
                    ),
                    const SizedBox(height: 28),
                    _RevealStagger(
                      animation: _seg(0.44, 0.62),
                      child: Text(
                        'Choose your experience',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: kCharcoal,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _RevealStagger(
                      animation: _seg(0.46, 0.64),
                      child: Text(
                        'Not sure where to start? Pick the path that fits you today.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.45,
                          color: const Color(0xFF78716C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HomeExperienceCard(offer: _kHomeExperiences[0], animation: exp0),
                    const SizedBox(height: 14),
                    _HomeExperienceCard(offer: _kHomeExperiences[1], animation: exp1),
                    const SizedBox(height: 14),
                    _HomeExperienceCard(offer: _kHomeExperiences[2], animation: exp2),
                    const SizedBox(height: 28),
                    _EditorialPhotoBand(
                      asset: 'assets/images/intro.jpg',
                      caption: 'Tranquility atmosphere',
                      animation: wideB,
                    ),
                    const SizedBox(height: 28),
                    _RevealStagger(
                      animation: storiesH,
                      child: Text(
                        'Why scalp care matters',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: kCharcoal,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _RevealStagger(
                      animation: _seg(0.76, 0.9),
                      child: Text(
                        'Tap a card to read more — flip for the full story.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.45,
                          color: const Color(0xFF78716C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _RevealStagger(
                      animation: storiesBlock,
                      child: Column(
                        children: _kAboutStories
                            .map(
                              (_AboutStory story) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _AboutFlipCard(story: story),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _RevealStagger(
                      animation: ctaAnim,
                      child: const _BookRitualCard(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
            ),
          );
        },
      ),
    );
  }
}

class _AboutVisitSection extends StatelessWidget {
  const _AboutVisitSection();

  static const List<String> _stripImages = <String>[
    'assets/images/about1.jpg',
    'assets/images/intro.jpg',
    'assets/images/bg_2.jpg',
  ];

  Future<void> _openLink(BuildContext context, String url, String errorLabel) async {
    final bool ok = await launchExternalUrl(url);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $errorLabel')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 68,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _stripImages.length; i++)
                  Expanded(
                    child: Image.asset(
                      _stripImages[i],
                      fit: BoxFit.cover,
                      height: 68,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: kGold.withOpacity(0.85),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Plan your visit',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kCharcoal,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Call, email, or stop by — we are here Mon–Sun.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: const Color(0xFF78716C),
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openLink(context, kSalonPhoneTel, 'phone'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.phone_rounded, color: kCharcoal, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Call us',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF78716C),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kSalonPhoneDisplay,
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: kCharcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: kGold.withOpacity(0.85)),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.06)),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openLink(context, kSalonEmailMailto, 'email'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.email_outlined, color: kCharcoal, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF78716C),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kSalonEmailAddress,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kCharcoal,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: kGold.withOpacity(0.85)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.08)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: kGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.schedule_rounded, color: kCharcoal, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Open hours',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: kCharcoal,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today_outlined, size: 15, color: kGold.withOpacity(0.95)),
                              const SizedBox(width: 6),
                              Text(
                                'Mon – Sun',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF57534E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '10:00 AM – 8:00 PM',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kCharcoal,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Material(
                  color: const Color(0xFFE7E2DA),
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      launchExternalUrl(kSalonGoogleMapsUrl).then((bool ok) {
                        if (!context.mounted || ok) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open Google Maps.')),
                        );
                      });
                    },
                    child: Ink(
                      height: 148,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFFF5F1EB),
                            Color(0xFFD8D2C8),
                            Color(0xFFBAB3A8),
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            right: -20,
                            bottom: -24,
                            child: Icon(
                              Icons.map_rounded,
                              size: 120,
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on_rounded, color: kGold.withOpacity(0.95), size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  '17W580 Butterfield Rd Suit G, 2F',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kCharcoal,
                                    height: 1.35,
                                  ),
                                ),
                                Text(
                                  'Oakbrook Terrace, IL 60181',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF57534E),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.open_in_new_rounded, size: 16, color: kGold.withOpacity(0.95)),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Open in Google Maps',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: kGold,
                                      ),
                                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Same brand marks as https://tranquilityhydrotherapy.com/index.html footer
/// (`fab fa-yelp`, `fab fa-facebook-f`, `fab fa-instagram`).
class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.tooltip,
    required this.url,
    required this.icon,
    required this.hoverColor,
  });

  final String tooltip;
  final String url;
  final IconData icon;
  /// Tailwind-style hover tint from the site (e.g. hover:text-red-500).
  final Color hoverColor;

  static const Color _stone400 = Color(0xFFA8A29E);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        iconSize: 28,
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        style: IconButton.styleFrom(
          foregroundColor: _stone400,
          hoverColor: hoverColor.withOpacity(0.14),
          highlightColor: hoverColor.withOpacity(0.12),
        ),
        onPressed: () {
          launchExternalUrl(url).then((bool ok) {
            if (!context.mounted || ok) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open $tooltip')),
            );
          });
        },
        icon: Icon(icon, color: _stone400),
      ),
    );
  }
}

class _AboutStory {
  const _AboutStory({
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;
}

/// Copy structure from https://tranquilityhydrotherapy.com/aboutus.html
class _AboutPillarLine {
  const _AboutPillarLine({
    required this.titleLead,
    required this.titleRest,
    required this.body,
  });

  final String titleLead;
  final String titleRest;
  final String body;
}

const List<_AboutPillarLine> _kAboutPillars = <_AboutPillarLine>[
  _AboutPillarLine(
    titleLead: 'Beyond Traditional',
    titleRest: 'Hair Care',
    body:
        'We combine advanced scalp care techniques with deep, therapeutic relaxation to elevate your well-being.',
  ),
  _AboutPillarLine(
    titleLead: 'An Experience',
    titleRest: 'Designed for You',
    body:
        'No two guests are the same. Every session is carefully customized to meet your unique needs and preferences.',
  ),
  _AboutPillarLine(
    titleLead: 'Care That Evolves',
    titleRest: 'With You',
    body:
        'Whether you seek pure relaxation or visible results, we adapt our approach to match your journey over time.',
  ),
];

class _AboutHeroSection extends StatelessWidget {
  const _AboutHeroSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white,
              kGold.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'A Ritual of Care',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: kCharcoal,
                height: 1.08,
              ),
            ),
            Text(
              'and Restoration',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: kCharcoal,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '"At Tranquility Hydrotherapy, we believe scalp care is more than a treatment—it\'s a ritual of relaxation, renewal, and balance."',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF44403C),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Luxury head spa and scalp care in Oak Brook — organic products, advanced technology, and rituals tailored to you.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF57534E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutPillarsSection extends StatelessWidget {
  const _AboutPillarsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Our philosophy',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kCharcoal,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'What guides every visit',
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.4,
                color: const Color(0xFF78716C),
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _kAboutPillars.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: 14),
              _AboutPillarTile(line: _kAboutPillars[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _AboutPillarTile extends StatelessWidget {
  const _AboutPillarTile({required this.line});

  final _AboutPillarLine line;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: kGold,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(13)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      line.titleLead,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kCharcoal,
                        height: 1.15,
                      ),
                    ),
                    Text(
                      line.titleRest,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: kCharcoal,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      line.body,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: const Color(0xFF57534E),
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

class _AboutAtmosphereSection extends StatelessWidget {
  const _AboutAtmosphereSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                'assets/images/intro.jpg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 36, 16, 14),
                    child: Text(
                      'Tranquility Atmosphere',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFFFFFBF5),
                        letterSpacing: 0.4,
                      ),
                    ),
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

class _BookRitualCard extends StatelessWidget {
  const _BookRitualCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      color: kCharcoal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Experience the Ritual',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFFBF5),
                height: 1.12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Step away from the noise and allow yourself a moment of true restoration.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.55,
                color: const Color(0xFFD6D3D1),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: kCharcoal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                launchTranquilityBookingUrl().then((bool ok) {
                  if (!context.mounted || ok) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open the booking page.')),
                  );
                });
              },
              child: Text(
                'Book your visit',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutQuickLinksCard extends StatelessWidget {
  const _AboutQuickLinksCard();

  void _open(BuildContext context, Widget page) {
    Navigator.push<void>(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.help_outline_rounded, color: kGold),
            title: Text('FAQ', style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              'Policies, preparation, and common questions',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: kGold),
            onTap: () => _open(
              context,
              const SecondaryScaffold(title: 'FAQ', child: FaqPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutFollowUsSection extends StatelessWidget {
  const _AboutFollowUsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Follow us',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kCharcoal,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Stay in touch for specials, hours, and new treatments.',
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.45,
                color: const Color(0xFF78716C),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _SocialIconButton(
                  tooltip: 'Yelp',
                  url: kYelpUrl,
                  icon: kBrandIconYelp,
                  hoverColor: Color(0xFFEF4444),
                ),
                SizedBox(width: 32),
                _SocialIconButton(
                  tooltip: 'Facebook',
                  url: kFacebookUrl,
                  icon: kBrandIconFacebookF,
                  hoverColor: Color(0xFF2563EB),
                ),
                SizedBox(width: 32),
                _SocialIconButton(
                  tooltip: 'Instagram',
                  url: kInstagramUrl,
                  icon: kBrandIconInstagram,
                  hoverColor: Color(0xFFDB2777),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const List<_AboutStory> _kAboutStories = <_AboutStory>[
  _AboutStory(
    image: 'assets/images/about1.jpg',
    title: 'The Importance of Scalp Health',
    body:
        'A healthy scalp is the foundation of beautiful, strong hair. At Tranquility Hydrotherapy, we understand that scalp wellness is essential not only for vibrant hair growth but also for overall well-being. A well-nourished scalp promotes circulation, balances oil production, and prevents issues such as dandruff, dryness, and hair thinning. By focusing on scalp health, we help you address underlying concerns and achieve long-term vitality for both your hair and scalp.',
  ),
  _AboutStory(
    image: 'assets/images/about2.jpg',
    title: 'Organic Excellence',
    body:
        'We are committed to using only the finest organic products, carefully selected for their purity, effectiveness, and gentle impact on both your scalp and the environment. Free from harmful chemicals, our treatments nourish and protect while providing deep cleansing and hydration. Each product is crafted to naturally restore balance and vitality to your scalp, ensuring optimal results with lasting benefits.',
  ),
  _AboutStory(
    image: 'assets/images/about3.jpg',
    title: 'Advanced Technology for Optimal Care',
    body:
        'To deliver a truly bespoke experience, we utilize the most advanced technology available in scalp care. From precision scalp analysis tools to high-frequency devices that stimulate blood flow and encourage healthy hair growth, our equipment ensures every treatment is customized to meet your specific needs. This cutting-edge approach allows us to go beyond surface care, providing deeper, more effective results.',
  ),
  _AboutStory(
    image: 'assets/images/about4.jpg',
    title: 'Unique and Personalized Services',
    body:
        'Every client at Tranquility Hydrotherapy receives a tailor-made experience. Our expert team will assess your scalp condition, identify your needs, and curate a selection of personalized treatments just for you. Whether you are looking to address specific concerns or simply indulge in a luxurious, relaxing experience, our unique services are designed to soothe, rejuvenate, and transform. From detoxifying treatments to calming scalp massages, we offer a complete sensory escape.',
  ),
  _AboutStory(
    image: 'assets/images/about5.jpg',
    title: 'Experience the Pinnacle of Luxury',
    body:
        'From the moment you arrive, you will be immersed in a world of tranquility and luxury. Our serene environment, combined with our passion for excellence, ensures that your visit is not only deeply restorative but also indulgent. At Tranquility Hydrotherapy, you will experience the finest scalp care treatments designed to renew both your scalp and your spirit.',
  ),
];

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _AboutHeroSection(),
          _AboutPillarsSection(),
          _AboutAtmosphereSection(),
          _BookRitualCard(),
          _AboutVisitSection(),
          _AboutQuickLinksCard(),
          _AboutFollowUsSection(),
        ],
      ),
    );
  }
}

class _AboutFlipCard extends StatefulWidget {
  const _AboutFlipCard({required this.story});
  final _AboutStory story;

  @override
  State<_AboutFlipCard> createState() => _AboutFlipCardState();
}

class _AboutFlipCardState extends State<_AboutFlipCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  bool _showBack = false;

  void _flip() {
    if (_showBack) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _showBack = !_showBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: _flip,
        onHorizontalDragEnd: (DragEndDetails details) {
          final double v = details.primaryVelocity ?? 0;
          if (v.abs() > 120) _flip();
        },
        child: AnimatedBuilder(
          animation: CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
          builder: (_, __) {
            final double angle = _controller.value * math.pi;
            final bool isBack = angle > math.pi / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _AboutBack(story: widget.story, onFlip: _flip),
                    )
                  : _AboutFront(story: widget.story, onFlip: _flip),
            );
          },
        ),
      ),
    );
  }
}

class _AboutFront extends StatelessWidget {
  const _AboutFront({required this.story, required this.onFlip});
  final _AboutStory story;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 340,
          width: double.infinity,
          child: Image.asset(story.image, fit: BoxFit.cover),
        ),
        Positioned(
          right: 14,
          top: 14,
          child: Material(
            color: kGold,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onFlip,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.arrow_forward_rounded, color: kCharcoal),
              ),
            ),
          ),
        ),
        Positioned(
          left: 14,
          right: 14,
          bottom: 14,
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Colors.black.withOpacity(0.72),
                  Colors.black.withOpacity(0.38),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              story.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFFFFBF5),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                height: 1.22,
                letterSpacing: 0.35,
                shadows: const <Shadow>[
                  Shadow(color: Color(0x8C000000), blurRadius: 10, offset: Offset(0, 2)),
                  Shadow(color: Color(0x4D000000), blurRadius: 3, offset: Offset(0, 1)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutBack extends StatelessWidget {
  const _AboutBack({required this.story, required this.onFlip});
  final _AboutStory story;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Opacity(
              opacity: 0.58,
              child: Image.asset(story.image, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0.38),
                    Colors.black.withOpacity(0.58),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 52, 14, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x9A1C1C1C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        story.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFF7ED),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        story.body,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: const Color(0xFFFAFAF9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Material(
              color: kGold,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onFlip,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.arrow_forward_rounded, color: kCharcoal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.price,
    required this.imageAsset,
    required this.summary,
    required this.points,
    this.highlightsLabel = 'Highlights included',
  });
  final String title;
  final String price;
  final String imageAsset;
  final String summary;
  final List<String> points;
  /// Shown above the bullet list (e.g. "Benefits" for clinical facials).
  final String highlightsLabel;
}

class ServiceBlock {
  const ServiceBlock({
    this.badge,
    required this.title,
    this.subtitle,
    required this.items,
    this.bannerImageAsset,
  });
  final String? badge;
  final String title;
  final String? subtitle;
  final List<ServiceItem> items;
  /// When set, category banner uses this instead of the first service image (avoids duplicate hero + first card).
  final String? bannerImageAsset;
}

/// Service catalog aligned with https://tranquilityhydrotherapy.com/services.html
const List<ServiceBlock> kServiceCatalog = <ServiceBlock>[
  ServiceBlock(
    badge: 'The Classics',
    title: 'Signature Head Spa Rituals',
    bannerImageAsset: 'assets/images/about1.jpg',
    items: <ServiceItem>[
      ServiceItem(
        title: 'Essential Head Spa',
        price: '60 min · \$128',
        imageAsset: 'assets/images/image_2.jpg',
        summary: 'A perfect introduction to deep relaxation and scalp health.',
        points: <String>[
          'Scalp testing & analysis',
          'Essential oil & scalp relaxation',
          'Neck & shoulder massage',
          'Deep cleansing & effectiveness shampoo',
          'Hydrotherapy nano evaporation & steam',
          'High-frequency antimicrobial care',
        ],
      ),
      ServiceItem(
        title: 'Hydrating Head Spa',
        price: '90 min · \$168',
        imageAsset: 'assets/images/image_3.jpg',
        summary: 'Extended relaxation with intense hydration and advanced therapy.',
        points: <String>[
          'All Essential Head Spa benefits',
          'Healing shampoo & extended spa relaxation',
          'Scalp oxygenation',
          'Professional scalp essence introduction',
          'Advanced light therapy',
        ],
      ),
    ],
  ),
  ServiceBlock(
    badge: 'Ultimate Rejuvenation',
    title: 'Head Spa & Facial',
    bannerImageAsset: 'assets/images/about3.jpg',
    items: <ServiceItem>[
      ServiceItem(
        title: 'Essential Head Spa & Facial',
        price: '60 min · \$168',
        imageAsset: 'assets/images/image_6.jpg',
        summary: 'A holistic treatment nourishing both skin and scalp for a radiant glow.',
        points: <String>[
          'Facial cleansing & relaxation massage',
          'RF energy treatment for firming',
          'Hydrating/purifying facial mask',
          'Deep scalp cleansing & nano hydrotherapy',
        ],
      ),
      ServiceItem(
        title: 'Luxury Head Spa & Facial',
        price: '90 min · \$208',
        imageAsset: 'assets/images/image_2.jpg',
        summary: 'The pinnacle of luxury. Complete head-to-toe relaxation and anti-aging care.',
        points: <String>[
          'All Essential Facial & Spa benefits',
          'Eye ion ball treatment (targets dark circles)',
          'Extended micro-mist steam therapy',
          'High-frequency comb antibacterial care',
        ],
      ),
    ],
  ),
  ServiceBlock(
    badge: 'Advanced Skincare',
    title: 'Clinical Facial Treatments',
    bannerImageAsset: 'assets/images/about2.jpg',
    items: <ServiceItem>[
      ServiceItem(
        title: 'ALGOMASK+ Customized Facial',
        price: '60 min · \$169',
        imageAsset: 'assets/images/image_8.jpg',
        summary:
            'Delivers instant radiance and long-lasting hydration. Suitable for all skin types and conditions.',
        highlightsLabel: 'Benefits',
        points: <String>[
          'Moisturizes and tones the skin, reducing visible redness',
          'Provides instant radiance and maintains hydration',
          'Hydrates, soothes, and revitalizes',
          'Recommended frequency — Intensive cure: 3–6 treatments (once a week). Maintenance: 1 treatment every 4 weeks.',
        ],
      ),
      ServiceItem(
        title: 'Oxygenating Professional',
        price: '70 min · \$199',
        imageAsset: 'assets/images/image_9.jpg',
        summary:
            'A 5-step treatment with a unique Oxygen Complex and patented Peptides to purify and restore glow.',
        highlightsLabel: 'Benefits',
        points: <String>[
          'Minimizes breakouts & calms inflammation redness',
          'Provides a mattifying effect for balanced skin',
          'Restores luminosity and youthful glow',
          'Color, paraben, alcohol, and fragrance-free',
          'Recommended frequency — Maintenance: 1 treatment every 4 weeks.',
        ],
      ),
      ServiceItem(
        title: 'HYDROLIFTING Professional',
        price: '70 min · \$199',
        imageAsset: 'assets/images/image_10.jpg',
        summary:
            'An uplifting treatment designed to restore firmness and youthful appearance for sagging skin.',
        highlightsLabel: 'Benefits',
        points: <String>[
          'Improves visible toning of face and neck',
          'Provides deep and lasting hydration',
          'Enhances radiance with age-defying results',
          'Recommended frequency — Maintenance: 1 treatment every 3 weeks.',
        ],
      ),
      ServiceItem(
        title: 'Collagen-90 Clinical',
        price: '80 min · \$229',
        imageAsset: 'assets/images/image_11.jpg',
        summary:
            'A prestigious, rejuvenating treatment featuring Collagen 90-II to reduce visible signs of aging.',
        highlightsLabel: 'Benefits',
        points: <String>[
          'Minimizes fine lines and wrinkles',
          'Rejuvenates and tightens for flawless skin',
          'Deeply hydrates for a plump, radiant complexion',
          'Recommended frequency — Maintenance: 1 treatment every 4 weeks.',
        ],
      ),
    ],
  ),
  ServiceBlock(
    badge: 'Specialized Care',
    title: 'Targeted Scalp Therapies',
    bannerImageAsset: 'assets/images/about4.jpg',
    items: <ServiceItem>[
      ServiceItem(
        title: 'Purifying Scalp Therapy',
        price: '90 min · \$198',
        imageAsset: 'assets/images/image_4.jpg',
        summary:
            'Designed to relieve itchiness, reduce inflammation, and eliminate dandruff using microcurrent ion therapy and negative ion oxygen infusion.',
        points: <String>[],
      ),
      ServiceItem(
        title: 'Regrowth Scalp Therapy',
        price: '90 min · \$198',
        imageAsset: 'assets/images/image_5.jpg',
        summary:
            'An anti-aging regimen utilizing Low-Level Laser Therapy Regeneration to prevent hair loss, heal the scalp, and promote healthy growth.',
        points: <String>[],
      ),
      ServiceItem(
        title: 'Calming Scalp Therapy',
        price: '90 min · \$198',
        imageAsset: 'assets/images/about6.jpg',
        summary:
            'For sensitive or damaged scalps. Features an epithelial-regenerating mask and gentle hypoallergenic care to repair the skin barrier.',
        points: <String>[],
      ),
    ],
  ),
  ServiceBlock(
    badge: 'Duo Spa',
    title: 'Duo Spa Experiences',
    subtitle: 'Perfect for couples, friends & family',
    bannerImageAsset: 'assets/images/about4.jpg',
    items: <ServiceItem>[
      ServiceItem(
        title: 'Head Spa ×2',
        price: 'Contact to book',
        imageAsset: 'assets/images/intro.jpg',
        summary: 'Two guests enjoy head spa together side by side.',
        points: <String>[],
      ),
      ServiceItem(
        title: 'Head Spa + Facial',
        price: 'Contact to book',
        imageAsset: 'assets/images/about5.jpg',
        summary: 'Full relaxation combined with skin rejuvenation.',
        points: <String>[],
      ),
      ServiceItem(
        title: 'Mix & Match',
        price: 'Contact to book',
        imageAsset: 'assets/images/image_3.jpg',
        summary: 'Each guest chooses their own personalized service.',
        points: <String>[],
      ),
    ],
  ),
];

/// Full-bleed hero for Services — aligned with https://tranquilityhydrotherapy.com/services.html tone.
class _ServicesImmersiveHero extends StatelessWidget {
  const _ServicesImmersiveHero({
    required this.parallaxOffset,
    required this.titleAnim,
    required this.subAnim,
    required this.chipAnim,
  });

  final double parallaxOffset;
  final Animation<double> titleAnim;
  final Animation<double> subAnim;
  final Animation<double> chipAnim;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double heroHeight = math.max(480, h * 0.62);
    final double parallax = (parallaxOffset * 0.32).clamp(0.0, 100.0);
    return ClipRect(
      child: SizedBox(
        height: heroHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, -parallax),
              child: Transform.scale(
                scale: 1.07,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/image_3.jpg',
                  fit: BoxFit.cover,
                  height: heroHeight + 72,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.62),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 48, 22, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _RevealStagger(
                    animation: titleAnim,
                    child: Text(
                      'Where your ritual begins',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        height: 1.08,
                        shadows: const <Shadow>[
                          Shadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 3)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _RevealStagger(
                    animation: subAnim,
                    child: Text(
                      'Signature head spa, clinical facials, and targeted scalp therapies — each session tailored to you.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFE7E5E4),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _RevealStagger(
                    animation: chipAnim,
                    child: const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _ServicesHeroChip(label: 'Head spa'),
                        _ServicesHeroChip(label: 'Facials'),
                        _ServicesHeroChip(label: 'Scalp therapy'),
                        _ServicesHeroChip(label: 'Duo spa'),
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
}

class _ServicesHeroChip extends StatelessWidget {
  const _ServicesHeroChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFFFBF5),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ServiceCategoryBanner extends StatelessWidget {
  const _ServiceCategoryBanner({
    required this.block,
    required this.animation,
  });

  final ServiceBlock block;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final String bannerAsset = block.bannerImageAsset ?? block.items.first.imageAsset;
    return _RevealStagger(
      animation: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Image.asset(
              bannerAsset,
              height: 168,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 40, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (block.badge != null)
                        Text(
                          block.badge!.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: kGold,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 2.2,
                          ),
                        ),
                      if (block.badge != null) const SizedBox(height: 6),
                      Text(
                        block.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFFFFFBF5),
                          height: 1.12,
                        ),
                      ),
                      if (block.subtitle != null) ...<Widget>[
                        const SizedBox(height: 6),
                        Text(
                          block.subtitle!,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFE7E5E4),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
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

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
  late final ScrollController _scroll;
  late final AnimationController _entrance;

  Animation<double> _seg(double start, double end) {
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData base = Theme.of(context);
    final double px = _scroll.hasClients ? _scroll.offset : 0.0;

    int step = 0;
    Animation<double> nextAnim() {
      final double start = (0.035 + step * 0.024).clamp(0.0, 0.9);
      step++;
      double end = start + 0.038;
      if (end > 0.98) end = 0.98;
      if (end <= start) end = start + 0.02;
      return _seg(start, end);
    }

    final Animation<double> introAnim = nextAnim();
    final Animation<double> editorialAnim = nextAnim();
    final Animation<double> menuTitleAnim = nextAnim();
    final Animation<double> menuSubAnim = nextAnim();

    final List<Widget> catalogWidgets = <Widget>[];
    for (final ServiceBlock block in kServiceCatalog) {
      catalogWidgets.add(_ServiceCategoryBanner(block: block, animation: nextAnim()));
      catalogWidgets.add(const SizedBox(height: 12));
      for (final ServiceItem item in block.items) {
        catalogWidgets.add(_ServiceCard(item: item, entranceAnim: nextAnim()));
      }
    }

    final Animation<double> premiumAnim = nextAnim();
    final Animation<double> bookAnim = nextAnim();

    return Theme(
      data: base.copyWith(
        listTileTheme: ListTileThemeData(
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: kCharcoal,
            height: 1.2,
          ),
          subtitleTextStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kGold,
            height: 1.2,
          ),
        ),
      ),
      child: _PageBackground(
        child: ListView(
          controller: _scroll,
          padding: EdgeInsets.zero,
          children: <Widget>[
            _ServicesImmersiveHero(
              parallaxOffset: px,
              titleAnim: _seg(0.0, 0.22),
              subAnim: _seg(0.08, 0.28),
              chipAnim: _seg(0.14, 0.34),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _RevealStagger(
                    animation: introAnim,
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Before your treatment',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: kCharcoal,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'At Tranquility Hydrotherapy, your experience begins long before the treatment starts. '
                              'Step into a space designed for stillness—soft light, calming aromas, and a quiet moment just for you.',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 1.55,
                                color: const Color(0xFF57534E),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Wrapped in comfort, you\'ll unwind with herbal tea, gentle warmth, and the feeling of finally slowing down. '
                              'This is more than a service. It\'s a ritual—one that restores balance, nourishes your scalp and skin, and brings you back to yourself.',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 1.55,
                                color: const Color(0xFF57534E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _EditorialPhotoBand(
                    asset: 'assets/images/image_12.jpg',
                    caption: 'Treatments crafted for visible results',
                    animation: editorialAnim,
                  ),
                  const SizedBox(height: 8),
                  _RevealStagger(
                    animation: menuTitleAnim,
                    child: Text(
                      'Our menu',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kCharcoal,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _RevealStagger(
                    animation: menuSubAnim,
                    child: Text(
                      'Explore each category — tap a service to see details.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.45,
                        color: const Color(0xFF78716C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...catalogWidgets,
                  const SizedBox(height: 8),
                  _RevealStagger(
                    animation: premiumAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/image_8.jpg',
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _PremiumProductsPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _RevealStagger(
                    animation: bookAnim,
                    child: const _BookNowLaunchCard(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumBrandTile extends StatelessWidget {
  const _PremiumBrandTile({
    required this.name,
    required this.tagline,
    required this.iconUrl,
    required this.fallbackIcon,
  });

  final String name;
  final String tagline;
  final String iconUrl;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: const Color(0xFFE8E2D9)),
          ),
          padding: const EdgeInsets.all(13),
          child: ClipOval(
            child: Image.network(
              iconUrl,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 30, color: kGold.withOpacity(0.9)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.35,
            color: kCharcoal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          tagline,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B6560),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _PremiumProductsPanel extends StatelessWidget {
  const _PremiumProductsPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Premium products we use',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: kCharcoal,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We use high-quality professional products to deliver the best results for your scalp and skin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.55,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF57534E),
              ),
            ),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints c) {
                final bool narrow = c.maxWidth < 420;
                const Widget row = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PremiumBrandTile(
                      name: 'O WAY',
                      tagline: 'Organic scalp care',
                      iconUrl: kOwayBrandIconUrl,
                      fallbackIcon: Icons.eco_outlined,
                    ),
                    SizedBox(width: 36),
                    _PremiumBrandTile(
                      name: 'GM Collin',
                      tagline: 'Advanced skincare',
                      iconUrl: kGmCollinBrandIconUrl,
                      fallbackIcon: Icons.spa_outlined,
                    ),
                  ],
                );
                if (narrow) {
                  return const Column(
                    children: <Widget>[
                      _PremiumBrandTile(
                        name: 'O WAY',
                        tagline: 'Organic scalp care',
                        iconUrl: kOwayBrandIconUrl,
                        fallbackIcon: Icons.eco_outlined,
                      ),
                      SizedBox(height: 28),
                      _PremiumBrandTile(
                        name: 'GM Collin',
                        tagline: 'Advanced skincare',
                        iconUrl: kGmCollinBrandIconUrl,
                        fallbackIcon: Icons.spa_outlined,
                      ),
                    ],
                  );
                }
                return row;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BookNowLaunchCard extends StatelessWidget {
  const _BookNowLaunchCard({this.headline = 'Book now', this.subline = 'Reserve your visit online'});

  final String headline;
  final String subline;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          launchTranquilityBookingUrl().then((bool ok) {
            if (!context.mounted || ok) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open the booking page.')),
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kGold.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.event_available_rounded, color: kCharcoal, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      headline,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kCharcoal,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subline,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF57534E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Icon(Icons.open_in_new_rounded, size: 16, color: kGold.withOpacity(0.95)),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to open in browser',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: kGold.withOpacity(0.85), size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _MembershipHero extends StatelessWidget {
  const _MembershipHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 210,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset('assets/images/membership.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Member & gift',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE7E5E4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A monthly ritual of restoration',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consistent care, flexible perks, and gifts that invite calm.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF5F5F4),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
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

class _MembershipPhotoStrip extends StatelessWidget {
  const _MembershipPhotoStrip();

  static const List<String> _paths = <String>[
    'assets/images/image_3.jpg',
    'assets/images/image_6.jpg',
    'assets/images/image_2.jpg',
    'assets/images/about5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 72,
        child: Row(
          children: <Widget>[
            for (int i = 0; i < _paths.length; i++)
              Expanded(
                child: Image.asset(_paths[i], fit: BoxFit.cover, height: 72),
              ),
          ],
        ),
      ),
    );
  }
}

class _MembershipChoiceTile extends StatelessWidget {
  const _MembershipChoiceTile({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withOpacity(0.78),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE7E5E4),
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
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

class _MembershipIconLine extends StatelessWidget {
  const _MembershipIconLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kGold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kCharcoal, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kCharcoal,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: const Color(0xFF57534E),
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

class _MembershipPlanCard extends StatelessWidget {
  const _MembershipPlanCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kGold.withOpacity(0.65), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Membership plan',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kCharcoal,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  '\$148',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: kGold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '/ month',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kCharcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _MembershipPlanCard._planLine(Icons.check_circle_outline_rounded, 'Includes one treatment per month'),
            _MembershipPlanCard._planLine(Icons.autorenew_rounded, 'Convenient auto-renewal'),
            _MembershipPlanCard._planLine(Icons.cancel_outlined, 'Cancel anytime — no hidden fees'),
          ],
        ),
      ),
    );
  }

  static Widget _planLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: kGold.withOpacity(0.95)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.45,
                color: const Color(0xFF44403C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftCardShowcase extends StatelessWidget {
  const _GiftCardShowcase();

  static const String _kGiftLifestyle = 'assets/images/giftcard_lifestyle.png';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ColoredBox(
            color: const Color(0xFFF5F2ED),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _kGiftLifestyle,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Give the gift of relaxation',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kCharcoal,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Perfect for any occasion — share a moment of calm and care with those you love.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: const Color(0xFF57534E),
                  ),
                ),
                const SizedBox(height: 14),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _GiftPill(icon: Icons.shopping_bag_outlined, label: 'Online purchase available'),
                    _GiftPill(icon: Icons.storefront_outlined, label: 'Redeem in-store'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Whether it’s a birthday, an anniversary, or a simple thank you, gift cards let your loved ones choose their own path to tranquility.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: const Color(0xFF78716C),
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

class _GiftPill extends StatelessWidget {
  const _GiftPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: kGold.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: kCharcoal.withOpacity(0.85)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kCharcoal,
            ),
          ),
        ],
      ),
    );
  }
}

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _MembershipHero(),
          const SizedBox(height: 14),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Our membership is designed to support your well-being through consistent care.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF44403C),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _MembershipPhotoStrip(),
          const SizedBox(height: 16),
          Text(
            'Your experience',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: kCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Each month, enjoy one of the following:',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF57534E),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints c) {
                if (c.maxWidth < 360) {
                  return const Column(
                    children: <Widget>[
                      Expanded(
                        child: _MembershipChoiceTile(
                          imageAsset: 'assets/images/image_3.jpg',
                          title: '90-Minute Head Spa',
                          subtitle: 'Deep hydration & advanced therapy',
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: _MembershipChoiceTile(
                          imageAsset: 'assets/images/image_6.jpg',
                          title: '60-Min Head Spa + Facial',
                          subtitle: 'Holistic care for scalp & skin',
                        ),
                      ),
                    ],
                  );
                }
                return const Row(
                  children: <Widget>[
                    Expanded(
                      child: _MembershipChoiceTile(
                        imageAsset: 'assets/images/image_3.jpg',
                        title: '90-Minute Head Spa',
                        subtitle: 'Deep hydration & advanced therapy',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _MembershipChoiceTile(
                        imageAsset: 'assets/images/image_6.jpg',
                        title: '60-Min Head Spa + Facial',
                        subtitle: 'Holistic care for scalp & skin',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Benefits',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kCharcoal,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _MembershipIconLine(
                    icon: Icons.savings_outlined,
                    title: 'Unused sessions roll over',
                    subtitle: 'Credits stay valid for up to 12 months.',
                  ),
                  const _MembershipIconLine(
                    icon: Icons.event_available_outlined,
                    title: 'Flexible scheduling',
                    subtitle: 'Book at your convenience with ease.',
                  ),
                  const _MembershipIconLine(
                    icon: Icons.self_improvement_outlined,
                    title: 'No pressure to use monthly',
                    subtitle: 'Consistency without the stress.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Member privileges',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kCharcoal,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _MembershipIconLine(
                    icon: Icons.local_offer_outlined,
                    title: '10% off retail products',
                    subtitle: 'Take your home ritual to the next level.',
                  ),
                  const _MembershipIconLine(
                    icon: Icons.star_border_rounded,
                    title: 'Priority booking',
                    subtitle: 'Preferred access to our most wanted time slots.',
                  ),
                  const _MembershipIconLine(
                    icon: Icons.face_retouching_natural_outlined,
                    title: 'Personalized care',
                    subtitle: 'Custom treatments tailored to your scalp’s evolution.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _MembershipPlanCard(),
          const _BookNowLaunchCard(
            headline: 'Begin your ritual',
            subline: 'Join or manage membership through our booking site',
          ),
          const SizedBox(height: 22),
          Text(
            'Gift cards',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: kCharcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Treat someone special — online purchase & in-store redemption.',
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF78716C), height: 1.35),
          ),
          const SizedBox(height: 12),
          const _GiftCardShowcase(),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 88,
              child: Row(
                children: <Widget>[
                  Expanded(child: Image.asset('assets/images/intro.jpg', fit: BoxFit.cover)),
                  Expanded(child: Image.asset('assets/images/image_2.jpg', fit: BoxFit.cover)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _BookNowLaunchCard(
            headline: 'Buy gift card',
            subline: 'Purchase online — redeem in store',
          ),
        ],
      ),
    );
  }
}

class FaqItem {
  const FaqItem({required this.q, required this.a});
  final String q;
  final String a;
}

const List<FaqItem> kFaqItems = <FaqItem>[
  FaqItem(
    q: 'What does a service entail?',
    a: 'Scalp-focused detox and rejuvenation with specialized products, massage, and acupressure to improve circulation and support hair health.',
  ),
  FaqItem(
    q: 'Will the head spa affect my hair color?',
    a: 'Ingredients are safe, but recent chemical services may lift during detox. Wait at least 7 days after chemical treatment.',
  ),
  FaqItem(
    q: 'Can textured hair be treated?',
    a: 'Service concludes with a simple 80% blow-dry to protect hair health.',
  ),
  FaqItem(
    q: 'Is it safe for expecting mothers?',
    a: 'Please inform us. Some herbs/oils may be sensitive in pregnancy, and lying flat is required. Consult your doctor first.',
  ),
  FaqItem(
    q: 'Are blowouts included?',
    a: 'For hair health, service concludes with a simple 80% blow-dry.',
  ),
  FaqItem(
    q: 'Any contraindications for head spa service?',
    a: 'No services for extensions/braids/sew-ins, scalp infections, scalp sunburn, or recent medical/reconstructive/cosmetic surgery.',
  ),
  FaqItem(
    q: 'How do I prepare for my appointment?',
    a: 'Wear comfortable clothing and detangle hair beforehand. Excessive tangles may reduce treatment time.',
  ),
];

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _TopBanner(
            title: 'FAQ',
            subtitle: 'All FAQ items transferred from web.',
          ),
          ...kFaqItems.map(
            (FaqItem f) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(f.q, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(f.a),
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item, required this.entranceAnim});
  final ServiceItem item;
  final Animation<double> entranceAnim;

  @override
  Widget build(BuildContext context) {
    return _RevealStagger(
      animation: entranceAnim,
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              item.imageAsset,
              height: 220,
              fit: BoxFit.cover,
            ),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Icon(Icons.spa_rounded, color: kGold.withOpacity(0.95)),
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item.price),
                ),
                trailing: Icon(
                  Icons.expand_more_rounded,
                  color: kCharcoal.withOpacity(0.55),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.summary,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.48,
                                color: const Color(0xFF2E2E2E),
                              ),
                        ),
                        if (item.points.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(
                            item.highlightsLabel,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: kCharcoal,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          const SizedBox(height: 8),
                          ...item.points.map((String p) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '• $p',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
                                ),
                              )),
                        ],
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
}

class _PageBackground extends StatelessWidget {
  const _PageBackground({
    required this.child,
    this.imageAsset,
    this.overlayOpacity = 1.0,
  });
  final Widget child;
  final String? imageAsset;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: imageAsset == null
            ? null
            : DecorationImage(
                image: AssetImage(imageAsset!),
                fit: BoxFit.cover,
              ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromRGBO(248, 245, 240, 0.78 * overlayOpacity),
              Color.fromRGBO(248, 245, 240, 0.94 * overlayOpacity),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  const _TopBanner({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: kCharcoal.withOpacity(0.88), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: const Color(0xFFD6D3D1),
              fontSize: 15,
              fontWeight: FontWeight.w300,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomTabButton extends StatelessWidget {
  const _BottomTabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _AnimatedTabInner(
        icon: icon,
        label: label,
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}

class _AnimatedTabInner extends StatefulWidget {
  const _AnimatedTabInner({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_AnimatedTabInner> createState() => _AnimatedTabInnerState();
}

class _AnimatedTabInnerState extends State<_AnimatedTabInner> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final Color color = widget.selected ? kGold : Colors.white70;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.92 : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..scale(widget.selected ? 1.08 : 1.0),
              child: Icon(widget.icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w600,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBookFab extends StatefulWidget {
  const _AnimatedBookFab({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AnimatedBookFab> createState() => _AnimatedBookFabState();
}

class _AnimatedBookFabState extends State<_AnimatedBookFab> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat(reverse: true);
  bool _pressed = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final double pulseScale = 1 + (_pulse.value * 0.035);
        return SizedBox(
          width: 74,
          height: 74,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 110),
              scale: _pressed ? 0.93 : pulseScale,
              child: FloatingActionButton(
                backgroundColor: kGold,
                foregroundColor: kCharcoal,
                shape: const CircleBorder(),
                onPressed: widget.onTap,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.calendar_month_rounded, size: 22),
                    SizedBox(height: 2),
                    Text('Book', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

