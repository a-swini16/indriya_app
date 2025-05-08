import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/course_card.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _categories = [
    'All',
    'Development',
    'Data Science',
    'Cloud Computing',
  ];

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

  // Add a method to handle search
  void _handleSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });

    // Optional: Dismiss keyboard after search
    FocusScope.of(context).unfocus();

    // Optional: Scroll to the course grid to show results
    _scrollToResults();
  }

  // Method to scroll to results
  void _scrollToResults() {
    // Add a delay to ensure the widget tree is updated
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        ResponsiveHelper.isMobile(context) ? 400 : 350,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
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
            _buildHeader(),
            _buildFilters(),
            _buildCourseGrid(),
           
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
                      'assets/images/logo.png',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.grey[50],
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            children: [
              const SectionTitle(
                title: 'Our Comprehensive Courses',
                subtitle:
                    'Choose from our wide range of industry-relevant courses',
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusLarge),
                  boxShadow: AppTheme.defaultShadow,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for courses...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) =>
                            _handleSearch(), // Also trigger search on Enter key
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _handleSearch, // Use the new method here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                      child: const Text('Search'),
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

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Course Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                        checkmarkColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimaryColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  Widget _buildCourseGrid() {
    final filteredCourses = _getCourses();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ResponsiveHelper.contentContainer(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _searchQuery.isNotEmpty
                    ? 'Search Results for "${_searchQuery}"'
                    : '${_selectedCategory == 'All' ? 'All Courses' : '$_selectedCategory Courses'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Found ${filteredCourses.length} courses for you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              filteredCourses.isEmpty
                  ? _buildNoCoursesFound()
                  : GridView.count(
                      crossAxisCount:
                          ResponsiveHelper.getResponsiveGridCount(context),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 30,
                      childAspectRatio: 0.85,
                      children: filteredCourses.map((course) {
                        // Check if this is the AI/ML course
                        final isAiMlCourse = course['title'] ==
                                'Machine Learning' ||
                            course['title'] ==
                                'Artificial Intelligence & Machine Learning';
                        final isWebDevCourse =
                            course['title'] == 'Full Stack Web Development';
                        final isAwsCourse =
                            course['title'] == 'AWS Cloud Computing';
                        final isAllprograming =
                            course['title'] == 'All Programming Languages';
                        final isDsa = course['title'] == 'Data Structures & Algorithms';

                        return CourseCard(
                          title: course['title']!,
                          description: course['description']!,
                          icon: course['icon']! as IconData,
                          color: course['color']! as Color,
                          duration: course['duration']!,
                          level: course['level']!,
                          isPopular: course['isPopular'] as bool? ?? false,
                          onTap: () {
                            // Navigate to AI/ML course detail page if it's the AI/ML course
                            if (isAiMlCourse) {
                              Navigator.pushNamed(context, '/ai-ml-detail');
                            } else if (isWebDevCourse) {
                              Navigator.pushNamed(context, '/web-dev');
                            } else if (isAwsCourse) {
                              Navigator.pushNamed(context, '/cloud-dev');
                            } else if (isAllprograming) {
                              Navigator.pushNamed(context, '/all-programming');
                            }else if (isDsa){
                              Navigator.pushNamed(context, '/dsa-page');
                            }
                             else {
                              // For other courses, use the default course detail page
                              Navigator.pushNamed(context, '/course-detail');
                            }
                          },
                        );
                      }).toList(),
                    ),
              if (filteredCourses.isNotEmpty) ...[
                const SizedBox(height: 40),
                Center(
                  child: CustomButton(
                    label: 'Load More Courses',
                    onPressed: () {},
                    type: ButtonType.outline,
                    icon: Icons.refresh,
                  ),
                ),
              ],
            ],
          ),
          maxWidth: 1200,
        ),
      ),
    );
  }

  // Add a widget for when no courses match the search criteria
  Widget _buildNoCoursesFound() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No courses found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty
                ? 'No results match "$_searchQuery". Try different keywords or remove filters.'
                : 'No courses available in this category right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            label: 'Clear Search',
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _selectedCategory = 'All';
              });
            },
            type: ButtonType.outline,
            icon: Icons.clear,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getCourses() {
    // Added a new course for AI/ML with more descriptive title and content
    return [
      {
        'title': 'Flutter App Development',
        'description':
            'Master cross-platform app development with Flutter framework',
        'icon': Icons.phone_android,
        'color': Colors.blue,
        'duration': '12 Weeks',
        'level': 'Beginner to Advanced',
        'isPopular': true,
        'category': 'Development',
      },
      {
        'title': 'Full Stack Web Development',
        'description':
            'Learn frontend and backend development with modern technologies',
        'icon': Icons.web,
        'color': Colors.green,
        'duration': '16 Weeks',
        'level': 'Beginner to Advanced',
        'category': 'Development',
      },
      {
        'title': 'All Programming Languages',
        'description': 'From basics to advanced Python programming concepts',
        'icon': Icons.code,
        'color': Colors.amber,
        'duration': '8 Weeks',
        'level': 'Beginner to Intermediate',
        'category': 'Development',
      },
      {
        'title':
            'Artificial Intelligence & Machine Learning', // Changed title to match the course detail page
        'description':
            'Master AI and ML concepts from basics to advanced applications',
        'icon': Icons.psychology,
        'color': Colors.purple,
        'duration': '16 Weeks', // Updated to match the course detail page
        'level':
            'Beginner to Advanced', // Updated to match the course detail page
        'isPopular': true, // Added isPopular flag
        'category': 'Data Science',
      },
      {
        'title': 'AWS Cloud Computing',
        'description': 'Master cloud infrastructure with Amazon Web Services',
        'icon': Icons.cloud,
        'color': Colors.teal,
        'duration': '10 Weeks',
        'level': 'Intermediate',
        'category': 'Cloud Computing',
      },
      {
        'title': 'Data Structures & Algorithms',
        'description':
            'Essential computer science concepts for coding interviews',
        'icon': Icons.analytics,
        'color': Colors.red,
        'duration': '8 Weeks',
        'level': 'Intermediate',
        'category': 'Development',
      },
    ].where((course) {
      final matchesCategory =
          _selectedCategory == 'All' || course['category'] == _selectedCategory;
      final title = course['title'] as String;
      final description = course['description'] as String;

      final matchesSearch = _searchQuery.isEmpty ||
          title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
