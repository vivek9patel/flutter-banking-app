import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerTile extends StatefulWidget {
  @override
  _CustomerTile createState() => _CustomerTile();
}

class _CustomerTile extends State<CustomerTile> {
  @override
  Widget build(BuildContext context) {
    final all_customers = Provider.of<QuerySnapshot>(context).docs;

    return ListView.builder(
        itemCount: all_customers.length,
        itemBuilder: (context, index) {
          dynamic customer = all_customers[index].data();
          return CustomerCard(
              customerName: customer['name'],
              customerBalance: customer['balance']);
        });
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    Key key,
    @required this.customerName,
    @required this.customerBalance,
  }) : super(key: key);

  final String customerName;
  final int customerBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: Icon(
              Icons.person_rounded,
              size: 40.0,
            ),
            title: Text(customerName),
            subtitle: Text('Balance: \$' + getBalance(customerBalance))),
      ),
    );
  }
}

String getBalance(int balance) {
  String balanceWithComma = balance.toString();

  balanceWithComma = balanceWithComma.replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  return balanceWithComma;
}
