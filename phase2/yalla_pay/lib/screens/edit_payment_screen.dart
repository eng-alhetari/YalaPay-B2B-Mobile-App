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

class UpdatePaymentScreen extends ConsumerStatefulWidget {
  final String paymentId;
  const UpdatePaymentScreen({super.key, required this.paymentId});

  @override
  ConsumerState<UpdatePaymentScreen> createState() => _UpdatePaymentState();
}

class _UpdatePaymentState extends ConsumerState<UpdatePaymentScreen> {
  bool validUpdate = false;
  bool validAmount = false;
  bool sameAmount = true;
  bool validDate = false;
  bool isCheque = false;
  bool hasLoaded = false;

  final StylesDetails stylesDetails = StylesDetails();
  final DateFormat format = DateFormat('yyyy-MM-dd');
  final TextEditingController _dueDateController = TextEditingController();

  List<String> modes = [];
  List<String> banks = [];
  List<Payment> payments = [];
  List<Cheque> cheques = [];

  Payment? payment;
  Cheque? cheque;

  String? currentOption, bankName;
  String amount = '', drawer = '';

  @override
  Widget build(BuildContext context) {
    modes = ref.watch(paymentModeNotifierProvider);
    banks = ref.watch(banksNotifierProvider);
    final payments = ref.watch(paymentNotifierProvider);
    final cheques = ref.watch(chequeNotifierProvider);

    if (!hasLoaded) {
      payment = payments.value!.firstWhere((p) =>
          p.id ==
          widget.paymentId); // NOTE : USING .value! might cause loading issues

      amount = payment!.amount.toStringAsFixed(1);
      currentOption = payment!.paymentMode;

      if (payment!.paymentMode == "Cheque") {
        cheque = cheques.value!.firstWhere((c) =>
            c.chequeNo ==
            payment!
                .chequeNo); // NOTE : UJING .value! might cause loading issues

        drawer = cheque!.drawer;
        bankName = cheque!.bankName;
        _dueDateController.text = format.format(cheque!.dueDate);
      }
      hasLoaded = true;
    }

    currentOption == "Cheque" ? isCheque = true : isCheque = false;

    if (double.tryParse(amount) == null || amount == '') {
      validAmount = false;
    } else {
      if (double.parse(amount) == payment!.amount) {
        sameAmount = true;
      } else {
        sameAmount = false;
      }
      if (double.parse(amount) <= 0.0) {
        validAmount = false;
      } else {
        validAmount = true;
      }
    }
    if (isCheque) {
      if (DateTime.parse(_dueDateController.text).isBefore(DateTime.now())) {
        validDate = false;
      } else {
        validDate = true;
      }
    }

    if (isCheque) {
      if (!validAmount ||
          !validDate ||
          drawer == '' ||
          (drawer == cheque!.drawer &&
              _dueDateController.text == format.format(cheque!.dueDate) &&
              sameAmount &&
              bankName == cheque!.bankName)) {
        validUpdate = false;
      } else {
        validUpdate = true;
      }
    } else {
      if (!validAmount || sameAmount) {
        validUpdate = false;
      } else {
        validUpdate = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'U P D A T E   P A Y M E N T',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...stylesDetails.headingDetailEntry(
                            heading: "Payment Method",
                            detail: currentOption!,
                            icon: const Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.grey,
                            )),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.grey,
                            ),
                            Text(
                              '  Amount   ',
                              style: stylesDetails.headingStyle(
                                  const Color.fromARGB(255, 122, 122, 122)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 175,
                          child: TextFormField(
                            initialValue: amount,
                            decoration: const InputDecoration(
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              currentOption == "Cheque"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '  Cheque Details   ',
                          style: stylesDetails.headingStyle(
                              const Color.fromARGB(255, 122, 122, 122)),
                        ),
                      ],
                    )
                  : Container(),
              currentOption == "Cheque"
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(
                      height: 248,
                    ),
              currentOption == "Cheque"
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.account_balance_outlined,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        '  Bank Name   ',
                                        style: stylesDetails.headingStyle(
                                            const Color.fromARGB(
                                                255, 122, 122, 122)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 201, 232, 253),
                                        border: Border.all(
                                          width: 5,
                                          color: const Color.fromARGB(
                                              255, 201, 232, 253),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                          items: banks.map(
                                            (e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              bankName = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        '  Drawer   ',
                                        style: stylesDetails.headingStyle(
                                            const Color.fromARGB(
                                                255, 122, 122, 122)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 175,
                                    child: TextFormField(
                                      initialValue: drawer,
                                      style: stylesDetails.detailStyle(
                                          const Color.fromARGB(
                                              255, 122, 122, 122)),
                                      onChanged: (value) {
                                        setState(() {
                                          drawer = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  SizedBox(
                                    width: 175,
                                    child: TextField(
                                      controller: _dueDateController,
                                      decoration: const InputDecoration(
                                          labelText: 'DUE   DATE',
                                          filled: true,
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue))),
                                      readOnly: true,
                                      onTap: () {
                                        _selectDueDate();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (!validUpdate) {
                      return;
                    }

                    payment!.amount = double.parse(amount);

                    switch (payment!.paymentMode) {
                      case "Cheque":
                        cheque!.amount = double.parse(amount);
                        cheque!.dueDate =
                            DateTime.parse(_dueDateController.text);
                        cheque!.drawer = drawer;
                        cheque!.bankName = bankName!;

                        ref
                            .read(chequeNotifierProvider.notifier)
                            .updateChequeDetails(cheque!);
                        ref
                            .read(paymentNotifierProvider.notifier)
                            .updatePayment(payment!);
                      default:
                        ref
                            .read(paymentNotifierProvider.notifier)
                            .updatePayment(payment!);
                    }
                    ref.read(updateNotifierProvider.notifier).startUpdate();

                    context.pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: validUpdate
                      ? const Color.fromARGB(255, 216, 238, 253)
                      : const Color.fromARGB(255, 218, 218, 218),
                  elevation: validUpdate ? 5 : 0,
                ),
                child: Text(
                  '  U P D A T E  ',
                  style: TextStyle(
                      fontSize: 25,
                      color: validUpdate
                          ? const Color.fromARGB(255, 98, 123, 204)
                          : Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
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
