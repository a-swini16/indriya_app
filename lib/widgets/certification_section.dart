import 'package:flutter/material.dart';

class CertificationSection extends StatelessWidget {
  const CertificationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Text(
            'Certified By',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.deepOrange,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 50),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCertificationLogo('assets/images/skill_india_logo.png'),
                _buildCertificationLogo('assets/images/govt_india_logo.png'),
                _buildCertificationLogo('assets/images/nsdc_logo.png'),
                _buildCertificationLogo('assets/images/google_logo.png'),
                _buildCertificationLogo('assets/images/aws_logo.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationLogo(String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Image.asset(
        image,
        height: 80,
      ),
    );
  }
}