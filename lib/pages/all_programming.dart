import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:indriya_academy/widgets/LanguageCard.dart';
import 'package:indriya_academy/widgets/app_bar.dart';
import 'package:indriya_academy/widgets/footer.dart';
import 'package:indriya_academy/widgets/section_title.dart';
import 'package:indriya_academy/widgets/custom_button.dart';


class ProgrammingLanguagesPage extends StatefulWidget {
  const ProgrammingLanguagesPage({Key? key}) : super(key: key);

  @override
  State<ProgrammingLanguagesPage> createState() => _ProgrammingLanguagesPageState();
}

class _ProgrammingLanguagesPageState extends State<ProgrammingLanguagesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _categories = [
    'All',
    'Frontend',
    'Backend',
    'Mobile',
    'Data Science',
    'Systems',
    'Scripting'
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

  void _handleSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    FocusScope.of(context).unfocus();
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
            _buildLanguagesGrid(),
            
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
              _buildDrawerItem('Languages', Icons.code, () {
                Navigator.pushNamed(context, '/languages');
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
                    title: 'Programming Languages',
                    subtitle: 'Master the languages that power modern technology',
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
                              hintText: 'Search for languages...',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _handleSearch(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _handleSearch,
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
                    'Language Categories',
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

      Widget _buildLanguagesGrid() {
        final filteredLanguages = _getLanguages();

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
                        : '${_selectedCategory == 'All' ? 'All Languages' : '$_selectedCategory Languages'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Found ${filteredLanguages.length} languages',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  filteredLanguages.isEmpty
                      ? _buildNoLanguagesFound()
                      : GridView.count(
                          crossAxisCount:
                              ResponsiveHelper.getResponsiveGridCount(context),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 30,
                          childAspectRatio: ResponsiveHelper.isMobile(context)
                              ? 0.9
                              : 0.85,
                          children: filteredLanguages.map((language) {
                            return LanguageCard(
                              name: language['name']!,
                              description: language['description']!,
                              icon: language['icon']! as IconData,
                              color: language['color']! as Color,
                              year: language['year']!,
                              paradigm: language['paradigm']!,
                              isPopular: language['isPopular'] as bool? ?? false,
                              onTap: () {
                                // Navigate to language detail page
                                Navigator.pushNamed(
                                  context,
                                  '/language-detail',
                                  arguments: language,
                                );
                              },
                            );
                          }).toList(),
                        ),
                  if (filteredLanguages.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    Center(
                      child: CustomButton(
                        label: 'View More Languages',
                        onPressed: () {},
                        type: ButtonType.outline,
                        icon: Icons.more_horiz,
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

      Widget _buildNoLanguagesFound() {
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
                'No languages found',
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
                    : 'No languages available in this category right now.',
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

      
      

      

      List<Map<String, dynamic>> _getLanguages() {
        return [
          {
            'name': 'JavaScript',
            'description':
                'The scripting language for Web pages, now used for full-stack development',
            'icon': Icons.code,
            'color': Colors.amber,
            'year': '1995',
            'paradigm': 'Multi-paradigm',
            'category': ['Frontend', 'Backend'],
            'isPopular': true,
          },
          {
            'name': 'Python',
            'description':
                'High-level general-purpose language known for its simplicity and readability',
            'icon': Icons.terminal,
            'color': Colors.blue,
            'year': '1991',
            'paradigm': 'Multi-paradigm',
            'category': ['Backend', 'Data Science', 'Scripting'],
            'isPopular': true,
          },
          {
            'name': 'Java',
            'description':
                'Object-oriented language designed to have few implementation dependencies',
            'icon': Icons.coffee,
            'color': Colors.red,
            'year': '1995',
            'paradigm': 'Object-oriented',
            'category': ['Backend', 'Mobile', 'Systems'],
            'isPopular': true,
          },
          {
            'name': 'C++',
            'description':
                'Extension of C with object-oriented features, used for system/application software',
            'icon': Icons.memory,
            'color': Colors.indigo,
            'year': '1985',
            'paradigm': 'Multi-paradigm',
            'category': ['Systems'],
            'isPopular': false,
          },
          {
            'name': 'Swift',
            'description':
                'Powerful and intuitive language for macOS, iOS, watchOS, and tvOS',
            'icon': Icons.phone_iphone,
            'color': Colors.orange,
            'year': '2014',
            'paradigm': 'Multi-paradigm',
            'category': ['Mobile'],
            'isPopular': true,
          },
          {
            'name': 'Kotlin',
            'description':
                'Modern programming language that makes developers happier',
            'icon': Icons.android,
            'color': Colors.purple,
            'year': '2011',
            'paradigm': 'Multi-paradigm',
            'category': ['Mobile', 'Backend'],
            'isPopular': true,
          },
          
          
         
        ].where((language) {
          final matchesCategory = _selectedCategory == 'All' ||
              (language['category'] as List).contains(_selectedCategory);
          final name = language['name'] as String;
          final description = language['description'] as String;

          final matchesSearch = _searchQuery.isEmpty ||
              name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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