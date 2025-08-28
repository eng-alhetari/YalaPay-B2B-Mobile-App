import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/invoice.dart';
import 'package:yalla_pay/model/payment.dart';
import 'package:yalla_pay/providers/invoice_provider.dart';
import 'package:yalla_pay/providers/invoice_status_provider.dart';
import 'package:yalla_pay/providers/payment_provider.dart';
import 'package:yalla_pay/widgets/styles_details.dart';

class InvoicesReportScreen extends ConsumerStatefulWidget {
  const InvoicesReportScreen({super.key});

  @override
  ConsumerState<InvoicesReportScreen> createState() => _InvoicesReportScreenState();
}

class _InvoicesReportScreenState extends ConsumerState<InvoicesReportScreen> {

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  final StylesDetails stylesDetails = StylesDetails();
  final DateFormat format = DateFormat('yyyy-MM-dd');

  final List<Color?> colors = [
    Colors.red[900],
    Colors.green[900],
    Colors.blue[900],
  ];

  bool validReport = false;



  List<String> invoiceStatuses = [];
  List<Invoice> invoices = [];
  List<Payment> payments = [];
  List<Invoice> filteredInvoices = [];
  String currentOption = "All";
  String selectedOption = "";
  double totalAmount = 0;
  double grandTotal = 0;
  int count = 0;
  int pickedColor = 3; //3 for entering screen
  

