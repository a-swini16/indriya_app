// lib/widgets/footer.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/utils/responsive_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.spacingXXLarge,
        horizontal: AppTheme.spacingMedium,
      ),
      child: Center(
        child: SizedBox(
          width: 1200,
          child: Column(
            children: [
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFooterSection(context, 'About Indriya'),
                        const SizedBox(height: 40),
                        _buildFooterSection(context, 'Quick Links'),
                        const SizedBox(height: 40),
                        _buildFooterSection(context, 'Contact Us'),
                        const SizedBox(height: 40),
                        _buildFooterSection(context, 'Follow Us'),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildFooterSection(context, 'About Indriya')),
                        Expanded(child: _buildFooterSection(context, 'Quick Links')),
                        Expanded(child: _buildFooterSection(context, 'Contact Us')),
                        Expanded(child: _buildFooterSection(context, 'Follow Us')),
                      ],
                    ),
              const SizedBox(height: 60),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© ${DateTime.now().year} Indriya Academy. All rights reserved.',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context, String title) {
    switch (title) {
      case 'About Indriya':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFooterTitle(title),
            const SizedBox(height: 20),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Empowering the next generation of tech professionals with industry-relevant skills and practical training programs.',
              style: TextStyle(
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ],
        );
      case 'Quick Links':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFooterTitle(title),
            const SizedBox(height: 20),
            _buildFooterLink('Home', () {}),
            _buildFooterLink('Courses', () {}),
            _buildFooterLink('About Us', () {}),
            _buildFooterLink('Contact', () {}),
            _buildFooterLink('Blog', () {}),
            _buildFooterLink('Career Support', () {}),
          ],
        );
      case 'Contact Us':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFooterTitle(title),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _launchMap('2nd Floor, FRJC+6MM Indriya Co., CDA Sec - 10, Cuttack, Odisha 753014'),
              child: _buildContactItem(
                Icons.location_on,
                '2nd Floor, FRJC+6MM Indriya Co.\n CDA Sec - 10, Cuttack \n Odisha 753014',
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () => _launchUrl('mailto:connect.indriya@gmail.com'),
              child: _buildContactItem(
                Icons.email,
                'connect.indriya@gmail.com',
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () => _launchUrl('tel:+917735269539'),
              child: _buildContactItem(
                Icons.phone,
                '+91 7735269539',
              ),
            ),
          ],
        );
      case 'Follow Us':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFooterTitle(title),
            const SizedBox(height: 20),
            Row(
              children: [
                
                _buildSocialIcon(FontAwesomeIcons.whatsapp, 'https://wa.me/919876543210'),
                _buildSocialIcon(FontAwesomeIcons.instagram, 'https://www.instagram.com/indriya_edu?igsh=dmQwMjFsN2s2eXRi'),
                
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subscribe to our newsletter',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusMedium,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MaterialButton(
                        onPressed: () {},
                        color: AppTheme.primaryColor,
                        minWidth: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusMedium,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFooterTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 14,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(dynamic icon, String url) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
        icon: icon is IconData
            ? Icon(icon, color: Colors.white, size: 18)
            : FaIcon(icon, color: Colors.white, size: 18),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _launchMap(String address) async {
    final query = Uri.encodeComponent(address);
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}