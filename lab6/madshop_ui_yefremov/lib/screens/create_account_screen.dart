import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/theme/colors.dart';
import 'package:madshop_ui_Efremov/theme/text_styles.dart';
import 'package:madshop_ui_Efremov/screens/login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Create Account',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 120),
                  // Email field
                  Container(
                    height: 50,
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
                  const SizedBox(height: 8),
                  // Password field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: TextField(
                      obscureText: _obscureText,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: AppTextStyles.inputHint,
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
                      style: AppTextStyles.input,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phone field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Your Phone',
                        hintStyle: AppTextStyles.inputHint,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        prefixIcon: Container(
                          width: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/Flag.png',
                              height: 16,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      style: AppTextStyles.input,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Done button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                      'Done',
                      style: AppTextStyles.button,
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
