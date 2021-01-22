import 'package:basic_banking/authentication/sign_in_google.dart';
import 'package:basic_banking/screens/all_customer.dart';
import 'package:basic_banking/screens/login.dart';
import 'package:basic_banking/screens/transaction.dart';
import 'package:basic_banking/screens/history.dart';
import 'package:flutter/material.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({
    Key key,
    @required this.userDetails,
  }) : super(key: key);

  final Map<String, String> userDetails;

  @override
  _CustomersListState createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screens = [
      {
        "title": "All customers",
        "screen": AllCustomersList(userEmail: widget.userDetails["userEmail"]),
        "bgColor": Colors.transparent,
        "elevation": 0.0,
        "textColor": Colors.black,
      },
      {
        "title": "Transaction",
        "screen": MakeTransaction(currentUser: widget.userDetails["userName"]),
        "bgColor": Colors.blue[400]
      },
      {"title": "History", "screen": History(), "bgColor": Colors.blueGrey},
    ];
    final Map<String, String> userDetails = widget.userDetails;

    return Scaffold(
      appBar: AppBar(
        elevation: screens[_selectedIndex]["elevation"] ?? 4.0,
        title: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(35, 0, 0, 0),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image(
                image: NetworkImage(userDetails["userImgUrl"].toString()),
                width: 35,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            screens[_selectedIndex]["title"],
            style: TextStyle(
                color: screens[_selectedIndex]["textColor"] ?? Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24),
          )
        ]),
        backgroundColor: screens[_selectedIndex]["bgColor"],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.logout,
              size: 26,
            ),
            label: Text(
              'Log Out',
              style: TextStyle(fontSize: 0),
            ),
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
        elevation: screens[_selectedIndex]["elevation"] ?? 4.0,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Customers',
              backgroundColor: Colors.orange),
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
