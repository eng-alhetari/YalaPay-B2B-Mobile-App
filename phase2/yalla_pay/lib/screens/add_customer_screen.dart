import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/model/address.dart';
import 'package:yalla_pay/model/contact_details.dart';
import 'package:yalla_pay/model/customer.dart';
import 'package:yalla_pay/providers/customer_provider.dart';
import 'package:yalla_pay/providers/update_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  TextStyle labelsStyle() {
    return TextStyle(
        fontSize: 20, color: Colors.blueGrey[700], fontWeight: FontWeight.bold);
  }

  bool hasLoaded = false;
  String companyName = '',
      street = '',
      city = '',
      country = '',
      firstName = '',
      lastName = '',
      email = '',
      mobile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'N E W   C U S T O M E R',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Expanded(
          child: Column(
            children: [
              const Divider(),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: companyName,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              companyName = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: country,
                          decoration: InputDecoration(
                            labelText: 'Country',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              country = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: city,
                          decoration: InputDecoration(
                            labelText: 'City',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              city = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: street,
                          decoration: InputDecoration(
                            labelText: 'Street',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              street = value;
                            })
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: firstName,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              firstName = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: lastName,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              lastName = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              email = value;
                            })
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: email,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: labelsStyle(),
                          ),
                          onChanged: (value) => {
                            setState(() {
                              mobile = value;
                            })
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ref.read(customerNotifierProvider.notifier).addCustomer(
                        // TODO Faisal: there should be an ID here, no idea what to put so i put it blank
                        Customer(
                            id: "",
                            companyName: companyName,
                            address: Address(
                                city: city, country: country, street: street),
                            contactDetails: ContactDetails(
                                email: email,
                                firstName: firstName,
                                lastName: lastName,
                                mobile: mobile)));
                    ref.read(updateNotifierProvider.notifier).startUpdate();
                    context.goNamed(AppRouter.customer.name);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 12, 14, 15),
                  elevation: 5,
                ),
                child: const Text(
                  '  C R E A T E  ',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 98, 123, 204),
                      fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
