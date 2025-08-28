import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/providers/cheque_deposit_provider.dart';
import 'package:yalla_pay/providers/cheque_provider.dart';
import 'package:yalla_pay/providers/deposit_status_provider.dart';
import 'package:yalla_pay/providers/return_reasons_provider.dart';
import 'package:yalla_pay/widgets/styles_details.dart';

class DepositUpdateScreen extends ConsumerStatefulWidget {
  final String id;
  const DepositUpdateScreen({super.key, required this.id});


  @override
  ConsumerState<DepositUpdateScreen> createState() => _DepositUpdateScreenState();
}

class _DepositUpdateScreenState extends ConsumerState<DepositUpdateScreen> {

StylesDetails stylesDetails = StylesDetails();

  final DateFormat format = DateFormat("yyyy-MM-dd");
  final TextEditingController _dateController = TextEditingController();
  
  List<Cheque> cheques = [];
  List<ChequeDeposit> deposits = [];
  List<Cheque> loadedCheques = [];
  List<String> depositStatus = [];
  List<String> returnReasons = [];
  bool validUpdate = false;

  String currentOption = '';

  List<String> selectedReasons = [];

  @override
  Widget build(BuildContext context) {
    deposits = ref.watch(chequeDepositNotifierProvider);
    cheques = ref.watch(chequeNotifierProvider);
    depositStatus = ref.watch(depositStatusNotifierProvider);
    returnReasons = ref.watch(returnReasonsNotifierProvider);

    ChequeDeposit deposit = deposits.firstWhere((d) => d.id == widget.id);
    
    if(currentOption == ''){
      currentOption = deposit.status;
    }

    if (selectedReasons.isEmpty && currentOption == "Cashed with Returns"){
      for (int chequeNo in deposit.chequeNos){
        loadedCheques.add(cheques.firstWhere((e) => e.chequeNo == chequeNo));
        selectedReasons.add('');
      }
    }

    if (currentOption == deposit.status){
      validUpdate = false;
    }

    if (currentOption == "Cashed with Returns"){
      for (var e in selectedReasons) {
        e.isNotEmpty ? validUpdate = true : validUpdate = validUpdate;
      }
      _dateController.text.isEmpty ? validUpdate = false : validUpdate = validUpdate;
    }

    if (currentOption == "Cashed"){
      _dateController.text.isEmpty ? validUpdate = false : validUpdate = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('U P D A T E   D E P O S I T', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),
              ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const Divider(),
              const SizedBox(height: 20,),
              Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...stylesDetails.headingDetailEntry(heading: 'Account Number', detail: deposit.bankAccountNo, icon: const Icon(Icons.numbers, color: Colors.grey,)),
                        ...stylesDetails.headingDetailEntry(heading: 'Deposit Date', detail: format.format(deposit.depositDate), icon: const Icon(Icons.calendar_month_outlined, color: Colors.grey,)),
                      ],
                    ),
                  ),
                  Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline, color: Colors.grey,),
                                    Text('  Status   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                                  ],
                                  ),
                                  const SizedBox(height: 10,),
                                  ...List.generate(depositStatus.length, (index){
                                    return Row(
                                        children: [
                                          Radio(
                                          value: depositStatus[index],
                                          groupValue: currentOption,
                                          onChanged: (value) {
                                            setState(() {
                                              currentOption = value.toString();
                                            });
                                          },
                                        ),
                                          Text(depositStatus[index], style: stylesDetails.detailStyle(const Color.fromARGB(255, 122, 122, 122)),),
                                        ],
                                      ); 
                                  })]
                                ,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:32.0),
                              child: currentOption == "Cashed" || currentOption == "Cashed with Returns" ? 
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.calendar_month_outlined, color: Colors.grey,),
                                      Text('  Cashed Date   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                                    ],
                                    ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width:175,
                                    child: TextField(
                                      controller: _dateController,
                                      decoration: const InputDecoration(
                                        labelText: 'DATE',
                                        filled: true,
                                        prefixIcon: Icon(Icons.calendar_today),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue)
                                        )
                                      ),
                                      readOnly: true,
                                      onTap: () {
                                        _selectDate();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 90,),
                                  
                                ],
                              ) : Container(),
                            ),
                        ],),
                  const Divider(),
                  currentOption == "Cashed with Returns" ?
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on_outlined, color: Colors.grey,),
                    Text('  Cheques   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                  ],
                  ) : Container(),
                  currentOption == "Cashed with Returns" ?
                  const SizedBox(height: 10,): const SizedBox(height: 248,),
                  currentOption == "Cashed with Returns" ?
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:16.0, right:16.0),
                      child: ListView.builder(
                        itemCount: loadedCheques.length,
                        itemBuilder: (context, index) {
                      
                          var depositCheque = loadedCheques[index];
                      
                          return Card(
                            elevation: 0,
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 201, 232, 253),
                                            border: Border.all(
                                              width: 5,
                                              color: const Color.fromARGB(255, 201, 232, 253),
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                          ),
                                          width: 175,
                                          height: 50,
                                          child: DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton<String>(
                                                value: selectedReasons[index] == '' ? null : selectedReasons[index],
                                                hint: const Text('Reason...'),
                                                isExpanded: true,
                                                padding: const EdgeInsets.all(8.0),
                                                menuMaxHeight: 200,
                                                items: returnReasons.map((e) {
                                                  return DropdownMenuItem(value: e,child: Text(e),);
                                                },).toList(), 
                                                onChanged: (String? value) 
                                                { 
                                                  setState(() {
                                                    selectedReasons[index] = value!;
                                                  });
                                                }, 
                                            ),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ) : Container(),
                  ElevatedButton(
                onPressed: (){
                  setState(() {
                    if (!validUpdate){
                      return;
                    }
                    print('entered $currentOption');
                    for (var c in loadedCheques){
                      if ((currentOption == "Cashed with Returns" && selectedReasons[loadedCheques.indexOf(c)].isEmpty)
                        || currentOption == "Cashed"){
                        print(currentOption);
                        ref.watch(chequeNotifierProvider.notifier).updateChequeStatus(c.chequeNo!, "Cashed");
                        ref.watch(chequeNotifierProvider.notifier).updateChequeCashedDate(c.chequeNo!, DateTime.parse(_dateController.text));
                      }
                      print('outside $currentOption');
                      
                      if (currentOption == "Cashed with Returns" && selectedReasons[loadedCheques.indexOf(c)].isNotEmpty){
                        ref.watch(chequeNotifierProvider.notifier).updateChequeStatus(c.chequeNo!, "Returned");
                        ref.watch(chequeNotifierProvider.notifier).updateChequeReturnReason(c.chequeNo!, selectedReasons[loadedCheques.indexOf(c)]);
                      }      
                    }
      
                    ref.read(chequeDepositNotifierProvider.notifier).updateDepositStatus(deposit.id!, currentOption);
                    ref.read(chequeDepositNotifierProvider.notifier).updateDepositCashedDate(deposit.id!, DateTime.parse(_dateController.text));
                    context.pop();
                  });
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: validUpdate ? const Color.fromARGB(255, 216, 238, 253) : const Color.fromARGB(255, 218, 218, 218),
                  elevation: validUpdate ? 5 : 0,
                ),
                child: Text('  U P D A T E  ', 
                style: TextStyle(
                  fontSize: 25, 
                  color: validUpdate ? const Color.fromARGB(255, 98, 123, 204) : Colors.black, 
                  fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2050)
      );
    
    if (picked != null){
      setState(() {
        _dateController.text = format.format(picked);
      });
    }
  }
}