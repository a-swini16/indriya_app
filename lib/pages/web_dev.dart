import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';
import 'package:indriya_academy/services/api_service.dart';

class FullStackWebDevCourseDetailPage extends StatefulWidget {
  const FullStackWebDevCourseDetailPage({Key? key}) : super(key: key);

  @override
  State<FullStackWebDevCourseDetailPage> createState() => _FullStackWebDevCourseDetailPageState();
}

class _FullStackWebDevCourseDetailPageState extends State<FullStackWebDevCourseDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> _expandedModules = [false, false, false, false, false, false];
  final _enrollFormKey = GlobalKey<FormState>();
String _enrollFullName = '';
String _enrollEmail = '';
String _enrollPhone = '';
bool _isEnrollSubmitting = false;
bool _showEnrollSuccess = false;

// Add this method to show the enrollment dialog
void _showEnrollDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Enroll in Course'),
            content: _showEnrollSuccess
                ? _buildEnrollSuccessMessage()
                : Form(
                    key: _enrollFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) => _enrollFullName = value ?? '',
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email),
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
                            onSaved: (value) => _enrollEmail = value ?? '',
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
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
                            onSaved: (value) => _enrollPhone = value ?? '',
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
            actions: _showEnrollSuccess
                ? [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showEnrollSuccess = false;
                        });
                      },
                      child: const Text('Close'),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _isEnrollSubmitting
                          ? null
                          : () async {
                              if (_enrollFormKey.currentState!.validate()) {
                                _enrollFormKey.currentState!.save();
                                setState(() {
                                  _isEnrollSubmitting = true;
                                });

                                try {
                                  final success =
                                      await ApiService.submitEnrollment(
                                    'Flutter App Development Masterclass',
                                    _enrollFullName,
                                    _enrollEmail,
                                    _enrollPhone,
                                  );

                                  setState(() {
                                    _isEnrollSubmitting = false;
                                    if (success) {
                                      _showEnrollSuccess = true;
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Failed to submit form. Please try again.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  });
                                } catch (e) {
                                  setState(() {
                                    _isEnrollSubmitting = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      child: _isEnrollSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ],
          );
        },
      );
    },
  );
}

