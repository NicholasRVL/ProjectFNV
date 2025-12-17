import 'package:flutter/material.dart';
import 'package:fnv/Screens/home_screen.dart';
import 'package:fnv/Screens/profile_screen.dart';
import 'package:fnv/Screens/favorite_screen.dart';
import 'package:fnv/Screens/signin_screen.dart';
import 'package:fnv/Screens/request_screen.dart';
import 'package:fnv/service/auth_service.dart';
import 'package:fnv/admin/form_resep.dart';
import 'package:fnv/intro.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FNV App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Intro(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    
    HomeScreen(user: AuthSession.currentUser),

    AuthSession.currentUser != null
      ? FavoriteScreen(user: AuthSession.currentUser!)
      : SignInScreen(),

    AuthSession.currentUser != null
      ? RequestScreen(user: AuthSession.currentUser!)
      : SignInScreen(),

    AuthSession.currentUser != null
      ? ProfileScreen(user: AuthSession.currentUser!)
      : SignInScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
         
        ],
      ),
    );
  }
}