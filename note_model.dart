import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  Note({required this.title, required this.content});
}
