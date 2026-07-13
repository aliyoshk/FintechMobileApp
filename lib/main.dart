import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const ProviderScope(child: MintynApp()));
}

class MintynApp extends StatelessWidget {
  const MintynApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          surface: AppColors.surface,
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardPage(),
    );
  }
}
