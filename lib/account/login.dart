import 'package:chatbot/account/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
void _loginWithEmailAndPassword() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (userCredential.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );
    }
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      message = "Wrong password provided.";
    } else {
      message = "Login failed: ${e.message}";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


Future<void> _loginWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'CANCELLED', message: "User cancelled Google sign-in");
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google login successful")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Google login failed: ${e.toString()}")),
    );
  }
}

  void _loginWithGitHub() {
    // Implement GitHub login here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("GitHub sign-in is not yet implemented")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1220),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFFC3B7F7),
                child: Icon(
                  Icons.account_circle,
                  size: 70,
                  color: Color(0xFF0A1220),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loginWithEmailAndPassword,
                child: const Text("Login with Email"),
              ),
              const SizedBox(height: 16),
              // Google button
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/google.png',
                  height: 24,
                ),
                label: const Text("GOOGLE", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 150, 213, 242),
                  fixedSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _loginWithGoogle,
              ),
              const SizedBox(height: 16),
              // GitHub button
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/github.png',
                  height: 24,
                ),
                label: const Text("GITHUB", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 150, 213, 242),
                  fixedSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _loginWithGitHub,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
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
