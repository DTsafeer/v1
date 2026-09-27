class CafeTable {
   String id;
   String name;
   bool isOpen;
   DateTime? openedAt;
   double totalAmount;

  CafeTable({
    required this.id,
    required this.name,
    this.isOpen = false,
    this.openedAt,
    this.totalAmount = 0.0,
  });

  // تحويل JSON القادم من Laravel API إلى Model
  factory CafeTable.fromJson(Map<String, dynamic> json) {
    return CafeTable(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isOpen: json['is_open'] == true || json['is_open'] == 1,
      openedAt: json['opened_at'] != null ? DateTime.tryParse(json['opened_at'].toString()) : null,
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
    );
  }

  // تحويل Model إلى JSON لإرساله إلى Laravel API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_open': isOpen,
      'opened_at': openedAt?.toIso8601String(),
      'total_amount': totalAmount,
    };
  }

  // دالة للنسخ والتعديل على الكائن بسهولة
  CafeTable copyWith({
    String? id,
    String? name,
    bool? isOpen,
    DateTime? openedAt,
    double? totalAmount,
  }) {
    return CafeTable(
      id: id ?? this.id,
      name: name ?? this.name,
      isOpen: isOpen ?? this.isOpen,
      openedAt: openedAt ?? this.openedAt,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}