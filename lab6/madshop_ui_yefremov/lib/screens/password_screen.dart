// lib/screens/password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/theme/colors.dart'; // Assuming colors are defined here
import 'package:madshop_ui_Efremov/theme/text_styles.dart'; // Assuming styles are defined here
import 'package:madshop_ui_Efremov/screens/login_screen.dart'; // Assuming login_screen.dart exists
import 'package:madshop_ui_Efremov/screens/home_screen.dart'; // Assuming home_screen.dart exists

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center all content horizontally
                children: [
                  const SizedBox(height: 200),
                  Text(
                    'Hello',
                    style: AppTextStyles.title, // Raleway bold 50
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type your password',
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w300,
                      fontSize: 19,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100),
                  // Password field
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground, // #E2E2E3
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: TextField(
                      obscureText: _obscureText,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: AppTextStyles.inputHint, // Poppins medium 14, #C1C1C3
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/eye-slash.svg',
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              _obscureText ? Colors.black : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: AppTextStyles.input, // Poppins medium 14
                    ),
                  ),
                  const SizedBox(height: 100),
                  // Start button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton, // #0448EB
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Start',
                      style: AppTextStyles.button, // Nunito Sans light 22, white
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Cancel button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
