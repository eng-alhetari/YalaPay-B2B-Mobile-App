import 'package:floor/floor.dart';

@Entity(tableName: 'chequeStatus')
class ChequeStatus {
  @PrimaryKey(autoGenerate: true)
  late int id;
  late String status;

  ChequeStatus({required this.status});
}