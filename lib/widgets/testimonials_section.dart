import 'package:flutter/material.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Student Success Stories',
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
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: TestimonialCard()),
                    SizedBox(width: 30),
                    Expanded(child: TestimonialCard()),
                    SizedBox(width: 30),
                    Expanded(child: TestimonialCard()),
                  ],
                );
              } else {
                return Column(
                  children: const [
                    TestimonialCard(),
                    SizedBox(height: 30),
                    TestimonialCard(),
                    SizedBox(height: 30),
                    TestimonialCard(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.format_quote, color: Colors.deepOrange, size: 25),
          ),
          const SizedBox(height: 25),
          Text(
            'Thanks to Indriya Academy, I secured a job as a Flutter developer at a top tech company within 3 months of completing my course.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
              
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rahul Sharma',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'App Developer',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}