Widget _buildEnrollSuccessMessage() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 60,
      ),
      const SizedBox(height: 20),
      const Text(
        'Enrollment Submitted!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Our team will contact you shortly with payment details and course access.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}

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
            _buildCourseHeader(),
            _buildCourseDetails(),
            _buildCurriculum(),
            _buildInstructorSection(),
            _buildTestimonials(),
            _buildFaqSection(),
            const Footer(),
          ],
        ),
      ),
      floatingActionButton: ResponsiveHelper.isMobile(context)
          ? FloatingActionButton.extended(
              onPressed: _showEnrollDialog,
              label: const Text('Enroll Now'),
              icon: const Icon(Icons.school),
              backgroundColor: AppTheme.primaryColor,
            )
          : null,
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
              label: 'Contact us',
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

  Widget _buildCourseHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.blue[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          ResponsiveHelper.isMobile(context)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseHeaderContent(),
                    const SizedBox(height: 40),
                    _buildCourseHeaderImage(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCourseHeaderContent(),
                    ),
                    const SizedBox(width: 40),
                    _buildCourseHeaderImage(),
                  ],
                ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildCourseHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'BESTSELLER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Full Stack Web Development Bootcamp',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Master both frontend and backend technologies to become a complete web developer. Build responsive websites, dynamic web applications, and RESTful APIs from scratch.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            _buildInfoChip(Icons.schedule, '20 Weeks'),
            const SizedBox(width: 15),
            _buildInfoChip(Icons.star, 'Beginner to Advanced'),
            const SizedBox(width: 15),
            _buildInfoChip(Icons.verified_user, 'Certificate'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 24,
            ),
            SizedBox(width: 5),
            Text(
              '4.8',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Text(
              '(438 ratings)',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            SizedBox(width: 20),
            Icon(
              Icons.people,
              color: AppTheme.secondaryColor,
              size: 24,
            ),
            SizedBox(width: 5),
            Text(
              '2,350 students enrolled',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        if (!ResponsiveHelper.isMobile(context))
          Row(
            children: [
              CustomButton(
                label: 'Enroll Now',
                onPressed: _showEnrollDialog,
                type: ButtonType.primary,
                icon: Icons.school,
              ),
              const SizedBox(width: 15),
            ],
          ),
      ],
    );
  }

  Widget _buildCourseHeaderImage() {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? double.infinity : 400,
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
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/images/web_dev.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          ResponsiveHelper.isMobile(context)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseDetailsContent(),
                    const SizedBox(height: 40),
                    _buildCourseDetailsCard(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCourseDetailsContent(),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 350,
                      child: _buildCourseDetailsCard(),
                    ),
                  ],
                ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildCourseDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About This Course',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'This comprehensive Full Stack Web Development course is designed to equip you with all the skills needed to build complete web applications from scratch. Starting with the fundamentals of web technologies, you\'ll progressively learn to create powerful, responsive, and dynamic websites and applications.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'The course covers frontend technologies like HTML, CSS, JavaScript, and React, as well as backend technologies including Node.js, Express, MongoDB, and more. You\'ll also learn about deployment, testing, version control, and industry best practices. By the end, you\'ll have built multiple full-stack web applications that showcase your skills to potential employers.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'What You\'ll Learn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        const SizedBox(height: 40),
        const Text(
          'Requirements',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildRequirementList(),
      ],
    );
  }

  

  Widget _buildFeatureItem(IconData icon, String title, String description) {
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementList() {
    final requirements = [
      'Basic computer literacy and familiarity with using computers',
      'No prior programming experience required, but logical thinking skills are helpful',
      'Computer with minimum 8GB RAM (16GB recommended for smoother experience)',
      'Reliable internet connection for accessing course materials and cloud services',
      'Dedication to practice coding regularly and complete the assignments',
    ];

    return Column(
      children: requirements.map((requirement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  requirement,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourseDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '₹13,999',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '₹19,999',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '38% off - Limited time offer',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Enroll Now',
            onPressed: _showEnrollDialog,
            isFullWidth: true,
            type: ButtonType.primary,
            icon: Icons.school,
          ),
          const SizedBox(height: 15),
        
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          const Text(
            'This course includes:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildCourseIncludesItem(
            Icons.videocam,
            '150+ hours of video lectures',
          ),
          _buildCourseIncludesItem(
            Icons.article,
            '40+ articles and tutorials',
          ),
          _buildCourseIncludesItem(
            Icons.code,
            '25 coding exercises and projects',
          ),
          _buildCourseIncludesItem(
            Icons.integration_instructions,
            '5 major full-stack applications',
          ),
          _buildCourseIncludesItem(
            Icons.forum,
            'Access to developer community',
          ),
          _buildCourseIncludesItem(
            Icons.cloud_download,
            'Downloadable source code',
          ),
          _buildCourseIncludesItem(
            Icons.verified_user,
            'Certificate of completion',
          ),
          _buildCourseIncludesItem(
            Icons.schedule,
            'Lifetime access',
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'or contact us for corporate training',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseIncludesItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculum() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Course Curriculum',
                subtitle: 'Comprehensive learning path from fundamentals to advanced web development',
              ),
              const SizedBox(height: 40),
              _buildModules(),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildModules() {
    final modules = [
      {
        'title': 'Module 1: Web Development Fundamentals',
        'lessons': [
          'Introduction to Web Development',
          'HTML5 Essentials',
          'CSS3 Fundamentals',
          'Responsive Web Design',
          'Git & GitHub Basics',
        ],
        'duration': '15 hours',
      },
      {
        'title': 'Module 2: JavaScript Programming',
        'lessons': [
          'JavaScript Fundamentals',
          'DOM Manipulation',
          'ES6+ Features',
          'Asynchronous JavaScript',
          'Error Handling & Debugging',
        ],
        'duration': '20 hours',
      },
      {
        'title': 'Module 3: Frontend Frameworks',
        'lessons': [
          'React.js Fundamentals',
          'Components & Props',
          'State Management',
          'Hooks & Context API',
          'Redux for State Management',
        ],
        'duration': '25 hours',
      },
      {
        'title': 'Module 4: Backend Development',
        'lessons': [
          'Node.js Fundamentals',
          'Express.js Framework',
          'RESTful API Design',
          'Authentication & Authorization',
          'Error Handling & Middleware',
        ],
        'duration': '22 hours',
      },
      {
        'title': 'Module 5: Database Integration',
        'lessons': [
          'Database Design Principles',
          'MongoDB & Mongoose',
          'SQL Databases with MySQL',
          'ORM Tools & Techniques',
          'Database Security Best Practices',
        ],
        'duration': '18 hours',
      },
      {
        'title': 'Module 6: Deployment & Advanced Topics',
        'lessons': [
          'Testing & Test-Driven Development',
          'CI/CD Pipelines',
          'Docker & Containerization',
          'AWS/Cloud Deployment',
          'Performance Optimization Techniques',
        ],
        'duration': '20 hours',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        return _buildModuleCard(modules[index], index);
      },
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedModules[index] = !_expandedModules[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'M${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${(module['lessons'] as List).length} lessons • ${module['duration']}',
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expandedModules[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (_expandedModules[index])
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  const Divider(),
                  ...(module['lessons'] as List).asMap().entries.map((entry) {
                    final int lessonIndex = entry.key;
                    final String lesson = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '${lessonIndex + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              lesson,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.play_circle_outline,
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructorSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Your Instructor',
                subtitle: 'Learn from industry experts with real-world experience',
              ),
              const SizedBox(height: 40),
              ResponsiveHelper.isMobile(context)
                  ? Column(
                      children: [
                        _buildInstructorImage(),
                        const SizedBox(height: 30),
                        _buildInstructorDetails(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInstructorImage(),
                        const SizedBox(width: 40),
                        Expanded(child: _buildInstructorDetails()),
                      ],
                    ),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildInstructorImage() {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? 200 : 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/asw_pic.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

    Widget _buildInstructorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ashwini prasad rout',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Senior Full Stack Developer & Tech Lead',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Ashwini prasad rout brings over 10 years of industry experience as a Full Stack Developer and Engineering Leader at companies like Microsoft, Flipkart, and several successful startups. He has architected and built applications used by millions of users worldwide.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Specializing in modern web technologies, Arjun has mentored dozens of junior developers who have gone on to successful careers. He is passionate about clean code, scalable architecture, and making complex technical concepts accessible to learners at all levels.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            _buildSocialIcon(Icons.language),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.business_center),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.code),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildTestimonials() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Student Testimonials',
                subtitle: 'See what our students say about this course',
              ),
              const SizedBox(height: 40),
              GridView.count(
                crossAxisCount: ResponsiveHelper.isDesktop(context)
                    ? 3
                    : ResponsiveHelper.isTablet(context)
                        ? 2
                        : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? 1
                    : ResponsiveHelper.isTablet(context)
                        ? 1.1
                        : 1.3,
                children: [
                  _buildTestimonialCard(
                    'Rahul Mehta',
                    'Software Engineer',
                    'After trying several online courses, this one truly stands out. The instructor explains complex concepts in an easy-to-understand manner, and the hands-on projects helped me build a solid portfolio. I landed a job as a full-stack developer within two months of completing this course!',
                  ),
                  _buildTestimonialCard(
                    'Aisha Khan',
                    'Career Changer',
                    'Coming from a non-technical background, I was worried about keeping up. But the step-by-step approach and excellent support made the journey smooth. The course gave me the confidence to switch careers, and I\'m now working as a junior web developer at a startup.',
                  ),
                  _buildTestimonialCard(
                    'Vishnu Prakash',
                    'Freelance Developer',
                    'The practical projects in this course prepared me for real-world challenges. I especially appreciated the sections on deployment and optimization. I\'m now running my own freelance business building websites and applications for clients worldwide.',
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

  Widget _buildTestimonialCard(
    String name,
    String designation,
    String testimonial,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      designation,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              Icon(Icons.star, color: Colors.amber, size: 20),
              Icon(Icons.star, color: Colors.amber, size: 20),
              Icon(Icons.star, color: Colors.amber, size: 20),
              Icon(Icons.star, color: Colors.amber, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Text(
              testimonial,
              style: const TextStyle(
                fontSize: 14,
                height: 1.7,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Frequently Asked Questions',
                subtitle: 'Find answers to common questions about this course',
              ),
              const SizedBox(height: 40),
              _buildFaqList(),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    final faqs = [
      {
        'question': 'Do I need programming experience to take this course?',
        'answer':
            'No prior programming experience is required. This course is designed to take you from a complete beginner to an advanced developer. We start with the basics and gradually build up to more complex concepts. However, having some familiarity with computers and logical thinking will be helpful.',
      },
      {
        'question': 'How long will it take to complete the course?',
        'answer':
            'The course is structured to be completed in 20 weeks if you dedicate about 10-15 hours per week. However, since you have lifetime access, you can go at your own pace. Some students who can dedicate more time complete it faster, while others take longer to absorb all the material and work on the projects.',
      },
      {
        'question': 'Will this course help me get a job as a web developer?',
        'answer':
            'Yes, this course is designed with employment outcomes in mind. You ll build multiple portfolio-ready projects that demonstrate your skills to potential employers. We also cover resume preparation, technical interview tips, and job search strategies specific to web development roles. Many of our graduates have successfully transitioned into web development careers.',
      },
      {
        'question': 'Is there any support available if I get stuck?',
        'answer':
            'Absolutely! You ll have access to our student community forum where you can ask questions and interact with other students and teaching assistants. We also hold weekly live Q&A sessions where you can get help with specific issues. Additionally, you can direct message the instructor for more complex problems.',
      },
      {
        'question': 'Are the technologies taught in this course currently in demand?',
        'answer':
            'Yes, we focus on technologies that are widely used in the industry. Our curriculum is regularly updated to reflect current market demands. The MERN stack (MongoDB, Express, React, Node.js) taught in this course is highly sought after by employers, and the additional skills like responsive design, testing, and DevOps practices further enhance your employability.',
      },
      {
        'question': 'Will I get a certificate after completing this course?',
        'answer':
            "Yes, upon successful completion of all course modules and projects, you will receive a certificate of completion. This certificate can be added to your resume and LinkedIn profile. However, the real value of the course is in the skills and portfolio you'll build, which are what employers are most interested in.",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return _buildFaqItem(faqs[index], index);
      },
    );
  }

  Widget _buildFaqItem(Map<String, String> faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        children: [
          Text(
            faq['answer']!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
