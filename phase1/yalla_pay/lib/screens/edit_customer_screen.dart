import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/providers/customer_provider.dart';

class EditCustomerScreen extends ConsumerStatefulWidget {
  final String id;
  const EditCustomerScreen({super.key, required this.id});

  @override
  ConsumerState<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends ConsumerState<EditCustomerScreen> {

  TextStyle labelsStyle (){
    return TextStyle(fontSize: 20, color: Colors.blueGrey[700], fontWeight: FontWeight.bold);
  }

  bool hasLoaded = false;
  String companyName ='', street ='', city ='', country ='', firstName ='', lastName ='', email ='', mobile ='';

  @override
  Widget build(BuildContext context) {
    var customer = ref.read(customerNotifierProvider.notifier).getCustomerById(widget.id);

    if (!hasLoaded){
      companyName = customer.companyName;
      street = customer.address!.street;
      city = customer.address!.city;
      country = customer.address!.country;
      firstName = customer.contactDetails!.firstName;
      lastName = customer.contactDetails!.lastName;
      email = customer.contactDetails!.email;
      mobile = customer.contactDetails!.mobile;
      hasLoaded = true;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('E D I T   C U S T O M E R', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 121, 121, 121)),),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Expanded(
          child: Column(
            children: [
              
              const Divider(),
              const SizedBox(height: 40,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
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
                  const SizedBox(width: 50,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: mobile,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
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
              const SizedBox(height: 100,),
              ElevatedButton(
                onPressed: (){
                  ref.read(customerNotifierProvider.notifier).updateCustomer(
                    id: customer.id,
                    companyName: companyName,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    country: country,
                    city: city,
                    street: street,
                    mobile: mobile,
                  );
                  context.pop();
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 216, 238, 253),
                  elevation: 5,
                ),
                child: const Text('  U P D A T E  ', style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 98, 123, 204), fontWeight: FontWeight.normal),),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}