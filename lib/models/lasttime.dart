import 'package:hive/hive.dart';

part 'lasttime.g.dart';

@HiveType(typeId: 1)
class LastTime {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? category;
  @HiveField(2)
  DateTime? targetTime;
  @HiveField(3)
  DateTime? successTime;

  LastTime(this.title, this.category, this.targetTime, this.successTime);
}
