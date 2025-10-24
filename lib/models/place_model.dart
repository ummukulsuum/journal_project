import 'package:hive/hive.dart';
part 'place_model.g.dart';

@HiveType(typeId: 1)
class PlaceModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String notes;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  bool visited;

  @HiveField(4)
  DateTime dateAdded;

  @HiveField(5)
  bool isFavourite;

  PlaceModel({
    required this.name,
    required this.notes,
    required this.imagePath,
    this.visited = false,
    this.isFavourite = false,
    required this.dateAdded,
  });

  bool get isVisited => visited;
}