  @override
  Widget build(BuildContext context) {
    invoiceStatuses = ref.watch(invoiceStatusNotifierProvider);
    invoices = ref.watch(invoiceNotifierProvider);
    payments = ref.watch(paymentNotifierProvider);

    if (_fromDateController.text.isNotEmpty && _toDateController.text.isNotEmpty){
      if (DateTime.parse(_fromDateController.text).isAfter(DateTime.parse(_toDateController.text))){
        validReport = false;
      } else {
        validReport = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('I N V O I C E S   R E P O R T', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),
                ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Divider(),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:175,
                  child: TextField(
                    controller: _fromDateController,
                    decoration: const InputDecoration(
                      labelText: 'FROM   DATE',
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
                      _selectDate(_fromDateController);
                    },
                  ),
                ),
                const SizedBox(width: 50,),
                SizedBox(
                  width:175,
                  child: TextField(
                    controller: _toDateController,
                    decoration: const InputDecoration(
                      labelText: 'TO   DATE',
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
                      _selectDate(_toDateController);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              children: [
                const SizedBox( width: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                              const Icon(Icons.check_circle_outline, color: Colors.grey,),
                              Text('  Status   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                              ],
                      ),
                      Row(
                            children: [
                              Radio(
                              value: 'All',
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                              Text('All', style: stylesDetails.detailStyle(const Color.fromARGB(255, 122, 122, 122)),),
                            ],
                          ),
                    ...List.generate(invoiceStatuses.length, (index){
                        return Row(
                            children: [
                              Radio(
                              value: invoiceStatuses[index],
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                              Text(invoiceStatuses[index], style: stylesDetails.detailStyle(colors[index]!),),
                            ],
                          ); 
                      })
                  ],
                ),
                const SizedBox(width: 100,),
                Column(
                  children: [
                    const SizedBox(height: 175,),
                    ElevatedButton(
                    onPressed: (){
                    setState(() {
                      if (!validReport){
                        return;
                      }

                      selectedOption = currentOption;

                      for (var invoice in invoices){
                          var temp = payments.where((e) => e.invoiceNo == invoice.id).toList();
                          if (temp.isNotEmpty){
                            if (invoice.amount - temp.map((e) => e.amount,).reduce((a,b) => a+b) <= 0){
                              ref.read(invoiceNotifierProvider.notifier).updateInvoiceStatus(invoice.id!, "Paid");
                            } else {
                               ref.read(invoiceNotifierProvider.notifier).updateInvoiceStatus(invoice.id!, "Partially Paid");
                            }
                          } else {
                            ref.read(invoiceNotifierProvider.notifier).updateInvoiceStatus(invoice.id!, "Unpaid");
                          }
                        }

                      if (selectedOption != "All"){
                        pickedColor = invoiceStatuses.indexOf(selectedOption);
                        filteredInvoices = invoices.where((c) => c.status == currentOption).toList();
                        if (filteredInvoices.isNotEmpty){
                          totalAmount = filteredInvoices.map((e) => e.amount,).reduce((a, b) => a+b);
                        } else{
                          totalAmount = 0.0;
                        }
                        
                        count = filteredInvoices.length;  
                      } else {
                        filteredInvoices = invoices;
                        grandTotal = filteredInvoices.map((e) => e.amount).reduce((a,b) => a + b);
                      }
                      

                    });
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: validReport ? const Color.fromARGB(255, 216, 238, 253) : const Color.fromARGB(255, 218, 218, 218),
                      elevation: validReport ? 5 : 0,
                    ),
                    child: Text('  G E T  ', 
                    style: TextStyle(fontSize: 25, color: validReport ? const Color.fromARGB(255, 98, 123, 204) : Colors.black, fontWeight: FontWeight.normal),),),
                  ],
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.grey, size: 40,),
                Text('  Total   ', style: stylesDetails.largerHeadingStyle(const Color.fromARGB(255, 122, 122, 122)),),
             ],
            ),
            const SizedBox(height: 10,),
            selectedOption != "All" ?
            Column(
              children: [
                Container(
                decoration: BoxDecoration(
                color: pickedColor != 3 ? colors[pickedColor]! : Colors.black,
                border: Border.all(
                  width: 5.0,
                  color: pickedColor != 3 ? colors[pickedColor]! : Colors.black,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('  QR ${totalAmount.toStringAsFixed(2)}  ', style: stylesDetails.largerDetailStyle(Colors.white),)
              ),
              const SizedBox(height: 40,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.grey, size: 40,),
                Text('  Count   ', style: stylesDetails.largerHeadingStyle(const Color.fromARGB(255, 122, 122, 122)),),
             ],
            ),
            const SizedBox(height: 10,),
            
            Container(
              decoration: BoxDecoration(
                color: pickedColor != 3 ? colors[pickedColor]! : Colors.black,
                border: Border.all(
                  width: 5.0,
                  color: pickedColor != 3 ? colors[pickedColor]! : Colors.black,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('        $count        ', style: stylesDetails.largerDetailStyle(Colors.white),)
              ),
              ],
            ) : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(colors.length, (index){
                      double thisTotal = 0.0;
                      if (filteredInvoices.where((e) => e.status == invoiceStatuses[index]).isNotEmpty){
                        thisTotal = filteredInvoices.where((e) => e.status == invoiceStatuses[index]).map((e) => e.amount,).reduce((a, b) => a+b);
                      }
                      return Container(
                          decoration: BoxDecoration(
                          color: colors[index]!,
                          border: Border.all(
                            width: 5.0,
                            color: colors[index]!,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(' QR ${thisTotal.toStringAsFixed(2)} ', style: stylesDetails.detailStyle(Colors.white),)
                      );
                    })
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.numbers, color: Colors.grey, size: 40,),
                    Text('  Count   ', style: stylesDetails.largerHeadingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                 ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(colors.length, (index){
                      int thisCount = filteredInvoices.where((e) => e.status == invoiceStatuses[index]).length;
                      return Container(
                        decoration: BoxDecoration(
                          color: colors[index]!,
                          border: Border.all(
                            width: 5.0,
                            color: colors[index]!,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('        $thisCount        ', style: stylesDetails.detailStyle(Colors.white),)
                      );
                    })
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on_outlined, color: Colors.grey, size: 40,),
                    Text('  Grand Total   ', style: stylesDetails.largerHeadingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                    width: 5.0,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('  QR ${grandTotal.toStringAsFixed(2)}  ', style: stylesDetails.largerDetailStyle(Colors.white),)
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Expanded(
                  child: Text('Note: Results are color coded! Refer to the status colors.', 
                          style: stylesDetails.detailStyle(const Color.fromARGB(255, 122, 122, 122)),
                      textAlign: TextAlign.center,
                  )
                ),
            )
              ],
            ),
            
          ],
        ),
      ));
  }
  
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2050)
      );
    
    if (picked != null){
      setState(() {
        controller.text = format.format(picked);
      });
    }
  }
}