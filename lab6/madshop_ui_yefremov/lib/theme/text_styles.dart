import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 50,
    fontFamily: 'Raleway',
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );
  static const subtitle = TextStyle(
    fontSize: 19,
    fontFamily: 'Nunito Sans',
    color: AppColors.textDark,
    height: 1.84,
  );
  static const button = TextStyle(
    fontSize: 22,
    fontFamily: 'Nunito Sans',
    color: Colors.white,
  );
  static const body = TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
    color: AppColors.textLight,
  );
  static const TextStyle input = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static TextStyle inputHint = input.copyWith(
    color: AppColors.placeholder,
  );
}
