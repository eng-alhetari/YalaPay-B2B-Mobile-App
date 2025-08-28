class ChequeDeposit {
  String? id;
  DateTime depositDate;
  DateTime? cashedDate;
  String bankAccountNo;
  String status;
  List<int> chequeNos;

  ChequeDeposit({
    this.id,
    required this.depositDate,
    required this.bankAccountNo,
    required this.status ,
    List<int>? chequeNos
  }) : chequeNos = chequeNos ?? [];

  factory ChequeDeposit.fromJson(Map<String, dynamic> map) {
    return ChequeDeposit(
      id: map['id'] as String,
      depositDate: DateTime.parse(map['depositDate']),
      bankAccountNo: map['bankAccountNo'] as String,
      status: map['status'] as String,
      chequeNos: List<int>.from(map['chequeNos']),
    );
  }
//   factory ChequeDeposit.fromJson(Map<String, dynamic> map) {
//   return ChequeDeposit(
//     id: map['id'], // Null-safe assignment
//     depositDate: DateTime.parse(map['depositDate']),
//     cashedDate: map['cashedDate'] != null ? DateTime.parse(map['cashedDate']) : null,
//     bankAccountNo: map['bankAccountNo'],
//     status: map['status'],
//     chequeNos: map['chequeNos'] != null ? List<int>.from(map['chequeNos']) : [],
//   );
// }


  
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'depositDate': depositDate.toIso8601String(), // Convert to ISO 8601 string
    'cashedDate': cashedDate?.toIso8601String(), // Null-safe conversion
    'bankAccountNo': bankAccountNo,
    'status': status,
    'chequeNos': chequeNos, // List<int> can be directly serialized
  };
}

}
