// lib/main.dart
import 'package:flutter/material.dart';
import 'package:indriya_academy/pages/ai_ml_course_detail_page.dart';
import 'package:indriya_academy/pages/all_programming.dart';
import 'package:indriya_academy/pages/cloud_page.dart';
import 'package:indriya_academy/pages/dsa.dart';
import 'package:indriya_academy/pages/home.dart';
import 'package:indriya_academy/pages/courses_page.dart';
import 'package:indriya_academy/pages/course_detail_page.dart';
import 'package:indriya_academy/pages/contact_page.dart';
import 'package:indriya_academy/pages/about_page.dart';
import 'package:indriya_academy/config/theme.dart';
import 'package:indriya_academy/pages/web_dev.dart';
import 'package:indriya_academy/services/api_service.dart';

void main() {
  // Modify in main.dart
ApiService.baseUrl = 'https://indriya-academy.onrender.com'; // Make sure the port matches your backend

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indriya Academy',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/courses': (context) => const CoursesPage(),
        '/course-detail': (context) => const CourseDetailPage(),
        '/ai-ml-detail':(context)=> const AiMlCourseDetailPage(),
        '/web-dev':(context)=>const FullStackWebDevCourseDetailPage(),
        '/cloud-dev':(context)=> const AwsCourseDetailPage(),
        '/all-programming':(context)=>const ProgrammingLanguagesPage(),
        '/dsa-page':(context)=> const DataStructuresCoursePage(),
        '/contact': (context) => const ContactPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
