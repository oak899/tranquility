import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGold = Color(0xFFC49B63);
const Color kCharcoal = Color(0xFF1A1A1A);
const Color kCream = Color(0xFFF8F5F0);
const String kBookNowUrl =
    'https://www.orderonlinehub.com/servicesnostaff/tranquilityhydrotherapy_hf8w7q93ghgf8926q3vr9q2g8vrt6gq';

void main() {
  runApp(const TranquilityApp());
}

class TranquilityApp extends StatelessWidget {
  const TranquilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tranquility Hydrotherapy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGold, brightness: Brightness.light),
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
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: kCharcoal, height: 1.2),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kCharcoal),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF2E2E2E)),
          bodyMedium: TextStyle(fontSize: 15, height: 1.45, color: Color(0xFF2E2E2E)),
        ),
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.93),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: const SiteShell(),
    );
  }
}

class PrimaryTab {
  const PrimaryTab({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

class SiteShell extends StatefulWidget {
  const SiteShell({super.key});
  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  static const List<PrimaryTab> _tabs = <PrimaryTab>[
    PrimaryTab(title: 'Home', icon: Icons.home_rounded),
    PrimaryTab(title: 'Menu', icon: Icons.restaurant_menu_rounded),
    PrimaryTab(title: 'Membership', icon: Icons.workspace_premium_rounded),
    PrimaryTab(title: 'About', icon: Icons.spa_rounded),
  ];

  int _index = 0;

  Widget _body() {
    switch (_index) {
      case 0:
        return const HomePage();
      case 1:
        return const MenuPage();
      case 2:
        return const MembershipPage();
      default:
        return const AboutPage();
    }
  }

  void _openSecondaryMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: kCream,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(title: Text('More'), subtitle: Text('二级页面')),
              ListTile(
                leading: const Icon(Icons.card_giftcard_rounded, color: kGold),
                title: const Text('Gift Cards'),
                onTap: () => _pushSecondary(const SecondaryScaffold(title: 'Gift Cards', child: GiftPage())),
              ),
              ListTile(
                leading: const Icon(Icons.help_rounded, color: kGold),
                title: const Text('FAQ'),
                onTap: () => _pushSecondary(const SecondaryScaffold(title: 'FAQ', child: FaqPage())),
              ),
              ListTile(
                leading: const Icon(Icons.contact_phone_rounded, color: kGold),
                title: const Text('Contact'),
                onTap: () => _pushSecondary(const SecondaryScaffold(title: 'Contact', child: ContactPage())),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _pushSecondary(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  void _bookNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book Now link copied/shown in Home page card.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PrimaryTab tab = _tabs[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text(tab.title),
        actions: <Widget>[
          IconButton(onPressed: _openSecondaryMenu, icon: const Icon(Icons.apps_rounded), tooltip: 'More'),
        ],
      ),
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 74,
        height: 74,
        child: FloatingActionButton(
          backgroundColor: kGold,
          foregroundColor: kCharcoal,
          shape: const CircleBorder(),
          onPressed: _bookNow,
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
                onTap: () => setState(() => _index = 0),
              ),
              _BottomTabButton(
                icon: Icons.restaurant_menu_rounded,
                label: 'Menu',
                selected: _index == 1,
                onTap: () => setState(() => _index = 1),
              ),
              const Spacer(),
              _BottomTabButton(
                icon: Icons.workspace_premium_rounded,
                label: 'Member',
                selected: _index == 2,
                onTap: () => setState(() => _index = 2),
              ),
              _BottomTabButton(
                icon: Icons.spa_rounded,
                label: 'About',
                selected: _index == 3,
                onTap: () => setState(() => _index = 3),
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
    return Scaffold(appBar: AppBar(title: Text(title)), body: child);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      imageAsset: 'assets/images/bg_4.jpg',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _HomeHero(),
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 42,
              child: SvgPicture.asset('assets/images/logo.svg'),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to\nTranquility\nHydrotherapy',
              style: GoogleFonts.playfairDisplay(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: kCharcoal,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Where Luxury Meets Scalp Health',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: kGold,
                height: 1.1,
              ),
            ),
          ],
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

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<_AboutStory> _stories = <_AboutStory>[
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

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      imageAsset: 'assets/images/about1.jpg',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _TopBanner(
            title: 'About Us',
            subtitle: 'Image + Story (click arrow to flip)',
          ),
          const SizedBox(height: 8),
          ..._stories.map((_AboutStory story) => _AboutFlipCard(story: story)),
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
    duration: const Duration(milliseconds: 500),
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
      child: AnimatedBuilder(
        animation: _controller,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              story.title,
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
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
    return Container(
      height: 340,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    story.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: kCharcoal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    story.body,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      height: 1.18,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                ],
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
  });
  final String title;
  final String price;
  final String imageAsset;
  final String summary;
  final List<String> points;
}

const List<ServiceItem> kAllServices = <ServiceItem>[
  ServiceItem(
    title: 'Relaxing Scalp Hydrotherapy',
    price: '\$128 / 60mins',
    imageAsset: 'assets/images/image_2.jpg',
    summary: 'Service Process',
    points: <String>[
      'Scalp testing',
      'Essential oil relaxation',
      'Scalp relaxation',
      'Neck & shoulder relaxation',
      'Scalp deep cleansing',
      'Scalp Effectiveness Shampoo',
      'Nourishing Hair Care',
      'Hydrotherapy Nano Eraporation',
      'Micro-mist steam therapy',
      'High-Frequency comb antimicrobial hair care',
      'Dyson dryer blew dry the hair',
    ],
  ),
  ServiceItem(
    title: 'Relaxing & Hydrating Scalp Hydrotherapy',
    price: '\$168 / 90mins',
    imageAsset: 'assets/images/image_3.jpg',
    summary: 'Service Process',
    points: <String>[
      'Scalp testing',
      'Essential oil relaxation',
      'Scalp relaxation',
      'Scalp deep cleansing',
      'Healing shampoo',
      'Spa relaxation',
      'Micro-mist steam therapy',
      'Nano hair care',
      'Scalp oxygenation',
      'Professional scalp essence introduction',
      'High-Frequency comb antimicrobial hair care',
      'Light therapy',
      'Neck & shoulder massage',
      'Dyson dryer blew dry the hair',
    ],
  ),
  ServiceItem(
    title: 'Facial & Scalp Hydrotherapy',
    price: '\$168 / 60mins',
    imageAsset: 'assets/images/image_6.jpg',
    summary: 'Complete rejuvenation for face and scalp',
    points: <String>[
      'Facial Cleansing (Makeup Removal)',
      'Relaxation Facial Massage',
      'RF Energy Treatment for Firming & Lifting',
      'Hydrating or Purifying Facial Mask',
      'Essential Oil Relaxation Therapy',
      'Scalp Effectiveness Deep Shampoo',
      'Nourishing Hair Treatment',
      'Nano-Extraction Hydrotherapy',
      'Neck & shoulder massage',
      'Dyson Blow-Dry',
    ],
  ),
  ServiceItem(
    title: 'Facial & Relaxing Scalp Hydrotherapy',
    price: '\$208 / 90mins',
    imageAsset: 'assets/images/image_6.jpg',
    summary: 'Complete rejuvenation for face and scalp',
    points: <String>[
      'Facial Cleansing (Makeup Removal)',
      'Facial Massage for Relaxation',
      'Facial RF Energy Treatment for Tightening and Lifting',
      'Eye Ion Ball Treatment',
      'Hydrating or Purifying Facial Mask',
      'Scalp Analysis',
      'Essential Oil Relaxation',
      'Scalp Relaxation Massage',
      'Neck and Shoulder Relaxation Massage',
      'Deep Scalp Cleansing',
      'Functional Scalp Shampoo Treatment',
      'Nourishing Hair Treatment',
      'Nano-Extraction Hydrotherapy',
      'Micro-Mist Steam Therapy',
      'High-Frequency Comb Antibacterial Hair Care',
      'Dyson Blow-Dry',
    ],
  ),
  ServiceItem(
    title: 'Dandruff Control & Purify Treatment',
    price: '\$198 / 90mins',
    imageAsset: 'assets/images/image_4.jpg',
    summary: 'Relieves itchiness, inflammation, and dandruff',
    points: <String>[
      'Scalp detection',
      'Essential oil relaxation',
      'Scalp makeup remover oil',
      'Scalp relaxation',
      'Scalp deep cleansing',
      'Scalp efficacy shampoo',
      'Microcurrent ion follicle cleanser',
      'Scalp hydrotherapy relaxation',
      'Nourishing nano hair care',
      'Scalp Negative Ion Oxygen Infusion Calming',
      'Essence microcurrent ion infusion',
      'Antibacterial Soothing Comb',
      'Microcurrent Phototherapy Follicle Regeneration Device',
      'Meridian Heat Therapy for Shoulder and Neck Relief',
      'Dyson dryer blew dry the hair',
    ],
  ),
  ServiceItem(
    title: 'Anti-Hair Loss & Regrowth Treatment',
    price: '\$198 / 90mins',
    imageAsset: 'assets/images/image_5.jpg',
    summary: 'Scalp healing and anti-aging program',
    points: <String>[
      'Scalp Analysis',
      'Exfoliation - Oil Bath Cleansing',
      'Scalp Essential Oil Relaxation',
      'Customized Deep Cleansing - Healing Shampoo',
      'Microcurrent Ion Follicle Care',
      'Spa Relaxation - Nano Hair Care',
      'Negative Ion Oxygen Infusion',
      'Microcurrent Ion Introduction',
      'High-Frequency Comb Antimicrobial Hair Care',
      'Microcurrent Phototherapy Regenerator',
      'Smart Anti-Aging Nutrient Infusion Device',
      'Scalp Low-Level Laser Therapy Regeneration',
      'Dyson dryer blew dry the hair',
    ],
  ),
  ServiceItem(
    title: 'Sensitive Scalp Soothing & Healing Treatment',
    price: '\$198 / 90mins',
    imageAsset: 'assets/images/image_5.jpg',
    summary: 'For sensitive, irritated, or damaged scalps',
    points: <String>[
      'Scalp detection & sensitivity assessment',
      'Essential oil relaxation',
      'Scalp makeup remover oil',
      'Scalp relaxation massage',
      'Gentle deep cleansing',
      'Hypoallergenic efficacy shampoo',
      'Microcurrent ion follicle cleanser',
      'Scalp hydrotherapy relaxation',
      'Nourishing nano hair care',
      'Soothing repairing epithelial-regenerating scalp mask',
      'Scalp Negative Ion Oxygen Infusion Calming',
      'Antibacterial soothing comb',
      'Microcurrent phototherapy for follicle regeneration',
      'Meridian heat therapy for shoulder & neck relief',
      'Dyson dryer blow-dry',
    ],
  ),
  ServiceItem(
    title: 'ALGOMASK+ Customized Clinical Facial',
    price: '\$169 / 60mins',
    imageAsset: 'assets/images/image_8.jpg',
    summary: 'Instant radiance and long-lasting hydration',
    points: <String>[
      'Moisturizes and tones the skin, reducing visible redness',
      'Provides instant radiance',
      'Maintains hydration levels',
      'Hydrates, soothes, and revitalizes',
      'Recommended Frequency: 3-6 weekly intensive, then every 4 weeks',
    ],
  ),
  ServiceItem(
    title: 'Oxygenating Professional Treatment',
    price: '\$199 / 70mins',
    imageAsset: 'assets/images/image_9.jpg',
    summary: '5-step oxygen complex treatment',
    points: <String>[
      'Minimizes breakouts and calms redness',
      'Provides mattifying effect for balanced skin',
      'Restores luminosity and youthful glow',
      'Color-free, paraben-free, alcohol-free, fragrance-free',
      'Recommended Frequency: every 4 weeks',
    ],
  ),
  ServiceItem(
    title: 'HYDROLIFTING Professional Treatment',
    price: '\$199 / 70mins',
    imageAsset: 'assets/images/image_10.jpg',
    summary: 'Uplifting anti-sagging treatment',
    points: <String>[
      'Improves visible toning of face and neck',
      'Provides deep hydration',
      'Enhances radiance with age-defying results',
      'Recommended Frequency: every 3 weeks',
    ],
  ),
  ServiceItem(
    title: 'Collagen-90 Clinical Treatment',
    price: '\$229 / 80mins',
    imageAsset: 'assets/images/image_11.jpg',
    summary: 'Prestigious rejuvenating collagen treatment',
    points: <String>[
      'Minimizes fine lines and wrinkles',
      'Rejuvenates and tightens for youthful skin',
      'Deep hydration for plump radiant complexion',
      'Recommended Frequency: every 4 weeks',
    ],
  ),
  ServiceItem(
    title: 'Hand Mask',
    price: '\$20 Add-On',
    imageAsset: 'assets/images/image_13.jpg',
    summary: 'Add-on hand care',
    points: <String>[
      'Deep hydration for dry tired hands',
      'Leaves skin silky-soft and rejuvenated',
    ],
  ),
  ServiceItem(
    title: 'Foot Mask',
    price: '\$20 Add-On',
    imageAsset: 'assets/images/image_14.jpg',
    summary: 'Add-on foot care',
    points: <String>[
      'Deep hydration',
      'Heel crack repair',
      'Soothing and callus softening',
    ],
  ),
  ServiceItem(
    title: 'Foot Soak Therapy',
    price: '\$30 Add-On',
    imageAsset: 'assets/images/image_12.jpg',
    summary: 'Salt + Milk or Salt + Fruit soak',
    points: <String>[
      'Softens and smooths rough skin',
      'Hydrates and brightens',
      'Relieves fatigue and improves circulation',
      'Antibacterial and deodorizing',
      'Refreshing aromatherapy effect',
    ],
  ),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _TopBanner(
            title: 'Full Menu',
            subtitle: 'All services from web are transferred here.',
          ),
          ...kAllServices.map((ServiceItem s) => _ServiceCard(item: s)),
          const _SectionCard(
            title: 'Book Now',
            body: kBookNowUrl,
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
      imageAsset: 'assets/images/membership.jpg',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _TopBanner(
            title: 'Membership',
            subtitle: 'Join our exclusive membership and enjoy bonus credits.',
          ),
          _SectionCard(
            title: 'Overview',
            body:
                'Enhance your experience with extra value! Our membership program rewards you with additional credits every time you deposit.',
          ),
          _SectionCard(
            title: 'Membership Tiers',
            body:
                'Deposit \$1000, Get \$350 Free (maximum bonus)\nDeposit \$800, Get \$200 Free\nDeposit \$500, Get \$100 Free\nDeposit \$300, Get \$50 Free',
          ),
          _SectionCard(
            title: 'Member Benefits',
            body:
                'Retail Product Discounts: 15% off scalp care products and oils.\nBirthday Gift: special gift during birthday month.\nReferral Program: discounts or free services for referrals.\nExclusive Events: wellness workshops, previews, spa parties.',
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
          _SectionCard(
            title: 'Book / Redeem',
            body: kBookNowUrl,
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
          _SectionCard(title: 'Open Hours', body: 'MON - SAT : 10AM - 7PM\nSUN : 10AM - 5PM'),
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
                Text(item.summary, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...item.points.map((String p) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $p'),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageBackground extends StatelessWidget {
  const _PageBackground({required this.child, this.imageAsset});
  final Widget child;
  final String? imageAsset;

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromRGBO(248, 245, 240, 0.78),
              Color.fromRGBO(248, 245, 240, 0.94),
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
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 19)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFFE6D7BF), height: 1.3)),
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
    final Color color = selected ? kGold : Colors.white70;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

