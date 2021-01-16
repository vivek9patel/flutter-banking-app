import 'package:flutter/material.dart';
import 'package:basic_banking/screens/customers_list.dart';
import 'package:basic_banking/authentication/sign_in_google.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spark Banking System"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: RaisedButton(
          child: Text("Sign in with Google"),
          onPressed: () {
            signInWithGoogle().then((username) {
              if (username != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomersList(userName: username)),
                  (Route<dynamic> route) => false,
                );
              } else {
                print("Error in Sign in With Google!");
              }
            });
          }),
    ));
  }
}
