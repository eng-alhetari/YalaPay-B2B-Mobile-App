import 'package:go_router/go_router.dart';
import 'package:yalla_pay/screens/add_customer_screen.dart';
import 'package:yalla_pay/screens/add_invoice_screen.dart';
import 'package:yalla_pay/screens/cheque_awaiting_screen.dart';
import 'package:yalla_pay/screens/cheque_details_screen.dart';
import 'package:yalla_pay/screens/cheques_report_screen.dart';
import 'package:yalla_pay/screens/create_payment_screen.dart';
import 'package:yalla_pay/screens/customer_screen.dart';
import 'package:yalla_pay/screens/dashboard_screen.dart';
import 'package:yalla_pay/screens/deposit_details_screen.dart';
import 'package:yalla_pay/screens/deposit_screen.dart';
import 'package:yalla_pay/screens/deposit_update_screen.dart';
import 'package:yalla_pay/screens/edit_customer_screen.dart';
import 'package:yalla_pay/screens/edit_invoice_screen.dart';
import 'package:yalla_pay/screens/edit_payment_screen.dart';
import 'package:yalla_pay/screens/invoice_screen.dart';
import 'package:yalla_pay/screens/invoices_report_screen.dart';
import 'package:yalla_pay/screens/login.dart';
import 'package:yalla_pay/screens/payment_screen.dart';
import 'package:yalla_pay/screens/shell_screen.dart';

class AppRouter {
  static const login = (name: 'login', path: '/');
  static const dashboard = (name: 'dashboard', path: '/dashboard');
  static const invoicesReport = (name: 'invoices-report', path: 'invoices-report'); // Relative path
  static const chequesReport = (name: 'cheques-report', path: 'cheques-report'); // Relative path

  static const customer = (name: 'customers', path: 'customers'); // Relative path
  static const editCust = (name: 'edit-customer', path: 'edit/:id'); // Relative path
  static const newCust = (name: 'new-customer', path: 'new'); // Relative path

  static const invoice = (name: 'invoices', path: 'invoices'); // Relative path
  static const editInvoice = (name: 'edit-invoice', path: 'edit/:id'); // Relative path
  static const newInvoice = (name: 'new-invoice', path: 'new'); // Relative path

  static const payment = (name: 'payments', path: 'payments/:id'); // Relative path
  static const newPayment = (name: 'new-payment', path: 'new-payment/:invoiceId'); // Relative path
  static const editPayment = (name: 'edit-payment', path: 'edit-payment/:paymentId'); // Relative path

  static const cheque = (name: 'cheques', path: 'cheques'); // Relative path
  static const chequeDetails = (name: 'cheque-details', path: 'details/:id'); // Relative path

  static const deposit = (name: 'deposits', path: 'deposits'); // Relative path
  static const depositDetails = (name: 'deposit-details', path: 'details/:id'); // Relative path
  static const depositUpdate = (name: 'deposit-update', path: 'update/:id'); // Relative path

  static final router = GoRouter(
    initialLocation: login.path,
    routes: [
      GoRoute(
        name: login.name,
        path: login.path,
        builder: (context, state) =>  Login(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            name: dashboard.name,
            path: dashboard.path,
            builder: (context, state) => const DashbordScreen(),
            routes: [
              GoRoute(
                name: invoicesReport.name,
                path: invoicesReport.path,
                builder: (context, state) => const InvoicesReportScreen(),
              ),
              GoRoute(
                name: chequesReport.name,
                path: chequesReport.path,
                builder: (context, state) => const ChequesReportScreen(),
              ),
              GoRoute(
                name: customer.name,
                path: customer.path,
                builder: (context, state) => const CustomerScreen(),
                routes: [
                  GoRoute(
                    name: newCust.name,
                    path: newCust.path,
                    builder: (context, state) => const AddCustomerScreen(),
                  ),
                  GoRoute(
                    name: editCust.name,
                    path: editCust.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return EditCustomerScreen(id: id!);
                    },
                  ),
                ],
              ),
              GoRoute(
                name: invoice.name,
                path: invoice.path,
                builder: (context, state) => const InvoiceScreen(),
                routes: [
                  GoRoute(
                    name: newInvoice.name,
                    path: newInvoice.path,
                    builder: (context, state) => const AddInvoiceScreen(),
                  ),
                  GoRoute(
                    name: editInvoice.name,
                    path: editInvoice.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return EditInvoiceScreen(id: id!);
                    },
                  ),
                  GoRoute(
                    name: payment.name,
                    path: payment.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return PaymentScreen(id: id!);
                    },
                    routes: [
                      GoRoute(
                        name: newPayment.name,
                        path: newPayment.path,
                        builder: (context, state) {
                          String? id = state.pathParameters['invoiceId'];
                          return CreatePaymentScreen(invoiceId: id!);
                        },
                      ),
                      GoRoute(
                        name: editPayment.name,
                        path: editPayment.path,
                        builder: (context, state) {
                          String? id = state.pathParameters['paymentId'];
                          return UpdatePaymentScreen(paymentId: id!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                name: cheque.name,
                path: cheque.path,
                builder: (context, state) => const ChequeScreen(),
                routes: [
                  GoRoute(
                    name: chequeDetails.name,
                    path: chequeDetails.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return ChequeDetailsScreen(id: int.parse(id!));
                    },
                  ),
                ],
              ),
              GoRoute(
                name: deposit.name,
                path: deposit.path,
                builder: (context, state) => const DepositScreen(),
                routes: [
                  GoRoute(
                    name: depositDetails.name,
                    path: depositDetails.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return DepositDetailsScreen(id: id!);
                    },
                  ),
                  GoRoute(
                    name: depositUpdate.name,
                    path: depositUpdate.path,
                    builder: (context, state) {
                      String? id = state.pathParameters['id'];
                      return DepositUpdateScreen(id: id!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
