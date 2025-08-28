import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/providers/invoice_provider.dart';
import 'package:yalla_pay/providers/update_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  String searchText = '';
  var filteredInvoices = [];
  bool hasLoaded = false;
  @override
  Widget build(BuildContext context) {
    var invoices = ref.watch(invoiceNotifierProvider);

    return invoices.when(
      data: (invoices) {
        if (invoices.isNotEmpty && !hasLoaded) {
          filteredInvoices = invoices;
          hasLoaded = true;
        }

        if (ref.watch(updateNotifierProvider)) {
          filteredInvoices = invoices;
        }

        if (searchText.isNotEmpty) {
          filteredInvoices = invoices
              .where((e) => e.customerName
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
                  'I N V O I C E S',
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
                          filteredInvoices = invoices;
                        }
                        searchText = value;
                        filteredInvoices = invoices
                            .where((e) => e.customerName
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                            .toList();
                      });
                    },
                  )),
              Expanded(
                child: invoices.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.money,
                            size: 300,
                            color: Color.fromARGB(255, 197, 197, 197),
                          ),
                          Text(
                            'Looks like there are no invoices, add some!',
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
                        itemCount: filteredInvoices.length,
                        itemBuilder: (context, index) {
                          final invoice = filteredInvoices[index];
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRouter.payment.name,
                                  pathParameters: {'id': invoice.id});
                            },
                            child: Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.money,
                                  color: Colors.grey,
                                ),
                                title: Text(invoice.customerName),
                                subtitle: Text(
                                    'QR ${invoice.amount.toStringAsFixed(2)}'),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context.pushNamed(
                                                AppRouter.editInvoice.name,
                                                pathParameters: {
                                                  'id': invoice.id
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue[800],
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            ref
                                                .read(invoiceNotifierProvider
                                                    .notifier)
                                                .deleteInvoice(invoice.id);
                                            setState(() {
                                              filteredInvoices = invoices;
                                         /* NOTE : here was "ref.watch(invoiceNotifierProvider)" and i replaced it with invoices dont know if it will work*/

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
                  context.pushNamed(AppRouter.newInvoice.name);
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
