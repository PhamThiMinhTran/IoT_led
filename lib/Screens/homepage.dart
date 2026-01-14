import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('lights');

  bool light1 = false;
  bool light2 = false;

  @override
  void initState() {
    super.initState();
    _listenLightState();
  }

  void _listenLightState() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return;

      setState(() {
        light1 = data['light1'] ?? false;
        light2 = data['light2'] ?? false;
      });
    });
  }

  Future<void> _toggleLight(String key, bool currentValue) async {
    await _dbRef.child(key).set(!currentValue);
  }

  Future<void> _logout(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều khiển thông minh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 17, 81, 127),
              Color.fromARGB(255, 28, 158, 234),
              Color.fromARGB(255, 15, 146, 222),
              Color.fromARGB(255, 100, 181, 227),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lightbulb,
              color: Colors.yellow,
              size: 120,
            ),
            const SizedBox(height: 20),
            Text(
              light1 ? 'Đèn 1: BẬT' : 'Đèn 1: TẮT',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _toggleLight('light1', light1),
              child: Text(light1 ? 'Tắt đèn 1' : 'Bật đèn 1'),
            ),
            const Icon(
              Icons.lightbulb,
              color: Colors.yellow,
              size: 120,
            ),
            const SizedBox(height: 30),
            Text(
              light2 ? 'Đèn 2: BẬT' : 'Đèn 2: TẮT',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _toggleLight('light2', light2),
              child: Text(light2 ? 'Tắt đèn 2' : 'Bật đèn 2'),
            ),
          ],
        ),
      ),
    );
  }
}
