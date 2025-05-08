import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    Key? key,
    this.isScrolled = false,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppTheme.shortAnimationDuration,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: isScrolled ? AppTheme.defaultShadow : [],
      ),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1200,
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      // Improved logo implementation
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/indriya_logo.png',
                          height: 48,
                          width: 48,
                          fit: BoxFit.contain, // Changed to cover to ensure the logo fills the area
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Indriya Academy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!ResponsiveHelper.isMobile(context))
                  Row(
                    children: [
                      _buildNavItem(context, 'Home', () {
                        Navigator.pushNamed(context, '/');
                      }),
                      _buildNavItem(context, 'Courses', () {
                        Navigator.pushNamed(context, '/courses');
                      }),
                      _buildNavItem(context, 'About', () {
                        Navigator.pushNamed(context, '/about');
                      }),
                    
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Contact Us'),
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: onMenuPressed,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}