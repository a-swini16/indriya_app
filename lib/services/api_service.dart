// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Replace with your deployed backend URL
  static String baseUrl = 'https://indriya-academy.onrender.com';

  // Send contact form data to backend
  static Future<bool> submitContactForm(String name, String email, String phone,
      String subject, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/contact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'subject': subject,
          'message': message,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting contact form: $e');
      return false;
    }
  }

  // Send enrollment request to backend
  static Future<bool> submitEnrollment(
      String courseTitle, String name, String email, String phone) async {
    try {
      print('Submitting enrollment to: $baseUrl/api/enroll');
      print('Payload: $courseTitle, $name, $email, $phone');

      final response = await http.post(
        Uri.parse('$baseUrl/api/enroll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'courseTitle': courseTitle,
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting enrollment: $e');
      return false;
    }
  }
}
