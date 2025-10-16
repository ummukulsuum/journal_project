import 'package:hive/hive.dart';
part 'journal_model.g.dart';

@HiveType(typeId: 0)
class JournalModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String heading;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  String notes;

  JournalModel({
    required this.date,
    required this.heading,
    required this.imagePath,
    required this.notes,
  });
}
