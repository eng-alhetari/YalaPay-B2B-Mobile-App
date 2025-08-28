import 'package:floor/floor.dart';

@Entity(tableName: 'paymentModes')
class PaymentModes { 
  @PrimaryKey(autoGenerate: true)
  late int id;
  late String mode;


  PaymentModes({required this.mode});
}