import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/providers/cheque_deposit_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';
import 'package:yalla_pay/widgets/table.dart';


class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {

  List<ChequeDeposit> deposits = [];
  final DateFormat format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {

    deposits = ref.watch(chequeDepositNotifierProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Text('D E P O S I T S', 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 121, 121, 121)),
            ),
            const Divider(),
            const SizedBox(height: 20,),
            Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: const Color.fromARGB(255, 237, 244, 248)
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TableHeader(title: 'Actions'),
                  TableHeader(title: 'Deposit Date'),
                  TableHeader(title: 'AccountNo'),
                  TableHeader(title: 'Total Cheques'),
                  TableHeader(title: 'Total')
                ],
              ),
            ),
          ),
            Expanded(
              child: ListView.builder(
                itemCount: deposits.length,
                itemBuilder: (context, index) {

                  int alternator = index % 2;

                  return Card(
                    color: alternator == 0 ? Colors.blue[100] : Colors.blue[50],
                    elevation: 5,
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(onPressed: (){
                                      context.pushNamed(AppRouter.depositDetails.name, pathParameters: {'id' : deposits[index].id!});
                                    }, icon: Icon(Icons.read_more, color: Colors.blueAccent[700])),
                                  ),
                                  Expanded(
                                    child: IconButton(onPressed: (){
                                      context.pushNamed(AppRouter.depositUpdate.name, pathParameters: {'id' : deposits[index].id!});
                                    }, icon: Icon(Icons.edit_outlined, color: Colors.amber[800])),
                                  ),
                                  Expanded(
                                    child: IconButton(onPressed: (){
                                      ref.watch(chequeDepositNotifierProvider.notifier).deleteDeposit(deposits[index].id!);
                                    }, icon: const Icon(Icons.delete, color: Colors.red)),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                          TableEntry(content: format.format(deposits[index].depositDate), color: Colors.indigo),
                          TableEntry(content: deposits[index].bankAccountNo, color: Colors.indigo),
                          TableEntry(content: '${deposits[index].chequeNos.length}', color: Colors.indigo),
                          TableEntry(content: '${deposits[index].chequeNos.reduce((value, element) => value + element,)}', color: Colors.indigo),                        
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}