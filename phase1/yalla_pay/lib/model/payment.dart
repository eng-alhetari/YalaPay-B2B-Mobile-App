class Payment {
  String? id;
  String? invoiceNo;
  double amount;
  String paymentDate;
  String paymentMode;
  int? chequeNo;

  Payment({
    this.id = '',
    this.invoiceNo,
    required this.amount,
    required this.paymentDate,
    required this.paymentMode,
    this.chequeNo,
  });

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      invoiceNo: map['invoiceNo'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      paymentDate: map['paymentDate'],
      paymentMode: map['paymentMode'],
      chequeNo: map['chequeNo'],
    );
  }
}
