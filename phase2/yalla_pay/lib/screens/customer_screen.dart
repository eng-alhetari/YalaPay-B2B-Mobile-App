import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/providers/customer_provider.dart';
import 'package:yalla_pay/providers/update_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  String searchText = '';
  var filteredCustomers = [];
  bool hasLoaded = false;
  @override
  Widget build(BuildContext context) {
    var customers = ref.watch(customerNotifierProvider);

    return customers.when(
      data: (customers) {
        if (customers.isNotEmpty && !hasLoaded) {
          filteredCustomers = customers;
          hasLoaded = true;
        }

        if (ref.watch(updateNotifierProvider)) {
          filteredCustomers = customers;
        }

        if (searchText.isNotEmpty) {
          filteredCustomers = customers
              .where((e) => e.companyName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
        }

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 15),
                child: Text(
                  'C U S T O M E R S',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40, color: Color.fromARGB(255, 121, 121, 121)),
                ),
              ),
              const Divider(),
              SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.search), labelText: 'S E A R C H'),
                    onChanged: (value) {
                      setState(() {
                        if (value.length < searchText.length) {
                          filteredCustomers = customers;
                        }
                        searchText = value;
                        filteredCustomers = customers
                            .where((e) => e.companyName
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                            .toList();
                      });
                    },
                  )),
              Expanded(
                child: customers.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 300,
                            color: Color.fromARGB(255, 197, 197, 197),
                          ),
                          Text(
                            'Looks like there are no customers, add some!',
                            style: TextStyle(
                                color: Color.fromARGB(255, 197, 197, 197),
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                title:
                                    Text(filteredCustomers[index].companyName),
                                subtitle: Text(
                                  filteredCustomers[index]
                                      .contactDetails!
                                      .email,
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context.pushNamed(
                                                AppRouter.editCust.name,
                                                pathParameters: {
                                                  'id': filteredCustomers[index]
                                                      .id
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue[800],
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            ref
                                                .read(customerNotifierProvider
                                                    .notifier)
                                                .deleteCustomer(
                                                    filteredCustomers[index]
                                                        .id);
                                            setState(() {
                                              filteredCustomers = customers;
                                              /* NOTE : here was "ref.watch(customerNotifierProvider)" and i replaced it with customers dont know if it will work*/
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(AppRouter.newCust.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 216, 238, 253),
                  elevation: 5,
                ),
                child: const Icon(Icons.add,
                    color: Color.fromARGB(255, 98, 123, 204), size: 50),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) => Text("Error $error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
