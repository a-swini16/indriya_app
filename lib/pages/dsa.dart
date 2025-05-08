import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';
import 'package:indriya_academy/services/api_service.dart';

class DataStructuresCoursePage extends StatefulWidget {
  const DataStructuresCoursePage({Key? key}) : super(key: key);

  @override
  State<DataStructuresCoursePage> createState() => _DataStructuresCoursePageState();
}

class _DataStructuresCoursePageState extends State<DataStructuresCoursePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> _expandedModules = [false, false, false, false, false];
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
      color: Colors.blueGrey[50],
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
            'FOUNDATIONAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Data Structures & Algorithms Masterclass',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Master fundamental computer science concepts essential for coding interviews and software development. Learn to implement and analyze efficient algorithms and data structures.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            _buildInfoChip(Icons.schedule, '8 Weeks'),
            const SizedBox(width: 15),
            _buildInfoChip(Icons.star, 'Beginner to Intermediate'),
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
              '(428 ratings)',
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
              '3,200 students enrolled',
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
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/DSA.png',
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
          'This comprehensive Data Structures and Algorithms course is designed to take you from basic concepts to advanced implementations. You\'ll learn how to analyze algorithm efficiency and solve complex problems using appropriate data structures.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'The course covers essential data structures like arrays, linked lists, trees, graphs, and hash tables, along with sorting and searching algorithms. By the end, you\'ll be able to implement these concepts in multiple programming languages and solve real-world problems efficiently.',
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
        GridView.count(
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: ResponsiveHelper.isMobile(context) ? 4 : 3,
          children: [
            _buildFeatureItem(
              Icons.account_tree,
              'Data Structures',
              'Master arrays, linked lists, stacks, queues, trees, graphs, and hash tables',
            ),
            _buildFeatureItem(
              Icons.timeline,
              'Algorithm Analysis',
              'Learn Big-O notation and analyze time/space complexity of algorithms',
            ),
            _buildFeatureItem(
              Icons.sort,
              'Sorting Algorithms',
              'Implement and compare bubble, merge, quick, heap, and radix sorts',
            ),
            _buildFeatureItem(
              Icons.search,
              'Search Techniques',
              'Master binary search, depth-first search, breadth-first search, and more',
            ),
          ],
        ),
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
      'Basic programming knowledge in any language (Python, Java, C++ recommended)',
      'Understanding of variables, loops, and functions',
      'Computer with development environment set up',
      'Passion for problem-solving and logical thinking',
      'No advanced math required (we cover what you need)'
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
            '₹9,999',
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
              '35% off - Limited time offer',
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
            '60+ hours of video lectures',
          ),
          _buildCourseIncludesItem(
            Icons.article,
            '150+ coding exercises',
          ),
          _buildCourseIncludesItem(
            Icons.code,
            '10 real-world projects',
          ),
          _buildCourseIncludesItem(
            Icons.quiz,
            '5 practice coding tests',
          ),
          _buildCourseIncludesItem(
            Icons.verified_user,
            'Certificate of completion',
          ),
          _buildCourseIncludesItem(
            Icons.schedule,
            'Lifetime access',
          ),
          _buildCourseIncludesItem(
            Icons.forum,
            'Dedicated Q&A support',
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Not sure? Try a free preview lesson',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'or contact us for more details',
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
                subtitle: 'Structured learning path from fundamentals to advanced concepts',
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
        'title': 'Module 1: Introduction & Complexity Analysis',
        'lessons': [
          'Course Overview & Expectations',
          'Time and Space Complexity',
          'Big-O Notation',
          'Recursion Fundamentals',
          'Problem Solving Approaches',
        ],
        'duration': '10 hours',
      },
      {
        'title': 'Module 2: Linear Data Structures',
        'lessons': [
          'Arrays & ArrayLists',
          'Linked Lists (Singly, Doubly, Circular)',
          'Stacks & Queues',
          'Hash Tables & Dictionaries',
          'Applications in Real Problems',
        ],
        'duration': '14 hours',
      },
      {
        'title': 'Module 3: Sorting & Searching Algorithms',
        'lessons': [
          'Bubble, Selection, Insertion Sort',
          'Merge Sort & Quick Sort',
          'Heap Sort & Radix Sort',
          'Binary Search & Variations',
          'Comparison of Sorting Algorithms',
        ],
        'duration': '12 hours',
      },
      {
        'title': 'Module 4: Trees & Graphs',
        'lessons': [
          'Binary Trees & Binary Search Trees',
          'Tree Traversals (Inorder, Preorder, Postorder)',
          'Balanced Trees (AVL, Red-Black)',
          'Graph Representations & Algorithms',
          'Dijkstra\'s & A* Algorithms',
        ],
        'duration': '16 hours',
      },
      {
        'title': 'Module 5: Advanced Topics & Interview Prep',
        'lessons': [
          'Dynamic Programming',
          'Greedy Algorithms',
          'Backtracking',
          'System Design Basics',
          'Mock Coding Interviews',
        ],
        'duration': '18 hours',
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
                subtitle: 'Learn from an industry expert with real-world experience',
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
          'Senior Software Engineer & Algorithm Specialist',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Ashwini has over 12 years of experience in software development at companies like Google, Amazon, and Microsoft. He holds Computer Science with specialization in Algorithm Design and has conducted research in computational complexity.',
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'As a former hiring manager at top tech companies, he brings unique insights into what interviewers look for in coding interviews. He has helped over 5,000 students land jobs at FAANG companies through his teaching methodology.',
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
                    'Priya Patel',
                    'Software Engineer at Amazon',
                    'This course completely changed how I approach coding problems. The systematic way Dr. Sharma teaches problem-solving helped me crack 3 offers from top tech companies. The interview preparation modules are worth the price alone!',
                  ),
                  _buildTestimonialCard(
                    'Rahul Verma',
                    'Computer Science Student',
                    'As a student with no prior DSA knowledge, this course was perfect. The concepts are explained clearly with multiple implementations. The coding exercises helped me build confidence for my campus placements.',
                  ),
                  _buildTestimonialCard(
                    'Neha Gupta',
                    'Frontend Developer',
                    'I wanted to transition to full-stack roles but lacked DSA knowledge. This course filled all my gaps with practical examples. The real-world project implementations made abstract concepts click for me.',
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
      color: Colors.grey[50],
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
        'question': 'Which programming languages are used in this course?',
        'answer':
            'The concepts are taught in a language-agnostic way, with implementations shown in Python, Java, and C++. You can follow along with any language you\'re comfortable with. All exercises provide starter code in multiple languages.',
      },
      {
        'question': 'Is this course suitable for complete beginners?',
        'answer':
            'Yes! The course starts with fundamentals and gradually builds up to advanced topics. We recommend having basic programming knowledge (variables, loops, functions) but no prior data structures experience is required.',
      },
      {
        'question': 'How does this course help with coding interviews?',
        'answer':
            'The course includes dedicated modules on interview preparation, with strategies for solving common interview problems, time management, and communication techniques. You\'ll also get access to mock interviews and company-specific question banks.',
      },
      {
        'question': 'What if I get stuck on exercises or concepts?',
        'answer':
            'We provide multiple support channels including a dedicated Q&A forum where instructors respond within 24 hours, weekly live doubt-clearing sessions, and a community of learners to collaborate with.',
      },
      {
        'question': 'How long do I have access to the course materials?',
        'answer':
            'You get lifetime access to all course materials, including future updates. We regularly refresh content to keep up with industry trends and interview patterns.',
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

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}