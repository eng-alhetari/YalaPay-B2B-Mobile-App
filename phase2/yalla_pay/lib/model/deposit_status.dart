import 'package:floor/floor.dart';

@Entity(tableName: 'depositStatus')
class DepositStatus {
  @PrimaryKey(autoGenerate: true)
  late int id;
    late String status;

  DepositStatus({required this.status});
}