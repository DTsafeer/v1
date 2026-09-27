import 'dart:math';
import 'package:flutter/material.dart';

// نموذج وهمي بسيط للمستخدم
class User {
  final String id;
  final String? parentId;
  final String cafeId;

  User({required this.id, this.parentId, required this.cafeId});

  bool canRead(String permission) => true;
}

class DashboardPage extends StatefulWidget {
  final User currentUser;
  const DashboardPage({super.key, required this.currentUser});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Random _random = Random();

  // قيم متغيرة للعرض (UI Only)
  late String currencySymbol;
  late double totalSales;
  late double totalCOGS;
  late double otherExpenses;
  late double shopInventory;
  late double warehouseInventory;
  late double totalDebts;
  late double dailyDebts;
  late double weeklyDebts;
  late double monthlyDebts;
  late double dailyExpenses;
  late double weeklyExpenses;
  late double monthlyExpenses;

  final List<String> _paymentMethods = ["كاش", "شبكة", "دين"];
  final List<Map<String, String>> _customerSuggestions = [
    {'id': '1', 'name': 'أحمد محمود', 'phone': '0599000000', 'debt': '150.0', 'no': '101'},
    {'id': '2', 'name': 'محمد علي', 'phone': '0598000000', 'debt': '75.5', 'no': '102'},
    {'id': '3', 'name': 'خالد المنصور', 'phone': '0597000000', 'debt': '210.0', 'no': '103'},
  ];

  @override
  void initState() {
    super.initState();
    _generateRandomData();
  }

  // توليد قيم عشوائية لملء الواجهة
  void _generateRandomData() {
    currencySymbol = "₪";
    totalSales = (_random.nextInt(15000) + 5000).toDouble();
    totalCOGS = totalSales * (0.3 + _random.nextDouble() * 0.2);
    otherExpenses = (_random.nextInt(3000) + 500).toDouble();
    shopInventory = (_random.nextInt(10000) + 2000).toDouble();
    warehouseInventory = (_random.nextInt(8000) + 1000).toDouble();
    totalDebts = (_random.nextInt(5000) + 500).toDouble();

    dailyDebts = (_random.nextInt(300) + 50).toDouble();
    weeklyDebts = dailyDebts * 5 + _random.nextInt(200);
    monthlyDebts = totalDebts;

    dailyExpenses = (_random.nextInt(200) + 20).toDouble();
    weeklyExpenses = dailyExpenses * 6 + _random.nextInt(150);
    monthlyExpenses = otherExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("الرئيسية والتحليل", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "تحديث الأرقام العشوائية",
            onPressed: () => setState(() => _generateRandomData()),
          ),
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: "سجل الديون",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.amber),
            tooltip: "بيع سريع (سفري)",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            tooltip: "إضافة حوالة سريعة",
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDetailedNetProfit(primaryColor),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildQuickButton("سجل الديون", Icons.people_alt_rounded, Colors.red[400]!),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildQuickButton("بيع سفري", Icons.flash_on_rounded, Colors.orange[400]!),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _buildInventoryValueRow(),
            const SizedBox(height: 15),
            _buildDebtStatsRow(),
            const SizedBox(height: 15),
            _buildExpensesStatsRow(),
            const SizedBox(height: 25),
            _buildPlaceholderChart("مخطط المبيعات الأسبوعية", primaryColor),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInactiveCustomersSection()),
                const SizedBox(width: 20),
                Expanded(child: _buildPlaceholderChart("توزيع المصاريف", Colors.teal)),
              ],
            ),
            const SizedBox(height: 25),
            _buildTopSellingSection(primaryColor),
          ],
        ),
      ),
    );
  }

  // كارت ملخص أرباح الشهر بقيم عشوائية
  Widget _buildDetailedNetProfit(Color primary) {
    double grossProfit = totalSales - totalCOGS;
    double netProfit = grossProfit - otherExpenses;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primary.withBlue(100)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _profitStat("المبيعات", totalSales, Colors.white70),
              _profitStat("التكلفة", totalCOGS, Colors.white70),
              _profitStat("المصاريف", otherExpenses, Colors.white70),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          const Text(
            "صافي أرباح الشهر (التقديري)",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            "${netProfit.toStringAsFixed(1)} $currencySymbol",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "هامش الربح: ${totalSales > 0 ? ((grossProfit / totalSales) * 100).toStringAsFixed(1) : 0}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _profitStat(String label, double val, Color color) => Column(
    children: [
      Text(label, style: TextStyle(color: color, fontSize: 11)),
      Text(
        "${val.toInt()} $currencySymbol",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _buildInventoryValueRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox("بضاعة المحل", shopInventory, Colors.blue),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("المخزن (مواد)", warehouseInventory, Colors.orange),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("إجمالي الديون", totalDebts, Colors.redAccent),
        ),
      ],
    );
  }

  Widget _buildDebtStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox("ديون اليوم", dailyDebts, Colors.redAccent.withOpacity(0.8)),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("ديون الأسبوع", weeklyDebts, Colors.orangeAccent),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("ديون الشهر", monthlyDebts, Colors.purpleAccent),
        ),
      ],
    );
  }

  Widget _buildExpensesStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox("مصاريف اليوم", dailyExpenses, Colors.red[300]!),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("مصاريف الأسبوع", weeklyExpenses, Colors.orange[300]!),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatBox("مصاريف الشهر", monthlyExpenses, Colors.purple[300]!),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(
            "${value.toStringAsFixed(1)} $currencySymbol",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveCustomersSection() {
    final inactive = [
      {'customer': 'خالد المنصور'},
      {'customer': 'سامي يوسف'},
      {'customer': 'عمر الخطيب'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "زبائن غائبون (>15 يوم)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: inactive
                .map(
                  (d) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(d['customer']!),
                trailing: const Icon(Icons.call, color: Colors.green, size: 18),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingSection(Color primary) {
    final topSellingItems = [
      {'name': 'قهوة إسبانيول', 'count': _random.nextInt(100) + 100},
      {'name': 'كابتشينو', 'count': _random.nextInt(80) + 50},
      {'name': 'شاي أحمر', 'count': _random.nextInt(60) + 40},
      {'name': 'كرواسون شوكولاتة', 'count': _random.nextInt(40) + 30},
      {'name': 'عصير برتقال طازج', 'count': _random.nextInt(30) + 10},
    ];

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "الأصناف الأكثر طلباً",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Column(
            children: topSellingItems.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: primary.withOpacity(0.1),
                  child: Text("${index + 1}"),
                ),
                title: Text(item['name'].toString()),
                trailing: Text("${item['count']} قطعة"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderChart(String title, Color color) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Expanded(
            child: Center(
              child: Icon(Icons.bar_chart_rounded, size: 60, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}