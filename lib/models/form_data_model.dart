import 'package:hive/hive.dart';

part 'form_data_model.g.dart';

@HiveType(typeId: 1)
class FormDataModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String? age;

  @HiveField(5)
  String? gender;

  @HiveField(6)
  String? country;

  @HiveField(7)
  DateTime? selectedDate;

  @HiveField(8)
  String? selectedTime;

  @HiveField(9)
  double rating;

  @HiveField(10)
  double percentage;

  @HiveField(11)
  double? priceRangeStart;

  @HiveField(12)
  double? priceRangeEnd;

  @HiveField(13)
  bool notifications;

  @HiveField(14)
  bool agreePolicy;

  FormDataModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.age,
    this.gender,
    this.country,
    this.selectedDate,
    this.selectedTime,
    required this.rating,
    required this.percentage,
    this.priceRangeStart,
    this.priceRangeEnd,
    required this.notifications,
    required this.agreePolicy,
  });

  @override
  String toString() {
    return 'FormDataModel{name: $name, email: $email, password: [HIDDEN], phone: $phone, age: ${age ?? ''}, gender: ${gender ?? ''}, country: ${country ?? ''}, date: ${selectedDate?.toIso8601String() ?? ''}, time: ${selectedTime ?? ''}, rating: $rating, percentage: $percentage, priceRange: ${priceRangeStart?.toStringAsFixed(1) ?? 'N/A'}-${priceRangeEnd?.toStringAsFixed(1) ?? 'N/A'}, notifications: $notifications, agreePolicy: $agreePolicy}';
  }
}
