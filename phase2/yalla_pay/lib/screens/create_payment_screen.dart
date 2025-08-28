import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/model/payment.dart';
import 'package:yalla_pay/providers/banks_provider.dart';
import 'package:yalla_pay/providers/cheque_provider.dart';
import 'package:yalla_pay/providers/payment_mode_provider.dart';
import 'package:yalla_pay/providers/payment_provider.dart';
import 'package:yalla_pay/providers/update_provider.dart';
import 'package:yalla_pay/widgets/styles_details.dart';

class CreatePaymentScreen extends ConsumerStatefulWidget {
  final String invoiceId;
  const CreatePaymentScreen({super.key, required this.invoiceId});

  @override
  ConsumerState<CreatePaymentScreen> createState() => _CreatePaymentState();
}

class _CreatePaymentState extends ConsumerState<CreatePaymentScreen> {

  bool validCreation = false;
  bool validAmount = false;
  bool validDate = false;
  bool isCheque = false;

  final StylesDetails stylesDetails = StylesDetails();
  final DateFormat format = DateFormat('yyyy-MM-dd');
  final TextEditingController _dueDateController = TextEditingController();

  List<String> modes = [];
  List<String> banks = [];
  String? currentOption, bankName, status;
  String amount = '', drawer = '';
  @override
  Widget build(BuildContext context) {

    modes = ref.watch(paymentModeNotifierProvider);
    banks = ref.watch(banksNotifierProvider);

    currentOption == null ? validCreation = false : validCreation = true;

    currentOption == "Cheque" ? isCheque = true : isCheque = false;

    if (double.tryParse(amount) == null || amount == ''){
      validAmount= false;
    } else {
      if (double.parse(amount) <= 0.0){
        validAmount = false;
      } else {
        validAmount = true;
      }
    } 

    if (_dueDateController.text.isNotEmpty)
    {
      if (DateTime.parse(_dueDateController.text).isBefore(DateTime.now())){
        validDate = false;
      } else {
        validDate = true;
      }
    }

    if (isCheque){
      if (!validAmount || !validDate || drawer == '' || bankName == null){
        validCreation = false;
      } else {
        validCreation = true;
      }
    } else {
      if (!validAmount){
        validCreation = false;
      } else {
        validCreation = true;
      }
    }

    
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Text('C R E A T E\nP A Y M E N T', 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 121, 121, 121)),
            ),
            const Divider(),
            const SizedBox(height: 20,),
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
                        const Icon(Icons.monetization_on_outlined, color: Colors.grey,),
                        Text('  Payment Method   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                      ],
                      ),
                      const SizedBox(height: 10,),
                      ...List.generate(modes.length, (index){
                        return Row(
                            children: [
                              Radio(
                              value: modes[index],
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                              Text(modes[index], style: stylesDetails.detailStyle(const Color.fromARGB(255, 122, 122, 122)),),
                            ],
                          ); 
                      })]
                    ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:32.0),
                  child: 
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_outlined, color: Colors.grey,),
                          Text('  Amount   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                        ],
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width:175,
                        child: TextField(
                          decoration: const InputDecoration(
                            filled : true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)
                            )
                          ),
                          onChanged: (value){
                            setState(() {
                              amount = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 90,),
                      
                    ],
                  ),
                ),
            ],),
                const Divider(),
                currentOption == "Cheque" ?
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on_outlined, color: Colors.grey,),
                  Text('  Cheque Details   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                ],
                ) : Container(),
                currentOption == "Cheque" ?
                const SizedBox(height: 10,): const SizedBox(height: 248,),
                currentOption == "Cheque" ?
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:16.0, right:16.0),
                    child: 
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.account_balance_outlined, color: Colors.grey,),
                                Text('  Bank Name   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                              ],
                              ),
                              const SizedBox(height: 20,),
                              
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
                                      value: bankName,
                                      hint: const Text('B A N K'),
                                      isExpanded: true,
                                      padding: const EdgeInsets.all(8.0),
                                      menuMaxHeight: 200,
                                      items: banks.map((e) {
                                        return DropdownMenuItem(value: e,child: Text(e),);
                                      },).toList(), 
                                      onChanged: (String? value) 
                                      { 
                                        setState(() {
                                          bankName = value!;
                                        });
                                      }, 
                                  ),),
                                ),
                              ),

                              const SizedBox(height: 100,),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  const Icon(Icons.person_outline, color: Colors.grey,),
                                  Text('  Drawer   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                                ],
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  width: 175,
                                  child: TextFormField(
                                    initialValue: '', 
                                    style: stylesDetails.detailStyle(const Color.fromARGB(255, 122, 122, 122)), 
                                    
                                  onChanged: (value) {
                                    setState(() {
                                      drawer = value;
                                    });
                                  },),
                                ),
                              const SizedBox(height: 30,),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50,),
                              SizedBox(
                                  width:175,
                                  child: TextField(
                                    controller: _dueDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'DUE   DATE',
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
                                      _selectDueDate();
                                    },
                                  ),
                                ),

                              const SizedBox(height: 100,),

                              ],
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Container(),
                ElevatedButton(
              onPressed: (){
                setState(() {
                  if(!validCreation){
                    return;
                  }

                  Payment payment = Payment(
                    invoiceNo: widget.invoiceId, 
                    amount: double.parse(amount), 
                    paymentDate: format.format(DateTime.now()), 
                    paymentMode: currentOption!); 

                  switch(currentOption){
                    case "Cheque":

                      int random = Random().nextInt(8);
                      random == 0 ? random = 1 : random = random;
                      Cheque cheque = Cheque(
                        amount: double.parse(amount),
                        bankName: bankName!,
                        drawer: drawer,
                        status: "Awaiting",
                        receivedDate: DateTime.now(),
                        dueDate: DateTime.parse(_dueDateController.text),
                        chequeImageUri: 'cheque$random.jpg'
                      );

                      Future<void> chequeNo = ref.read(chequeNotifierProvider.notifier).addCheque(cheque);
                      // payment.chequeNo = chequeNo as int?;

                      ref.read(paymentNotifierProvider.notifier).addPayment(payment);
                    default:
                      ref.read(paymentNotifierProvider.notifier).addPayment(payment);
                  }
                  ref.read(updateNotifierProvider.notifier).startUpdate();

                  context.pop();
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: validCreation ? const Color.fromARGB(255, 216, 238, 253) : const Color.fromARGB(255, 218, 218, 218),
                elevation: validCreation ? 5 : 0,
              ),
              child: Text('  C R E A T E  ', 
              style: TextStyle(
                fontSize: 25, 
                color: validCreation ? const Color.fromARGB(255, 98, 123, 204) : Colors.black, 
                fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2050)
      );
    
    if (picked != null){
      setState(() {
        _dueDateController.text = format.format(picked);
      });
    }
  }
}