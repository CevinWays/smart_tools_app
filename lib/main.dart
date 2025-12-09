import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_tools_app/core/router/app_router.dart';
import 'package:smart_tools_app/core/theme/app_theme.dart';
import 'package:smart_tools_app/core/theme/theme_cubit.dart';

import 'package:smart_tools_app/features/contacts/domain/entities/contact_model.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register ContactAdapter
  Hive.registerAdapter(ContactAdapter());
  // Register UserProfileAdapter
  Hive.registerAdapter(UserProfileAdapter());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'SiagaWarga',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
