import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 10 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 10 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ResponsiveHelper.isMobile(context)
          ? _buildDrawer()
          : null,
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildMissionSection(context),
            _buildTeamSection(context),
            _buildStatsSection(context),
            _buildPartnersSection(context),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/indriya_logo.png',
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Indriya Academy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Building Future Tech Leaders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem('Home', Icons.home, () {
            Navigator.pushNamed(context, '/');
          }),
          _buildDrawerItem('Courses', Icons.school, () {
            Navigator.pushNamed(context, '/courses');
          }),
          _buildDrawerItem('About Us', Icons.info, () {
            Navigator.pushNamed(context, '/about');
          }),
          
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomButton(
              label: 'Contanct us',
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
              },
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/hero.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'About Indriya Academy',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 4,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          ResponsiveHelper.isMobile(context)
              ? Column(
                  children: [
                    _buildSectionHeader('Our Mission'),
                    const SizedBox(height: 40),
                    _buildMissionContent(context),
                    const SizedBox(height: 40),
                    _buildMissionImage(),
                  ],
                )
              : Column(
                  children: [
                    _buildSectionHeader('Our Mission'),
                    const SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildMissionContent(context)),
                        const SizedBox(width: 40),
                        _buildMissionImage(),
                      ],
                    ),
                  ],
                ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SectionTitle(
      title: title,
      subtitle: '',
    );
  }

  Widget _buildMissionContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Empowering the Next Generation of Tech Professionals',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
        ),
        const SizedBox(height: 20),
        const Text(
          'At Indriya Academy, we believe that quality education in emerging technologies should be accessible to everyone. Our mission is to bridge the gap between traditional education and industry requirements by providing practical, job-oriented training programs.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Founded in 2020, we have trained over 5,000 students who are now working at top tech companies across India and abroad. Our courses are designed in collaboration with industry experts to ensure they remain relevant and up-to-date.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 30),
        
      ],
    );
  }

  Widget _buildMissionImage() {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? double.infinity : 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/indriya.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              _buildSectionHeader('Meet Our Team'),
              const SizedBox(height: 40),
              _buildTeamGrid(),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildTeamGrid() {
    final crossAxisCount = ResponsiveHelper.isDesktop(context)
        ? 3
        : ResponsiveHelper.isTablet(context)
            ? 2
            : 1;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 30,
      crossAxisSpacing: 30,
      childAspectRatio: ResponsiveHelper.isMobile(context) ? 1 : 0.8,
      children: const [
        TeamMemberCard(
          name: 'Rakesh Dhupar',
          role: 'Founder & CEO',
          image: 'assets/images/team_c.jpeg',
        ),
        TeamMemberCard(
          name: 'Sandeep Kumar',
          role: 'Head of Academics',
          image: 'assets/images/team_h.jpeg',
        ),
        TeamMemberCard(
          name: 'Ashwini Prasad Rout',
          role: 'Senior Instructor',
          image: 'assets/images/asw_pic.jpeg',
        ),
     
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              Text(
                'Our Impact in Numbers',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 60),
              ResponsiveHelper.isMobile(context)
                  ? Column(
                      children: [
                        _buildStatItem('5000+', 'Students Trained'),
                        const SizedBox(height: 40),
                        _buildStatItem('95%', 'Placement Rate'),
                        const SizedBox(height: 40),
                        _buildStatItem('50+', 'Industry Partners'),
                        const SizedBox(height: 40),
                        _buildStatItem('100+', 'Courses Offered'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('5000+', 'Students Trained'),
                        _buildStatItem('95%', 'Placement Rate'),
                        _buildStatItem('50+', 'Industry Partners'),
                        _buildStatItem('100+', 'Courses Offered'),
                      ],
                    ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPartnersSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              _buildSectionHeader('Our Partners & Certifications'),
              const SizedBox(height: 40),
              _buildPartnersGrid(),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildPartnersGrid() {
    final crossAxisCount = ResponsiveHelper.isDesktop(context)
        ? 3
        : ResponsiveHelper.isTablet(context)
            ? 2
            : 1;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildPartnerLogo('assets/images/skill_india_logo.png'),
        _buildPartnerLogo('assets/images/govt_india_logo.png'),
        _buildPartnerLogo('assets/images/nsdc_logo.png'),
      ],
    );
  }

  Widget _buildPartnerLogo(String imagePath) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Image.asset(imagePath),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  const TeamMemberCard({
    Key? key,
    required this.name,
    required this.role,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            role,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppTheme.primaryColor),
        onPressed: () {},
        padding: EdgeInsets.zero,
      ),
    );
  }
}
