import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:yalla_pay/providers/login_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';

class ShellScreen extends ConsumerStatefulWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int selectedIndex = 0;  
  double groupAlignment = -1.0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    // bool login = ref.read(loginNotifierProvider);

    return Scaffold(
      body: Row(
        children: [
          (deviceData.size.width >= 500) ?
          NavigationRail(
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
                switch(value){
                  case 0:
                    context.goNamed(AppRouter.dashboard.name);
                  case 1:
                    context.goNamed(AppRouter.customer.name);
                  case 2:
                    context.goNamed(AppRouter.invoice.name);
                  case 3:
                    context.goNamed(AppRouter.cheque.name);
                  case 4:
                    context.goNamed(AppRouter.deposit.name);
                  }
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Customers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.money),
                label: Text('Invoices'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monetization_on_outlined),
                label: Text('Cheques'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.wallet),
                label: Text('Cheque Deposits'),
              ),
            ],
            labelType: labelType,
            selectedIndex: selectedIndex) : Container(),
            (deviceData.size.width >= 500) ? const VerticalDivider() : Container(), 
          Expanded(child: widget.child),
        ]
        ),
      
      bottomNavigationBar: (deviceData.size.width < 500) ? BottomNavigationBar(
        backgroundColor: Colors.white,

        currentIndex: selectedIndex,
        selectedItemColor: Colors.purple[700], // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items

        onTap: (value){
           setState(() {
           switch(value){
             case 0:
               selectedIndex = value;
               context.goNamed(AppRouter.dashboard.name);
             case 1:
               selectedIndex = value;
               context.goNamed(AppRouter.customer.name);
             case 2:
               selectedIndex = value;
               context.goNamed(AppRouter.invoice.name);
             case 3:
               selectedIndex = value;
               context.goNamed(AppRouter.cheque.name);
             case 4:
               selectedIndex = value;
               context.goNamed(AppRouter.deposit.name);
           }
         });
         },
         items: const [
           BottomNavigationBarItem(
             icon: Icon(Icons.dashboard),
             label: 'Dashboard',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             label: 'Customers',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.money),
             label: 'Invoices',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.monetization_on_outlined),
             label: 'Cheques',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.wallet),
             label: 'Cheque Deposits',
           )
         ],
       ) :  const SizedBox(height: 1),
    );
  }
}
