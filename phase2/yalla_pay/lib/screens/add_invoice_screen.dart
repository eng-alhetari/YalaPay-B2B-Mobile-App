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

class AddInvoiceScreen extends ConsumerStatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  ConsumerState<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends ConsumerState<AddInvoiceScreen> {
  TextStyle labelsStyle() {
    return TextStyle(
        fontSize: 20, color: Colors.blueGrey[700], fontWeight: FontWeight.bold);
  }

  String amount = '';

  // List<Customer> customers = [];
  Customer? selected;
  bool validCreation = false;
  bool validDate = false;
  bool validAmount = false;
  final DateFormat format = DateFormat("yyyy-MM-dd");
  final StylesDetails stylesDetails = StylesDetails();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerNotifierProvider);

    if (selected == null ||
        amount == '' ||
        !validAmount ||
        _dueDateController.text.isEmpty ||
        _invoiceDateController.text.isEmpty ||
        !validDate) {
      validCreation = false;
    } else {
      validCreation = true;
    }

    if (double.tryParse(amount) == null) {
      validAmount = false;
    } else {
      if (double.parse(amount) <= 0.0) {
        validAmount = false;
      } else {
        validAmount = true;
      }
    }

    if (_dueDateController.text.isNotEmpty &&
        _invoiceDateController.text.isNotEmpty) {
      if (DateTime.parse(_dueDateController.text)
          .isBefore(DateTime.parse(_invoiceDateController.text))) {
        validDate = false;
      } else {
        validDate = true;
      }
    }

    return customers.when(
      data: (customers) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'N E W   I N V O I C E',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: [
              const Divider(),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                  Text(
                    '  Customer   ',
                    style: stylesDetails
                        .headingStyle(const Color.fromARGB(255, 122, 122, 122)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 228, 244, 255),
                    border: Border.all(
                      width: 5,
                      color: const Color.fromARGB(255, 228, 244, 255),
                    ),
                    borderRadius: BorderRadius.circular(50)),
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
                      items: customers.map(
                        (e) {
                          return DropdownMenuItem(
                            value: e.companyName,
                            child: Text(e.companyName),
                          );
                        },
                      ).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selected = customers
                              .firstWhere((c) => c.companyName == value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _invoiceDateController,
                  decoration: const InputDecoration(
                      labelText: 'INVOICE   DATE',
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                  readOnly: true,
                  onTap: () {
                    _selectInvoiceDate();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(
                      labelText: 'DUE   DATE',
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                  readOnly: true,
                  onTap: () {
                    _selectDueDate();
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (!validCreation) {
                      return;
                    }

                    ref.read(invoiceNotifierProvider.notifier).addInvoice(
                        Invoice(
                            customerId: selected!.id,
                            customerName: selected!.companyName,
                            amount: double.parse(amount),
                            invoiceDate:
                                DateTime.parse(_invoiceDateController.text),
                            dueDate: DateTime.parse(_dueDateController.text))
                        // customerName: selected!.companyName,
                        // customerId: selected!.id,
                        // amount: double.parse(amount),
                        // invoiceDate:
                        //     DateTime.parse(_invoiceDateController.text),
                        // dueDate: DateTime.parse(_dueDateController.text),
                        );
                    ref.read(updateNotifierProvider.notifier).startUpdate();
                    context.pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: validCreation
                      ? const Color.fromARGB(255, 216, 238, 253)
                      : const Color.fromARGB(255, 218, 218, 218),
                  elevation: validCreation ? 5 : 0,
                ),
                child: Text(
                  '  C R E A T E  ',
                  style: TextStyle(
                      fontSize: 25,
                      color: validCreation
                          ? const Color.fromARGB(255, 98, 123, 204)
                          : Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
      error: (Object error, StackTrace stackTrace) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
    );
  }

  Future<void> _selectInvoiceDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (picked != null) {
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
        lastDate: DateTime(2050));

    if (picked != null) {
      setState(() {
        _dueDateController.text = format.format(picked);
      });
    }
  }
}
