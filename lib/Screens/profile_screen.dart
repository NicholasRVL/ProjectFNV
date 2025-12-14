import 'package:flutter/material.dart';
import 'package:fnv/model/model_user.dart';
import 'package:fnv/service/auth_service.dart';


class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class SettingItem {
  final String label;
  final VoidCallback action;

  SettingItem({required this.label, required this.action});
}






class _ProfileScreenState extends State<ProfileScreen> {
  void _showAlert(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _editProfile() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit Profile clicked')));
  }

  @override
  Widget build(BuildContext context) {
    final settingsItems = [
      SettingItem(
        label: 'Change Password',
        action: () => _showAlert('Change Password'),
      ),
      SettingItem(
        label: 'Theme Preference',
        action: () => _showAlert('Theme Preference'),
      ),
      SettingItem(
        label: 'Notifications',
        action: () => _showAlert('Notifications'),
      ),
      SettingItem(
        label: 'About Developer',
        action: () => _showAlert('About Developer'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF9EFD7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: const Color(0xFF1B2430),
                        child: const Text(
                          'N',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        widget.user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1B2430),
                        ),
                      ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _editProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2430),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: settingsItems.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey[300],
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = settingsItems[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: item.action,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.label,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}