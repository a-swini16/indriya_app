// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/services/api_service.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';
import 'package:indriya_academy/widgets/course_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form state variables
  final _ctaFormKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _selectedCourse = 'flutter';
  bool _isSubmitting = false;
  bool _showSuccess = false;

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

  Future<void> _submitForm() async {
    if (_ctaFormKey.currentState!.validate()) {
      _ctaFormKey.currentState!.save();
      
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Get the course title based on the selected value
        String courseTitle;
        switch (_selectedCourse) {
          case 'flutter':
            courseTitle = 'Flutter App Development';
            break;
          case 'web':
            courseTitle = 'Full Stack Web Development';
            break;
          case 'python':
            courseTitle = 'Python Programming';
            break;
          case 'ml':
            courseTitle = 'Machine Learning';
            break;
          default:
            courseTitle = 'Flutter App Development';
        }

        // Call the API service
        final success = await ApiService.submitEnrollment(
          courseTitle,
          _fullName,
          _email,
          _phone,
        );

        setState(() {
          _isSubmitting = false;
          if (success) {
            _showSuccess = true;
          }
        });

        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit form. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ResponsiveHelper.isMobile(context) ? _buildDrawer() : null,
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
            _buildHeroSection(),
            _buildStatsSection(),
            _buildCertificationSection(),
            _buildCoursesSection(),
            _buildTestimonialsSection(),
            _buildCtaSection(),
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
          _buildDrawerItem('Contact', Icons.contact_mail, () {
            Navigator.pushNamed(context, '/contact');
          }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomButton(
              label: 'contact us',
              onPressed: () {Navigator.pushNamed(context, '/contact');},
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

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 22, 3, 145),
            Colors.blue.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 80,
                  horizontal: 20,
                ),
                child: ResponsiveHelper.isMobile(context)
                    ? Column(
                        children: [
                          _buildHeroContent(),
                          const SizedBox(height: 40),
                          _buildHeroImage(),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildHeroContent(),
                          ),
                          Expanded(
                            child: _buildHeroImage(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ResponsiveHelper.isMobile(context) ? null : 500,
          child: const Text(
            'Transform Your Career with Industry-Ready Skills',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: ResponsiveHelper.isMobile(context) ? null : 450,
          child: const Text(
            'Join Indriya Academy for hands-on training and gain expertise in the most in-demand tech skills. Learn from industry experts and get placed in top companies.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            CustomButton(
              label: 'Explore Courses',
              onPressed: () {
                Navigator.pushNamed(context, '/courses');
              },
              type: ButtonType.primary,
              icon: Icons.school,
            ),
            const SizedBox(width: 15),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 520,
            height: 420,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.withOpacity(0.03),
                  Colors.deepOrange.withOpacity(0.05),
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.03,
            child: Container(
              width: 490,
              height: 390,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Container(
            width: 460,
            height: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(-10, -10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/coding_illustration.png',
                    width: 460,
                    height: 360,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildStatItem('5000+', 'Students Trained'),
              _buildStatItem('95%', 'Placement Rate'),
              _buildStatItem('50+', 'Industry Partners'),
              _buildStatItem('100+', 'Courses Offered'),
            ],
          ),
          maxWidth: 1200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      width: ResponsiveHelper.isMobile(context)
          ? ResponsiveHelper.getWidth(context, percentage: 0.4)
          : 200,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Industry-Recognized Certifications',
                subtitle: 'Our courses come with certifications that are valued by leading employers',
              ),
              const SizedBox(height: 60),
              ResponsiveHelper.isMobile(context)
                  ? Column(
                      children: [
                        _buildCertificationContent(),
                        const SizedBox(height: 40),
                        _buildCertificationImage(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildCertificationContent(),
                        ),
                        Expanded(
                          child: _buildCertificationImage(),
                        ),
                      ],
                    ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildCertificationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Boost Your Resume With Validated Skills',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Our certifications are designed in collaboration with industry experts and recognized by top employers. They validate your skills and help you stand out in the job market.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        _buildCertificationFeature(
          Icons.verified,
          'Industry-Recognized',
          'Certifications valued by recruiters',
        ),
        _buildCertificationFeature(
          Icons.badge,
          'Digital Badges',
          'Share your achievements on LinkedIn',
        ),
        _buildCertificationFeature(
          Icons.history_edu,
          'Lifetime Validity',
          'No expiration on your certifications',
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildCertificationFeature(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationImage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 500,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 460,
              maxHeight: 310,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              'assets/images/skill_india_logo.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Official Certification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Our Featured Courses',
                subtitle: 'Explore our most popular and in-demand courses',
              ),
              const SizedBox(height: 60),
              GridView.count(
                crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                childAspectRatio: 0.85,
                children: [
                  CourseCard(
                    title: 'Flutter App Development',
                    description: 'Master cross-platform app development with Flutter framework',
                    icon: Icons.phone_android,
                    color: Colors.blue,
                    duration: '12 Weeks',
                    level: 'Beginner to Advanced',
                    isPopular: true,
                    onTap: () {
                      Navigator.pushNamed(context, '/course-detail');
                    },
                  ),
                  CourseCard(
                    title: 'Full Stack Web Development',
                    description: 'Learn frontend and backend development with modern technologies',
                    icon: Icons.web,
                    color: Colors.green,
                    duration: '16 Weeks',
                    level: 'Beginner to Advanced',
                    onTap: () {
                      Navigator.pushNamed(context, '/web-dev');
                    },
                  ),
                  CourseCard(
                    title: 'All Programming Language',
                    description: 'From basics to advanced Python programming concepts',
                    icon: Icons.code,
                    color: Colors.amber,
                    duration: '8 Weeks',
                    level: 'Beginner to Intermediate',
                    onTap: () {
                      Navigator.pushNamed(context, '/all-programming');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
              CustomButton(
                label: 'View All Courses',
                onPressed: () {
                  Navigator.pushNamed(context, '/courses');
                },
                type: ButtonType.outline,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'What Our Students Say',
                subtitle: 'Hear from our successful graduates who transformed their careers',
              ),
              const SizedBox(height: 60),
              _buildTestimonialSlider(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, size: 12, color: AppTheme.primaryColor),
                  Icon(Icons.circle, size: 12, color: Colors.grey[300]),
                  Icon(Icons.circle, size: 12, color: Colors.grey[300]),
                ],
              ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildTestimonialSlider() {
    return ResponsiveHelper.isMobile(context)
        ? _buildTestimonialCard()
        : Row(
            children: [
              Expanded(child: _buildTestimonialCard()),
              const SizedBox(width: 30),
              Expanded(child: _buildTestimonialCard(isAlt: true)),
            ],
          );
  }

  Widget _buildTestimonialCard({bool isAlt = false}) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.format_quote,
                color: AppTheme.primaryColor,
                size: 40,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  isAlt
                      ? 'The curriculum was comprehensive and well-structured. The practical projects helped me build a strong portfolio, which was crucial in landing my dream job.'
                      : 'This course transformed my career. After completing it, I got a job as a Flutter developer with a 50% salary increase. The instructor explains complex concepts in a simple way.',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAlt ? 'Amit Kumar' : 'Priya Patel',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isAlt ? 'Web Developer at CodeStack' : 'Flutter Developer at TechCorp',
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection() {
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
              const Text(
                'Ready to Start Your Learning Journey?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Join thousands of students who have transformed their careers with our courses',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(30),
                width: ResponsiveHelper.isMobile(context) ? double.infinity : 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _showSuccess
                    ? _buildSuccessMessage()
                    : Form(
                        key: _ctaFormKey,
                        child: Column(
                          children: [
                            const Text(
                              'Sign Up for a Free Demo Class',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (value) => _fullName = value ?? '',
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (value) => _email = value ?? '',
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                              onSaved: (value) => _phone = value ?? '',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Course Interested In',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.school),
                              ),
                              value: _selectedCourse,
                              items: const [
                                DropdownMenuItem(
                                  value: 'flutter',
                                  child: Text('Flutter App Development'),
                                ),
                                DropdownMenuItem(
                                  value: 'web',
                                  child: Text('Full Stack Web Development'),
                                ),
                                DropdownMenuItem(
                                  value: 'All prgramming',
                                  child: Text('All Programming'),
                                ),
                                DropdownMenuItem(
                                  value: 'ml',
                                  child: Text('Machine Learning'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCourse = value;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a course';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomButton(
                              label: 'Book My Free Demo',
                              onPressed: _submitForm,
                              type: ButtonType.primary,
                              isFullWidth: true,
                              icon: Icons.calendar_today,
                              isLoading: _isSubmitting,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        const SizedBox(height: 20),
        const Text(
          'Thank You for Your Interest!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Our team will contact you shortly to schedule your free demo class.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 25),
        CustomButton(
          label: 'Explore More Courses',
          onPressed: () {
            Navigator.pushNamed(context, '/courses');
          },
          type: ButtonType.outline,
          icon: Icons.school,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}