import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yalla_pay/model/customer.dart';
import 'package:yalla_pay/model/invoice.dart';
import 'package:yalla_pay/providers/customer_provider.dart';
import 'package:yalla_pay/providers/invoice_provider.dart';
import 'package:yalla_pay/providers/update_provider.dart';
import 'package:yalla_pay/widgets/styles_details.dart';

class EditInvoiceScreen extends ConsumerStatefulWidget {
  final String id;
  const EditInvoiceScreen({super.key, required this.id});

  @override
  ConsumerState<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends ConsumerState<EditInvoiceScreen> {

  TextStyle labelsStyle (){
    return TextStyle(fontSize: 20, color: Colors.blueGrey[700], fontWeight: FontWeight.bold);
  }

  Invoice? invoice;

  bool hasLoaded = false;
  String amount = '';

  Customer? original;

  Customer? selected;
  List<Customer> customers = [];

  bool validUpdate = false;
  bool validDate= false;
  bool validAmount= false;
  bool sameAmount= true;

  final DateFormat format = DateFormat("yyyy-MM-dd");
  final StylesDetails stylesDetails = StylesDetails();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    customers = ref.watch(customerNotifierProvider);

    if (!hasLoaded){
      invoice = ref.watch(invoiceNotifierProvider.notifier).getInvoiceById(widget.id);
      original = ref.watch(customerNotifierProvider.notifier).getCustomerById(invoice!.customerId);

      selected = original;
      amount = invoice!.amount.toString();
      _invoiceDateController.text = format.format(invoice!.invoiceDate);
      _dueDateController.text = format.format(invoice!.dueDate);

      hasLoaded = true;
    }
    
    if (double.tryParse(amount) == null || amount == ''){
      validAmount= false;
    } else {
      if (double.parse(amount) == invoice!.amount){
        sameAmount = true;
      } else {
        sameAmount= false;
      }
      if (double.parse(amount) <= 0.0){
        validAmount = false;
      } else {
        validAmount = true;
      }
    }

    if ((selected == original && 
    sameAmount &&
    _invoiceDateController.text == format.format(invoice!.invoiceDate) &&
    _dueDateController.text == format.format(invoice!.dueDate)
    ) || !validAmount || !validDate){
      validUpdate = false;
    } else {
      validUpdate = true;
    }    

    if (_dueDateController.text.isNotEmpty && _invoiceDateController.text.isNotEmpty)
    {
      if (DateTime.parse(_dueDateController.text).isBefore(DateTime.parse(_invoiceDateController.text))){
        validDate = false;
      } else {
        validDate = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('E D I T   I N V O I C E', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.grey,),
                      Text('  Customer   ', style: stylesDetails.headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 244, 255),
                      border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(255, 228, 244, 255),
                      ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    width: 200,
                    height: 50,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: selected?.companyName,
                          hint: const Text('Customer...'),
                          isExpanded: true,
                          padding: const EdgeInsets.all(8.0),
                          menuMaxHeight: 200,
                          items: customers.map((e) {
                            return DropdownMenuItem(value: e.companyName,child: Text(e.companyName),);
                          },).toList(), 
                          onChanged: (String? value) 
                          { 
                            setState(() {
                              selected = customers.firstWhere((c) => c.companyName == value);
                            });
                          }, 
                      ),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        initialValue: amount,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: labelsStyle(),
                        ),
                        onChanged: (value) => {
                          setState(() {
                            amount = value;
                          })
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width:200,
                      child: TextField(
                        controller: _invoiceDateController,
                        decoration: const InputDecoration(
                          labelText: 'INVOICE   DATE',
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
                          _selectInvoiceDate();
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width:200,
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 150,),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  if (!validUpdate){
                    return;
                  }

                  ref.read(invoiceNotifierProvider.notifier).updateInvoice(
                  id: invoice!.id,
                  customerId: selected!.id,
                  customerName: selected!.companyName,
                  amount: double.parse(amount),
                  invoiceDate: DateTime.parse(_invoiceDateController.text),
                  dueDate: DateTime.parse(_dueDateController.text),
                );
                ref.read(updateNotifierProvider.notifier).startUpdate();
                context.pop();
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: validUpdate ? const Color.fromARGB(255, 216, 238, 253) : const Color.fromARGB(255, 218, 218, 218),
                elevation: validUpdate ? 5 : 0,
              ),
              child: Text('  U P D A T E  ', 
              style: TextStyle(fontSize: 25, color: validUpdate ? const Color.fromARGB(255, 98, 123, 204) : Colors.black, fontWeight: FontWeight.normal),),),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectInvoiceDate() async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2050)
      );
    
    if (picked != null){
      setState(() {
        _invoiceDateController.text = format.format(picked);
      });
    }
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