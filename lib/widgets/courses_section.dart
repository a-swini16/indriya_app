import 'package:flutter/material.dart';
import 'package:indriya_academy/widgets/course_card.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Our Courses',
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
          const SizedBox(height: 20),
          const Text(
            'Explore our diverse range of courses designed to prepare you for the future',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1000
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                childAspectRatio: 1.1,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  CourseCard(
                    title: 'App Development',
                    description: 'Learn to build mobile apps using Flutter, React Native, and more',
                    icon: Icons.phone_android,
                    color: Colors.blue,
                    duration: '12 Weeks',
                    level: 'Beginner to Advanced',
                  ),
                  CourseCard(
                    title: 'Web Development',
                    description: 'Master HTML, CSS, JavaScript, React, and other web technologies',
                    icon: Icons.web,
                    color: Colors.green,
                    duration: '16 Weeks',
                    level: 'Beginner to Advanced',
                  ),
                  CourseCard(
                    title: 'Programming Languages',
                    description: 'Get proficient in Python, Java, C++, Dart, and other languages',
                    icon: Icons.code,
                    color: Colors.amber,
                    duration: '8 Weeks',
                    level: 'Beginner to Intermediate',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}