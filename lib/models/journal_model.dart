import 'package:hive/hive.dart';
part 'journal_model.g.dart';

@HiveType(typeId: 0)
class JournalModel extends HiveObject {
  @HiveField(0)
  late DateTime date;
  
  @HiveField(1)
  late String heading;
  
  @HiveField(2)
  late String imagePath;
  
  @HiveField(3)
  late String notes;
  JournalModel({required this.date,required this.heading,required this.imagePath,required this.notes});
}