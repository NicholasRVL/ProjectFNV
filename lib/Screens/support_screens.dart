import 'package:flutter/material.dart';

class ContactOption {
  final IconData icon;
  final String label;
  final String value;

  ContactOption({required this.icon, required this.label, required this.value});
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late List<ContactOption> contactOptions;

  @override
  void initState() {
    super.initState();
    contactOptions = [
      ContactOption(
        icon: Icons.email,
        label: 'Email Support',
        value: 'support@onigirirecipes.com',
      ),
      ContactOption(
        icon: Icons.message,
        label: 'Live Chat',
        value: 'Available 24/7',
      ),
      ContactOption(
        icon: Icons.phone,
        label: 'Phone Support',
        value: '+1 (555) 123-4567',
      ),
    ];
  }

  void _viewFAQs() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('FAQs coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Contact'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF9EFD7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get in touch with our support team through any of the following channels:',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1B2430).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                children: contactOptions
                    .map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9EFD7),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    option.icon,
                                    color: const Color(0xFF1B2430),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.label,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111111),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option.value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: const Color(
                                          0xFF1B2430,
                                        ).withOpacity(0.7),
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find quick answers to common questions',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF1B2430).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _viewFAQs,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2430),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View FAQs',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
