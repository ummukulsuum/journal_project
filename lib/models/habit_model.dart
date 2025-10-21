import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String type;

  @HiveField(2)
  int value;

  @HiveField(3)
  String userId;

  HabitModel({
    required this.title,
    required this.type,
    required this.value,
    required this.userId,
  });
}
