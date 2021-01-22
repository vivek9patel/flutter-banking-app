import 'dart:math';
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
    if (Provider.of<QuerySnapshot>(context) == null) {
      return Center(child: CircularProgressIndicator());
    }
    final allCustomers = Provider.of<QuerySnapshot>(context).docs;
    // allCustomers.sort();
    return ListView.builder(
        itemCount: allCustomers.length,
        itemBuilder: (context, index) {
          dynamic customer = allCustomers[index].data();
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

  String _getBalance(int balance) {
    String balanceWithComma = balance.toString();

    balanceWithComma = balanceWithComma.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return balanceWithComma;
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor = Color.fromARGB((Random().nextInt(100) + 155) % 255, 0,
        Random().nextInt(80), Random().nextInt(200));
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Icon(
                Icons.person_rounded,
                size: 30.0,
                color: randomColor,
              ),
            ),
            title: Text(
              customerName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(
                      255, 0, randomColor.green, randomColor.blue)),
            ),
            subtitle: Row(children: [
              Text('Balance: '),
              Text(
                '\$' + _getBalance(customerBalance),
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
            ])),
      ),
    );
  }
}
