class Invoice {
  String? id;
  String customerId;
  String customerName;
  double amount;
  DateTime invoiceDate;
  DateTime dueDate;
  String? status;


  Invoice({
  this.id,
  required this.customerId,
  required this.customerName,
  required this.amount,
  required this.invoiceDate,
  required this.dueDate,
  });

  factory Invoice.fromJson(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      amount: map['amount'],
      invoiceDate: DateTime.parse(map['invoiceDate']),
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
} 