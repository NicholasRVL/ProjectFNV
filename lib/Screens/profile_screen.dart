import 'package:flutter/material.dart';
import 'package:fnv/Screens/home_screen.dart';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/model/model_user.dart';
import 'package:fnv/main.dart';
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


  void _handleLogout() async {

    await AuthSession.logout();


    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(

          builder: (context) =>  MainScreen(), 
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                          '?',
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
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _handleLogout, 
                      tooltip: 'Logout',
                    
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}