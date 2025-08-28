class Cheque {
  int? chequeNo;
  double amount;
  String drawer;
  String bankName;
  String status;
  DateTime receivedDate;
  DateTime dueDate;
  DateTime? cashedDate;
  String? returnReason;
  String chequeImageUri;


  Cheque({
  this.chequeNo,
  required this.amount,
  required this.drawer,
  required this.bankName,
  required this.status,
  required this.receivedDate,
  required this.dueDate,
  required this.chequeImageUri,
  });

  factory Cheque.fromJson(Map<String, dynamic> map) {
    return Cheque(
      chequeNo: map['chequeNo'],
      amount: map['amount'],
      drawer: map['drawer'],
      bankName: map['bankName'],
      status: map['status'],
      receivedDate: DateTime.parse(map['receivedDate']),
      dueDate: DateTime.parse(map['dueDate']),
      chequeImageUri: map['chequeImageUri'],
    );
  }
//   factory Cheque.fromJson(Map<String, dynamic> map) {
//   return Cheque(
//     chequeNo: map['chequeNo'],
//     amount: map['amount'],
//     drawer: map['drawer'],
//     bankName: map['bankName'],
//     status: map['status'],
//     receivedDate: DateTime.parse(map['receivedDate']),
//     dueDate: DateTime.parse(map['dueDate']),
//     cashedDate: map['cashedDate'] != null ? DateTime.parse(map['cashedDate']) : null,
//     returnReason: map['returnReason'], // Handle nullable field
//     chequeImageUri: map['chequeImageUri'],
//   );
// }


  Map<String, dynamic> toMap() {
    return {
      'chequeNo': chequeNo,
      'amount': amount,
      'drawer': drawer,
      'bankName': bankName,
      'status': status,
      'receivedDate': receivedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'cashedDate': cashedDate?.toIso8601String(),
      'returnReason': returnReason,
      'chequeImageUri': chequeImageUri,
    };
  }
}