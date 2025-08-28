import 'package:floor/floor.dart';
import 'package:yalla_pay/model/invoice_status.dart';

@dao
abstract class InvoiceStatusDao {
@insert
  Future<void> addInvoiceStatus(InvoiceStatus invoiceStatus);

  @delete
  Future<void> deleteInvoiceStatus(InvoiceStatus invoiceStatus);

  @Query('SELECT * FROM invoiceStatus')
  Stream<List<InvoiceStatus>> observeInvoiceStatus();
}