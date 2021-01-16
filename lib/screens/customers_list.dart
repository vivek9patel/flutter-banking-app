import 'package:basic_banking/authentication/sign_in_google.dart';
import 'package:basic_banking/screens/home.dart';
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
  @override
  Widget build(BuildContext context) {
    final String userName = widget.userName;

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("All Customers"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[CustomerTiles(), LogOutBtn(userName: userName)],
        )),
      ),
    );
  }
}

class CustomerTiles extends StatelessWidget {
  const CustomerTiles({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
        leading: Icon(Icons.album),
        title: Text('The Enchanted Nightingale'),
        subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'));
  }
}

class LogOutBtn extends StatelessWidget {
  const LogOutBtn({
    Key key,
    @required this.userName,
  }) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Log Out from $userName"),
      onPressed: () => {
        signOutGoogle().then((result) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
          );
        })
      },
    );
  }
}
