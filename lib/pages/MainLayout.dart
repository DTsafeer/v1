import 'package:flutter/material.dart';

import 'DashboardPage.dart';

class MainLayout extends StatefulWidget {
  final String currentPage;
  final User currentUser;
  final Widget child;
  final VoidCallback? onLogout;

  const MainLayout({
    super.key,
    required this.currentPage,
    required this.currentUser,
    required this.child,
    this.onLogout,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // عناوين ومسارات القائمة الجانبية
  final List<Map<String, dynamic>> _menuItems = const [
    {'title': 'شاشة الطاولات', 'icon': Icons.table_restaurant, 'key': 'tables'},
    {'title': 'فواتير الطاولات النشطة', 'icon': Icons.receipt_long, 'key': 'orders'},
    {'title': 'الصفحة الرئيسية', 'icon': Icons.dashboard_rounded, 'key': 'dashboard'},
    {'title': 'قائمة الطعام (المنيو)', 'icon': Icons.restaurant_menu, 'key': 'menu'},
    {'title': 'المخزون والمنتجات', 'icon': Icons.inventory, 'key': 'inventory'},
    {'title': 'المبيعات اليومية', 'icon': Icons.point_of_sale, 'key': 'sales'},
    {'title': 'المصروفات', 'icon': Icons.money_off, 'key': 'expenses'},
    {'title': 'إدارة العملاء', 'icon': Icons.people, 'key': 'customers'},
    {'title': 'إدارة الموردين', 'icon': Icons.local_shipping, 'key': 'suppliers'},
    {'title': 'فواتير المشتريات', 'icon': Icons.shopping_cart, 'key': 'purchases'},
    {'title': 'حسابات الديون', 'icon': Icons.account_balance_wallet, 'key': 'debts'},
    {'title': 'إدارة الموظفين', 'icon': Icons.admin_panel_settings, 'key': 'employees'},
    {'title': 'التقارير الشاملة', 'icon': Icons.analytics, 'key': 'reports'},
    {'title': 'الإعدادات العامة', 'icon': Icons.settings, 'key': 'settings'},
  ];

  @override
  void initState() {
    super.initState();
    // تحديد العنصر المخصص بناءً على الصفحة الحالية الممررة
    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(covariant MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _updateSelectedIndex();
    }
  }

  void _updateSelectedIndex() {
    final index = _menuItems.indexWhere((item) => item['key'] == widget.currentPage);
    if (index != -1) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Scaffold(
          // شريط علوي للهواتف والشاشات الصغيرة
          appBar: isMobile
              ? AppBar(
            title: const Text('سيستم كافيه', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            backgroundColor: const Color(0xFF1A252F),
            foregroundColor: Colors.white,
            centerTitle: true,
          )
              : null,

          // قائمة جانبية طافية للهواتف
          drawer: isMobile ? Drawer(child: _buildSidebarContent(isMobile: true)) : null,

          body: Row(
            children: [
              // قائمة جانبية ثابتة للشاشات الكبيرة
              if (!isMobile)
                SizedBox(
                  width: 260,
                  child: _buildSidebarContent(isMobile: false),
                ),

              // المحتوى الرئيسي الممرر (widget.child)
              Expanded(
                child: Container(
                  color: const Color(0xFFF8F9FA),
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // محتوى القائمة الجانبية (Sidebar)
  Widget _buildSidebarContent({required bool isMobile}) {
    return Container(
      color: const Color(0xFF2C3E50),
      child: Column(
        children: [
          // 1. الهيدر (الشعار)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: const Color(0xFF1A252F),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_cafe, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سيستم كافيه',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'إدارة واستخدام سريعة',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. قائمة العناصر القابلة للتمرير
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected ? Colors.amber : Colors.white70,
                      size: 20,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.amber : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    tileColor: isSelected ? const Color(0xFF34495E) : Colors.transparent,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      if (isMobile) Navigator.pop(context); // إغلاق الـ Drawer في الجوال
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // 3. الجزء السفلي (بيانات المستخدم وزر الخروج)
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1A252F),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber.shade700,
                  radius: 18,
                  child: Text(
                    widget.currentUser.id.isNotEmpty ? widget.currentUser.id[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "مستخدم ${widget.currentUser.id}",
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "مقهى: ${widget.currentUser.cafeId}",
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                  tooltip: "تسجيل الخروج",
                  onPressed: widget.onLogout ?? () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}