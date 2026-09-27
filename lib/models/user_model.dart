class User {
  final String id;
  final String cafeId;
  final String? name;
  final String? role;

  User({
    required this.id,
    required this.cafeId,
    this.name,
    this.role,
  });

  // التحقق من الصلاحيات (مؤقتاً يعيد true لجميع الصلاحيات)
  bool canRead(String permission) => true;

  // تحويل البيانات إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cafe_id': cafeId,
      'name': name,
      'role': role,
    };
  }

  // إنشاء كائن User من Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      cafeId: map['cafe_id']?.toString() ?? '',
      name: map['name'],
      role: map['role'],
    );
  }
}