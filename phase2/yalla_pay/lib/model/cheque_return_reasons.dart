import 'package:floor/floor.dart';

@Entity(tableName: 'chequeReturnReasons')
class ChequeReturnReasons {
    @PrimaryKey(autoGenerate: true)
    late int id;
    late String reason;

  ChequeReturnReasons({required this.reason});
}