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
}
