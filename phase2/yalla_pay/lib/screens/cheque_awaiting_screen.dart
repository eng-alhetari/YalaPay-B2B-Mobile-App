import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/bank_account.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/model/payment.dart';
import 'package:yalla_pay/providers/bank_account_provider.dart';
import 'package:yalla_pay/providers/cheque_deposit_provider.dart';
import 'package:yalla_pay/providers/cheque_provider.dart';
import 'package:yalla_pay/providers/payment_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';
import 'package:yalla_pay/widgets/table.dart';

class ChequeScreen extends ConsumerStatefulWidget {
  const ChequeScreen({super.key});

  @override
  ConsumerState<ChequeScreen> createState() => _ChequeScreenState();
}

class _ChequeScreenState extends ConsumerState<ChequeScreen> {
  // List<Cheque> cheques = [];
  // List<BankAccount> accounts = [];
  // List<Payment> payments = [];
  // List<ChequeDeposit> deposits = [];

  List<int> chequeNos = [];
  int selection = -1;

  final DateFormat format = DateFormat('yyyy-MM-dd');
  bool isWide = false;

  @override
  Widget build(BuildContext context) {
    final cheques = ref.watch(chequeNotifierProvider);
    final accounts = ref.watch(bankAccountNotifierProvider);
    final deposits = ref.watch(chequeDepositNotifierProvider);
    final payments = ref.watch(paymentNotifierProvider);

    var screenData = MediaQuery.of(context);

    screenData.size.width >= 650 ? isWide = true : isWide = false;

    return cheques.when(
      data: (cheques) => Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 15),
              child: Text(
                'C H E Q U E S\nA W A I T I N G',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40, color: Color.fromARGB(255, 121, 121, 121)),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 5, color: const Color.fromARGB(255, 237, 244, 248)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.check),
                          TableHeader(title: 'Cheque No.'),
                        ],
                      ),
                    ),
                    const TableHeader(title: 'Amount'),
                    isWide ? const TableHeader(title: 'Drawer') : Container(),
                    isWide ? const TableHeader(title: 'Bank') : Container(),
                    const TableHeader(title: 'Due Date'),
                    const TableHeader(title: 'Actions'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cheques.length,
                  itemBuilder: (context, index) {
                    if (cheques[index].status != "Awaiting") {
                      return Container();
                    }
                    int alternator = index % 2;
                    int temp = cheques[index].chequeNo!;
                    var days = cheques[index]
                        .dueDate
                        .difference(DateTime.now())
                        .inDays;
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRouter.chequeDetails.name,
                            pathParameters: {
                              'id': '${cheques[index].chequeNo}'
                            });
                      },
                      child: Card(
                        color: alternator == 0
                            ? Colors.blue[100]
                            : Colors.blue[50],
                        elevation: 5,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (chequeNos.isEmpty) {
                                              chequeNos.add(temp);
                                              return;
                                            }

                                            if (chequeNos.contains(temp)) {
                                              chequeNos.remove(temp);
                                            } else {
                                              chequeNos.add(temp);
                                            }
                                          });
                                        },
                                        icon: chequeNos.contains(temp)
                                            ? const Icon(Icons.check_box,
                                                color: Colors.blue)
                                            : const Icon(Icons.check)),
                                    TableEntry(
                                        content: '${cheques[index].chequeNo}',
                                        color: Colors.indigo),
                                  ],
                                ),
                              ),
                              TableEntry(
                                  content: '${cheques[index].amount}',
                                  color: Colors.indigo),
                              isWide
                                  ? TableEntry(
                                      content: cheques[index].drawer,
                                      color: Colors.indigo)
                                  : Container(),
                              isWide
                                  ? TableEntry(
                                      content: cheques[index].bankName,
                                      color: Colors.indigo)
                                  : Container(),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TableEntry(
                                        content: format
                                            .format(cheques[index].dueDate),
                                        color: Colors.indigo),
                                    TableEntry(
                                        content: '($days)',
                                        color: days >= 0
                                            ? Colors.green
                                            : Colors.red)
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  payments.when(
                                    data: (payments) => IconButton(
                                        onPressed: () {
                                          Payment thisPayment =
                                              payments.firstWhere((p) =>
                                                  p.chequeNo ==
                                                  cheques[index].chequeNo);

                                          context.pushNamed(
                                              AppRouter.editPayment.name,
                                              pathParameters: {
                                                'paymentId': thisPayment.id!,
                                                'id': thisPayment.invoiceNo!
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color:
                                              Color.fromARGB(255, 248, 161, 89),
                                        )),
                                    error:
                                        (Object error, StackTrace stackTrace) =>
                                            Text("Error $error"),
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                                chequeNotifierProvider.notifier)
                                            .deleteCheque(
                                                cheques[index].chequeNo!);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Column(
              children: [
                DropdownMenu(
                  width: 275,
                  dropdownMenuEntries: List.generate(accounts.length, (index) {
                    return DropdownMenuEntry(
                        value: index,
                        label:
                            '${accounts[index].bank} - ${accounts[index].accountNo}');
                  }),
                  hintText: 'Select account',
                  textAlign: TextAlign.center,
                  onSelected: (value) {
                    setState(() {
                      selection = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 75,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (chequeNos.isEmpty || selection == -1) {
                      return;
                    }

                    var deposit = ChequeDeposit(
                        status: "Deposited",
                        depositDate: DateTime.now(),
                        bankAccountNo: accounts[selection].accountNo,
                        chequeNos: List.generate(chequeNos.length, (index) {
                          return cheques
                              .map((c) => c.chequeNo!)
                              .firstWhere((c) => c == chequeNos[index]);
                        }));

                    for (int chequeNo in chequeNos) {
                      ref
                          .read(chequeNotifierProvider.notifier)
                          .updateChequeStatus(chequeNo, "Deposited");
                    }

                    ref
                        .read(chequeDepositNotifierProvider.notifier)
                        .addDeposit(deposit);
                    chequeNos = [];
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: chequeNos.isNotEmpty && selection != -1
                        ? const Color.fromARGB(255, 216, 238, 253)
                        : const Color.fromARGB(255, 218, 218, 218),
                    elevation: chequeNos.isNotEmpty && selection != -1 ? 5 : 0,
                  ),
                  child: Text(
                    '  D E P O S I T  ',
                    style: TextStyle(
                        fontSize: 25,
                        color: chequeNos.isNotEmpty && selection != -1
                            ? const Color.fromARGB(255, 98, 123, 204)
                            : Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => Text("Error $error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
