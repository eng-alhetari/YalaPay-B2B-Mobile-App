import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/providers/cheque_deposit_provider.dart';
import 'package:yalla_pay/providers/cheque_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';
import 'package:yalla_pay/widgets/styles_details.dart';

class DepositDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  const DepositDetailsScreen({super.key, required this.id});


  @override
  ConsumerState<DepositDetailsScreen> createState() => _DepositDetailsScreenState();
}

class _DepositDetailsScreenState extends ConsumerState<DepositDetailsScreen> {

  StylesDetails stylesDetails = StylesDetails();

  final DateFormat format = DateFormat("yyyy-MM-dd");
  
  List<Cheque> cheques = [];
  List<ChequeDeposit> deposits = [];

  @override
  Widget build(BuildContext context) {
    deposits = ref.watch(chequeDepositNotifierProvider);
    cheques = ref.watch(chequeNotifierProvider);

    ChequeDeposit deposit = deposits.firstWhere((d) => d.id == widget.id);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              const Text('D E P O S I T\nD E T A I L S', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 121, 121, 121)),
              ),
              const Divider(),
              const SizedBox(height: 20,),
              Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...stylesDetails.headingDetailEntry(heading: 'Account Number', detail: deposit.bankAccountNo, icon: const Icon(Icons.numbers, color: Colors.grey,)),
                        ...stylesDetails.headingDetailEntry(heading: 'Deposit Date', detail: format.format(deposit.depositDate), icon: const Icon(Icons.calendar_month_outlined, color: Colors.grey,)),
                        ...stylesDetails.headingDetailEntryWithBorder(
                          heading: 'Status', 
                          detail: deposit.status, 
                          icon: const Icon(Icons.check_circle_outline, color: Colors.grey,),
                          backgroundColor: const Color.fromARGB(255, 211, 255, 231),
                          textColor: const Color.fromARGB(255, 80, 179, 141)
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on_outlined, color: Colors.grey,),
                    Text('  Cheques   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                  ],
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:16.0, right:16.0),
                      child: ListView.builder(
                        itemCount: deposit.chequeNos.length,
                        itemBuilder: (context, index) {
                      
                          var depositCheque = cheques.firstWhere((element) => element.chequeNo == deposit.chequeNos[index],);
                      
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRouter.chequeDetails.name, pathParameters: {'id' : '${depositCheque.chequeNo}'});
                            },
                            child: Card(
                              elevation: 5,
                              color: index % 2 == 0 ? Colors.blue[50] : Colors.blue[100],
                              child: SizedBox(
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ...stylesDetails.cardHeadingDetailEntry(heading: depositCheque.bankName, detail: 'Drawer: ${depositCheque.drawer}', icon: const Icon(Icons.account_balance_outlined))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ...stylesDetails.cardHeadingDetailEntryWithBorder(
                                            heading: '${depositCheque.amount}', 
                                            detail: depositCheque.status, 
                                            icon: const Icon(Icons.monetization_on_outlined),
                                            textColor: Colors.white,
                                            backgroundColor: Colors.blue[900])
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}