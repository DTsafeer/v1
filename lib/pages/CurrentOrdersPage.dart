import 'package:flutter/material.dart';
import 'DashboardPage.dart';
import 'MainLayout.dart';

// نموذج وهمي بسيط يمثل الطلب داخل الطاولة
class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final DateTime orderedAt;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.orderedAt,
  });
}

class CurrentOrdersPage extends StatefulWidget {
  final User currentUser;
  final String? tableFilter;

  const CurrentOrdersPage({
    super.key,
    required this.currentUser,
    this.tableFilter,
  });

  @override
  State<CurrentOrdersPage> createState() => _CurrentOrdersPageState();
}

class _CurrentOrdersPageState extends State<CurrentOrdersPage> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final String currencySymbol = "₪";

  // بيانات وهمية تجريبية للطاولات والطلبات
  final Map<String, List<OrderItem>> _mockTablesData = {
    'طاولة 1': [
      OrderItem(
        id: 'ord_1',
        name: 'إسبانيش لاتيه',
        price: 15.0,
        quantity: 2,
        orderedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      OrderItem(
        id: 'ord_2',
        name: 'كيك شوكولاتة',
        price: 20.0,
        quantity: 1,
        orderedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    ],
    'طاولة 3': [
      OrderItem(
        id: 'ord_3',
        name: 'شاي أحمر',
        price: 5.0,
        quantity: 3,
        orderedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      OrderItem(
        id: 'ord_4',
        name: 'شيشة فاخر',
        price: 35.0,
        quantity: 1,
        orderedAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
    ],
    'طاولة 5': [
      OrderItem(
        id: 'ord_5',
        name: 'عصير برتقال طازج',
        price: 12.0,
        quantity: 2,
        orderedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.tableFilter ?? "";
    _searchController.text = _searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // حذف طلب معين من قائمة الطاولة
  void _deleteOrderItem(String tableName, OrderItem item) {
    setState(() {
      _mockTablesData[tableName]?.removeWhere((o) => o.id == item.id);
      if (_mockTablesData[tableName]?.isEmpty ?? false) {
        _mockTablesData.remove(tableName);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف "${item.name}" من $tableName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // تحويل طلب معين إلى طاولة أخرى
  void _transferOrderItem(String currentTable, OrderItem item) {
    final TextEditingController newTableController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'تحويل "${item.name}"',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الطلب الحالي في: $currentTable',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: newTableController,
              decoration: InputDecoration(
                labelText: 'اسم/رقم الطاولة الجديدة',
                hintText: 'مثال: طاولة 4',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final newTable = newTableController.text.trim();
              if (newTable.isNotEmpty && newTable != currentTable) {
                setState(() {
                  // إزالة من الطاولة الحالية
                  _mockTablesData[currentTable]?.removeWhere((o) => o.id == item.id);
                  if (_mockTablesData[currentTable]?.isEmpty ?? false) {
                    _mockTablesData.remove(currentTable);
                  }

                  // إضافة للطاولة الجديدة
                  _mockTablesData.putIfAbsent(newTable, () => []);
                  _mockTablesData[newTable]!.add(item);
                });

                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تحويل "${item.name}" إلى $newTable بنجاح'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('تحويل', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // تصفية الطاولات بناءً على نص البحث
    final filteredTables = _mockTablesData.keys.where((tableName) {
      return _searchQuery.isEmpty || tableName.contains(_searchQuery);
    }).toList();

    return MainLayout(
      currentUser: widget.currentUser,
      currentPage: 'orders',
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                // الهيدر وشريط البحث
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isWide ? 40 : 25),
                      bottomRight: Radius.circular(isWide ? 40 : 25),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "فواتير الطاولات النشطة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: SizedBox(
                          width: 600,
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            onChanged: (v) => setState(() => _searchQuery = v.trim()),
                            decoration: InputDecoration(
                              hintText: 'بحث باسم الطاولة...',
                              hintStyle: const TextStyle(color: Colors.white60),
                              prefixIcon: const Icon(Icons.search, color: Colors.white60, size: 20),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // عرض بطاقات الطاولات النشطة
                Expanded(
                  child: filteredTables.isEmpty
                      ? const Center(
                    child: Text(
                      "لا توجد فواتير نشطة حالياً",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: isWide ? 550 : constraints.maxWidth,
                      mainAxisExtent: 420,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: filteredTables.length,
                    itemBuilder: (context, index) {
                      final tableName = filteredTables[index];
                      final items = _mockTablesData[tableName]!;

                      return _buildTableOrderCard(
                        tableName: tableName,
                        items: items,
                        primaryColor: primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // كارد الطاولة والطلبات الواردة بها
  Widget _buildTableOrderCard({
    required String tableName,
    required List<OrderItem> items,
    required Color primaryColor,
  }) {
    double totalAmount = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // رأس الكارد (اسم الطاولة والمجموع)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.table_restaurant, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      tableName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${totalAmount.toStringAsFixed(1)} $currencySymbol",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة الاصناف
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = items[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item.name} (×${item.quantity})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "${(item.price * item.quantity).toStringAsFixed(1)} $currencySymbol",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // زر تحويل الطلب لطاولة أخرى
                      IconButton(
                        icon: const Icon(Icons.swap_horiz, size: 20, color: Colors.orange),
                        tooltip: "تحويل لطاولة أخرى",
                        onPressed: () => _transferOrderItem(tableName, item),
                      ),
                      // زر حذف الطلب
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        tooltip: "حذف الطلب",
                        onPressed: () => _deleteOrderItem(tableName, item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // أزرار التحكم بأسفل الكارد
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إغلاق فاتورة $tableName')),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                    label: const Text("إنهاء وتحصيل", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}