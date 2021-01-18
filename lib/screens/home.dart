import 'package:basic_banking/authentication/sign_in_google.dart';
import 'package:basic_banking/screens/all_customer.dart';
import 'package:basic_banking/screens/login.dart';
import 'package:basic_banking/screens/transaction.dart';
import 'package:basic_banking/screens/history.dart';
import 'package:flutter/material.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({
    Key key,
    @required this.userName,
  }) : super(key: key);

  final String userName;

  @override
  _CustomersListState createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  int _selectedIndex = 0;
  var screens = [
    {
      "title": "All customers",
      "screen": AllCustomersList(),
      "bgColor": Colors.blue
    },
    {
      "title": "Transaction",
      "screen": MakeTransaction(),
      "bgColor": Colors.amber[400]
    },
    {"title": "History", "screen": History(), "bgColor": Colors.blueGrey},
  ];

  @override
  Widget build(BuildContext context) {
    final String userName = widget.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text(screens[_selectedIndex]["title"]),
        backgroundColor: screens[_selectedIndex]["bgColor"],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await signOutGoogle().then((result) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: screens[_selectedIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Customers',
              backgroundColor: screens[0]["bgColor"]),
          BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Transaction',
              backgroundColor: screens[1]["bgColor"]),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
              backgroundColor: screens[2]["bgColor"]),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
