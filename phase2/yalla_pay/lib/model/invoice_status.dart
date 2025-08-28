import 'package:floor/floor.dart';

@Entity(tableName: 'invoiceStatus')
class InvoiceStatus {
  @PrimaryKey(autoGenerate: true)
  late int id;
    late String status;

  InvoiceStatus({required this.status});
}