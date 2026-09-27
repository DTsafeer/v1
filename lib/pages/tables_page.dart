import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import '../models/table_model.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = "الكل";
  final double _todaySales = 1250.0;

  final List<CafeTable> _tables = [
    CafeTable(
        id: '1',
        name: 'طاولة 1',
        isOpen: true,
        openedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        totalAmount: 85.0),
    CafeTable(id: '2', name: 'طاولة 2', isOpen: false),
    CafeTable(
        id: '3',
        name: 'طاولة 3',
        isOpen: true,
        openedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        totalAmount: 40.0),
    CafeTable(id: '4', name: 'طاولة 4', isOpen: false),
    CafeTable(id: '5', name: 'طاولة 5', isOpen: false),
    CafeTable(
        id: '6',
        name: 'طاولة VIP',
        isOpen: true,
        openedAt:
        DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
        totalAmount: 210.0),
  ];

  List<CafeTable> get _filteredTables {
    String query = _searchController.text.trim().toLowerCase();
    return _tables.where((table) {
      bool matchesSearch = table.name.toLowerCase().contains(query);
      bool matchesStatus = true;

      if (_statusFilter == "متاحة") {
        matchesStatus = !table.isOpen;
      } else if (_statusFilter == "مشغولة") {
        matchesStatus = table.isOpen;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNewTableDialog() {
    final TextEditingController tableNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("إضافة طاولة جديدة", textAlign: TextAlign.right),
        content: TextField(
          controller: tableNameController,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintText: "اسم أو رقم الطاولة",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              if (tableNameController.text.isNotEmpty) {
                setState(() {
                  _tables.add(
                    CafeTable(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: tableNameController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(theme),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _buildTableGrid(theme),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTableDialog,
        backgroundColor: theme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("طاولة جديدة",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    int total = _tables.length;
    int busy = _tables.where((t) => t.isOpen).length;
    int available = total - busy;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "إدارة الطاولات",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    intl.DateFormat('EEEE, d MMMM', 'ar')
                        .format(DateTime.now()),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 26),
                onPressed: () {
                  setState(() {});
                },
                tooltip: "تحديث البيانات",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard(
                  "الإجمالي", "$total", Icons.grid_view, Colors.white, "الكل"),
              _buildStatCard("المتاحة", "$available",
                  Icons.check_circle_outline, Colors.greenAccent, "متاحة"),
              _buildStatCard("المشغولة", "$busy", Icons.restaurant,
                  Colors.orangeAccent, "مشغولة"),
              _buildStatCard("المبيعات", "${_todaySales.toStringAsFixed(0)} ₪",
                  Icons.trending_up, Colors.lightBlueAccent, "المبيعات"),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "بحث سريع عن طاولة...",
              hintStyle: const TextStyle(color: Colors.white60),
              prefixIcon:
              const Icon(Icons.search, color: Colors.white60, size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      Color iconColor, String filterKey) {
    bool isSelected = _statusFilter == filterKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (filterKey != "المبيعات") {
            setState(() => _statusFilter = filterKey);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.28)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableGrid(ThemeData theme) {
    final tablesList = _filteredTables;

    if (tablesList.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text("لا توجد طاولات لعرضها",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 265,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final table = tablesList[index];
          return TableCardWidget(
            key: ValueKey(table.id),
            table: table,
            theme: theme,
            onDelete: () {
              setState(() {
                _tables.removeWhere((t) => t.id == table.id);
              });
            },
            onStatusChanged: () {
              setState(() {});
            },
          );
        },
        childCount: tablesList.length,
      ),
    );
  }
}

// -------------------------------------------------------------
// عنصر بطاقة الطاولة التفاعلي (TableCardWidget) المنفصل
// -------------------------------------------------------------

enum TimerMode { countUp, countDown }

class TableCardWidget extends StatefulWidget {
  final CafeTable table;
  final ThemeData theme;
  final VoidCallback onDelete;
  final VoidCallback onStatusChanged;

  const TableCardWidget({
    super.key,
    required this.table,
    required this.theme,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  State<TableCardWidget> createState() => _TableCardWidgetState();
}

class _TableCardWidgetState extends State<TableCardWidget> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;

  // إعدادات المؤقت التنازلي
  TimerMode _mode = TimerMode.countUp;
  bool _isFinished = false; // هل انتهى المؤقت التنازلي؟

  @override
  void initState() {
    super.initState();
    if (widget.table.isOpen && widget.table.openedAt != null) {
      _elapsed = DateTime.now().difference(widget.table.openedAt!);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 🟢 تشغيل العداد (سواء تصاعدي أو تنازلي)
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_mode == TimerMode.countUp) {
          _elapsed += const Duration(seconds: 1);
        } else {
          // نمط العداد التنازلي (Countdown)
          if (_elapsed.inSeconds > 1) {
            _elapsed -= const Duration(seconds: 1);
          } else {
            // الوصول إلى الصفر
            _elapsed = Duration.zero;
            _isRunning = false;
            _isFinished = true; // تم انتهاء الوقت
            _timer?.cancel();
          }
        }
      });
    });
  }

  // ⏸️ إيقاف العداد مؤقتًا
  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        _isRunning = false;
      });
    }
  }

  // 🔄 تصفير العداد إلى 00:00:00 وتفريع النمط إلى التصاعدي
  void _resetTimer() {
    _pauseTimer();
    if (mounted) {
      setState(() {
        _elapsed = Duration.zero;
        _mode = TimerMode.countUp;
        _isFinished = false;
        widget.table.openedAt = widget.table.isOpen ? DateTime.now() : null;
      });
    }
  }

  // 🛑 إغلاق الطاولة وإلغاء العداد
  void _stopAndCloseTable() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _elapsed = Duration.zero;
      _isRunning = false;
      _mode = TimerMode.countUp;
      _isFinished = false;
      widget.table.isOpen = false;
      widget.table.openedAt = null;
      widget.table.totalAmount = 0.0;
    });
    widget.onStatusChanged();
  }

  // ⏱️ فتح نافذة إدخال تفاصيل المؤقت التنازلي
  void _showTimerDialog() {
    final hoursController = TextEditingController();
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("ضبط مؤقت تنازلي", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("أدخل مدة المؤقت المطلوبة:", style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeInput(
                      controller: hoursController,
                      label: "ساعة",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTimeInput(
                      controller: minutesController,
                      label: "دقيقة",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTimeInput(
                      controller: secondsController,
                      label: "ثانية",
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                int hours = int.tryParse(hoursController.text) ?? 0;
                int minutes = int.tryParse(minutesController.text) ?? 0;
                int seconds = int.tryParse(secondsController.text) ?? 0;

                Duration totalDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);

                if (totalDuration.inSeconds > 0) {
                  setState(() {
                    _mode = TimerMode.countDown;
                    _elapsed = totalDuration;
                    _isFinished = false;
                  });
                  Navigator.pop(context);
                  _startTimer();
                }
              },
              child: const Text("بدء المؤقت"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeInput({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }

  // تنسيق النص إلى (HH:MM:SS)
  String get _formattedTime {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('هل أنت تأكد من حذف الطاولة : ${widget.table.name}؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete();
              },
              child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _isFinished
        ? Colors.red
        : (widget.table.isOpen ? Colors.orange : Colors.green);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isFinished ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFinished ? Colors.red : statusColor.withOpacity(0.4),
          width: _isFinished ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // رأس الكارت: الحالة والأيقونة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isFinished
                      ? Colors.red.withOpacity(0.15)
                      : statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isFinished
                      ? "انتهى الوقت!"
                      : (widget.table.isOpen ? "مشغولة" : "متاحة"),
                  style: TextStyle(
                      color: _isFinished ? Colors.red : statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // 🔔 الأيقونة التنبيهية عند الانتهاء
              Icon(
                _isFinished
                    ? Icons.notifications_active_rounded
                    : Icons.table_restaurant,
                color: _isFinished ? Colors.red : statusColor,
                size: 22,
              ),
            ],
          ),

          // اسم الطاولة والمبلغ والتايمر
          Column(
            children: [
              Text(
                widget.table.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (widget.table.isOpen) ...[
                const SizedBox(height: 2),
                Text(
                  "${widget.table.totalAmount.toStringAsFixed(1)} ₪",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.theme.primaryColor),
                ),
              ],
              Visibility(
                visible: widget.table.isOpen,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_mode == TimerMode.countDown)
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Icon(Icons.timer_outlined, size: 14, color: Colors.deepOrange),
                        ),
                      Text(
                        _formattedTime,
                        style: TextStyle(
                          color: _isFinished
                              ? Colors.red
                              : (_isRunning ? Colors.blue[800] : Colors.grey[700]),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          // منطقة الأزرار
          widget.table.isOpen
          // 🟢 حالة الطاولة مفتوحة
              ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.payments_outlined,
                    label: 'دفع',
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  // ⏱️ زر "عداد" - للتشغيل أو الإيقاف
                  _buildActionButton(
                    icon: _isRunning ? Icons.pause : Icons.play_arrow,
                    label: _isRunning ? 'إيقاف' : 'تشغيل',
                    color: _isRunning ? Colors.amber[800]! : Colors.blue,
                    onPressed: () {
                      if (_isRunning) {
                        _pauseTimer();
                      } else {
                        _startTimer();
                      }
                    },
                  ),
                  // ⏲️ زر "مؤقت" - إظهار بوب-أب لإدخال المدة
                  _buildActionButton(
                    icon: Icons.timer,
                    label: 'مؤقت',
                    color: Colors.deepOrange,
                    onPressed: _showTimerDialog,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 🔄 زر "تصفير"
                  _buildActionButton(
                    icon: Icons.refresh_rounded,
                    label: 'تصفير',
                    color: Colors.deepPurple,
                    onPressed: () {
                      // التحقق من أن الوقت أكبر من صفر قبل إظهار مربع الحوار
                      if (_elapsed.inSeconds > 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text('هل أنت تأكد من تصفير الوقت : ${widget.table.name}؟'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetTimer();
                                  },
                                  child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.not_started_sharp,
                    label: 'إغلاق',
                    color: Colors.orange,
                    onPressed: _stopAndCloseTable,
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'حذف',
                    color: Colors.red,
                    onPressed: _showDeleteDialog,
                  ),
                ],
              ),
            ],
          )
          // 🔴 حالة الطاولة مغلقة
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.play_arrow,
                label: 'فتح',
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    widget.table.isOpen = true;
                    widget.table.openedAt = DateTime.now();
                  });
                  _startTimer();
                  widget.onStatusChanged();
                },
              ),
              _buildActionButton(
                icon: Icons.delete,
                label: 'حذف',
                color: Colors.grey,
                onPressed: _showDeleteDialog,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: color.withOpacity(0.08),
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPressed,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}