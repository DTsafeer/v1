import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استدعاء الواجهة الرئيسية فقط
import 'MainLayout.dart';
import 'pages/MainLayout.dart';

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
      // فتح الـ UI مباشرة عبر MainLayout
      home: const MainLayout(currentPage: '', currentUser: null, child: null,),
    );
  }
}