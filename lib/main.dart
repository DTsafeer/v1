import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/user_model.dart';
import 'pages/DashboardPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SystemCafeApp());
}

class SystemCafeApp extends StatelessWidget {
  const SystemCafeApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'سيستم كافيه برو',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37),
        ),
      ),
      home: DashboardPage(),
    );
  }
}