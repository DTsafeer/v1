import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استدعاء ملف المستخدم وشاشة اللوحة الرئيسية
import 'models/user_model.dart';
import 'pages/DashboardPage.dart' hide User;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SystemCafeApp());
}

class SystemCafeApp extends StatelessWidget {
  const SystemCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء مستخدم تجريبي غير فارغ لتفادي خطأ الـ Null
    final mockUser = User(
      id: '1',
      cafeId: 'cafe_01',
      name: 'صلاح الدين',
      role: 'مدير',
    );

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
      // تم حذف const وتمرير mockUser مباشرة لحل الخطأ
      home: DashboardPage(currentUser: mockUser),
    );
  }
}