import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        cardTheme: CardTheme(
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
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      imageAsset: 'assets/images/bg_4.jpg',
      overlayOpacity: 0.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
        opacity: _show ? 1 : 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const _HomeHero(),
            const SizedBox(height: 16),
            ..._kAboutStories.map(
              (_AboutStory story) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _AboutFlipCard(story: story),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeVisitSection extends StatelessWidget {
  const _HomeVisitSection();

  static const List<String> _stripImages = <String>[
    'assets/images/about1.jpg',
    'assets/images/intro.jpg',
    'assets/images/bg_2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.location_on_outlined, size: 20, color: kGold.withOpacity(0.95)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '17W580 Butterfield Rd Suit G, 2F · Oakbrook Terrace, IL 60181',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF57534E),
                        ),
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

class _SocialLaunchButton extends StatelessWidget {
  const _SocialLaunchButton({
    required this.label,
    required this.url,
    required this.backgroundColor,
    required this.icon,
  });

  final String label;
  final String url;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          launchExternalUrl(url).then((bool ok) {
            if (!context.mounted || ok) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open $label')),
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FaIcon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.open_in_new_rounded, color: Colors.white.withOpacity(0.9), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    final double heroHeight = math.max(520, MediaQuery.of(context).size.height * 0.86);
    final double logoHeight = math.max(320, MediaQuery.of(context).size.height * 0.58);
    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white.withOpacity(0.16),
              Colors.black.withOpacity(0.36),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: logoHeight,
                child: Transform.scale(
                  scale: 2.2,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Welcome to Tranquility Hydrotherapy – Where Luxury Meets Scalp Health',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
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
            leading: const Icon(Icons.card_giftcard_rounded, color: kGold),
            title: Text('Gift cards', style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              'Purchase, redeem, and booking',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: kGold),
            onTap: () => _open(
              context,
              const SecondaryScaffold(title: 'Gift Cards', child: GiftPage()),
            ),
          ),
          Divider(height: 1, color: Colors.black.withOpacity(0.06)),
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
          Divider(height: 1, color: Colors.black.withOpacity(0.06)),
          ListTile(
            leading: const Icon(Icons.contact_phone_rounded, color: kGold),
            title: Text('Contact', style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              'Address, phone, hours',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: kGold),
            onTap: () => _open(
              context,
              const SecondaryScaffold(title: 'Contact', child: ContactPage()),
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
            const SizedBox(height: 14),
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: <Widget>[
                _SocialLaunchButton(
                  label: 'Instagram',
                  url: kInstagramUrl,
                  backgroundColor: Color(0xFFE4405F),
                  icon: FontAwesomeIcons.instagram,
                ),
                _SocialLaunchButton(
                  label: 'Facebook',
                  url: kFacebookUrl,
                  backgroundColor: Color(0xFF1877F2),
                  icon: FontAwesomeIcons.facebookF,
                ),
                _SocialLaunchButton(
                  label: 'Yelp',
                  url: kYelpUrl,
                  backgroundColor: Color(0xFFD32323),
                  icon: FontAwesomeIcons.yelp,
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
      imageAsset: 'assets/images/about1.jpg',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _TopBanner(
            title: 'About Us',
            subtitle: 'Gift cards, FAQ, contact & social',
          ),
          _AboutFollowUsSection(),
          _HomeVisitSection(),
          _AboutQuickLinksCard(),
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
  });
  final String? badge;
  final String title;
  final String? subtitle;
  final List<ServiceItem> items;
}

/// Service catalog aligned with https://tranquilityhydrotherapy.com/services.html
const List<ServiceBlock> kServiceCatalog = <ServiceBlock>[
  ServiceBlock(
    badge: 'The Classics',
    title: 'Signature Head Spa Rituals',
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
        imageAsset: 'assets/images/image_6.jpg',
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
        imageAsset: 'assets/images/image_5.jpg',
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
        imageAsset: 'assets/images/image_6.jpg',
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

/// Matches https://tranquilityhydrotherapy.com/services.html hero (Playfair + Inter, no duplicate tab title).
class _ServicesIntroHero extends StatelessWidget {
  const _ServicesIntroHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: kCharcoal.withOpacity(0.88),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Where your ritual begins',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'At Tranquility Hydrotherapy, your experience begins long before the treatment starts. '
            'Step into a space designed for stillness—soft light, calming aromas, and a quiet moment just for you.',
            style: GoogleFonts.inter(
              color: const Color(0xFFD6D3D1),
              fontSize: 15,
              fontWeight: FontWeight.w300,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Wrapped in comfort, you\'ll unwind with herbal tea, gentle warmth, and the feeling of finally slowing down. '
            'This is more than a service. It\'s a ritual—one that restores balance, nourishes your scalp and skin, and brings you back to yourself.',
            style: GoogleFonts.inter(
              color: const Color(0xFFD6D3D1),
              fontSize: 15,
              fontWeight: FontWeight.w300,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData base = Theme.of(context);
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
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const _ServicesIntroHero(),
            ...kServiceCatalog.expand(
              (ServiceBlock b) => <Widget>[
                _ServiceBlockHeader(block: b),
                ...b.items.map((ServiceItem s) => _ServiceCard(item: s)),
              ],
            ),
            const _PremiumProductsPanel(),
            const _BookNowLaunchCard(),
          ],
        ),
      ),
    );
  }
}

class _ServiceBlockHeader extends StatelessWidget {
  const _ServiceBlockHeader({required this.block});
  final ServiceBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (block.badge != null) ...<Widget>[
            Text(
              block.badge!.toUpperCase(),
              style: GoogleFonts.inter(
                color: const Color(0xFF78716C),
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 2.6,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            block.title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: kCharcoal,
              height: 1.15,
            ),
          ),
          if (block.subtitle != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              block.subtitle!,
              style: GoogleFonts.inter(
                color: const Color(0xFF57534E),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
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
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: const Color(0xFFE8E2D9)),
          ),
          padding: const EdgeInsets.all(20),
          child: ClipOval(
            child: Image.network(
              iconUrl,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 46, color: kGold.withOpacity(0.9)),
            ),
          ),
        ),
        const SizedBox(height: 14),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset('assets/images/giftcard.png', fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Gift of choice',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFFFBEB),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Starting from \$50',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

class GiftPage extends StatelessWidget {
  const GiftPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      imageAsset: 'assets/images/giftcard.png',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _TopBanner(
            title: 'Gift Cards',
            subtitle: 'GIFT CARDS',
          ),
          _SectionCard(
            title: 'Gift Message',
            body:
                'Surprise your loved ones with the gift of relaxation and healthy scalp care. Gift cards can be used toward all available services.',
          ),
          _BookNowLaunchCard(
            headline: 'Book / Redeem',
            subline: 'Use your gift card or book a service online',
          ),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      imageAsset: 'assets/images/bg_2.jpg',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _TopBanner(title: 'Contact Us', subtitle: 'Get in touch'),
          _SectionCard(
            title: 'Address',
            body: '17W580 Butterfield Rd Suit G, 2F, Oakbrook Terrace, IL 60181',
          ),
          _SectionCard(title: 'Phone', body: '(630) 590-3188'),
          _SectionCard(title: 'Email', body: 'tranquilityhydrotherapy@gmail.com'),
          _SectionCard(title: 'Open Hours', body: 'MON - SUN : 10:00 AM - 8:00 PM'),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});
  final ServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.spa_rounded, color: kGold),
        title: Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
        subtitle: Text(item.price),
        trailing: const Icon(Icons.expand_more),
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Image.asset(item.imageAsset, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  const SizedBox(height: 10),
                  Text(
                    item.highlightsLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kCharcoal,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const SizedBox(height: 6),
                  ...item.points.map((String p) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
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

