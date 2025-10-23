import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/theme/colors.dart';
import 'package:madshop_ui_Efremov/theme/text_styles.dart';
import 'package:madshop_ui_Efremov/screens/create_account_screen.dart';
import 'package:madshop_ui_Efremov/screens/password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 300),
                  Text(
                    'Login',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Good to see you back! ♥',
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w300,
                      fontSize: 19,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  // Email field
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: AppTextStyles.inputHint,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        alignLabelWithHint: true,
                      ),
                      style: AppTextStyles.input,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PasswordScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: AppTextStyles.button,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Cancel button (centered)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
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
