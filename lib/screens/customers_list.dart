import 'package:basic_banking/authentication/sign_in_google.dart';
import 'package:basic_banking/database/databseService.dart';
import 'package:basic_banking/models/customer.dart';
import 'package:basic_banking/screens/home.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'customerTile.dart';

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

    void _showBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[AddCustomerForm()])),
          );
        },
        elevation: 5.0,
      );
    }

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().customers,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("All Customers"),
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
        body: CustomerTile(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showBottomSheet(),
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}

class AddCustomerForm extends StatefulWidget {
  const AddCustomerForm({
    Key key,
  }) : super(key: key);

  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _formKey = GlobalKey<FormState>();

  String customerName;
  String customerBalance;
  String customerNumber;
  String customerEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter full name',
                  labelText: 'Name *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    customerName = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: 'Enter Phone Number',
                  labelText: 'Number *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    customerNumber = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter Email Address',
                  labelText: 'Email *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  } else if (RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(value) ==
                      false) {
                    return 'Enter Valid Email';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    customerEmail = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone_android),
                  hintText: 'Enter Account Balance',
                  labelText: 'Balance *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter balance';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    customerBalance = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            RaisedButton(
              color: Colors.green[400],
              child: Text(
                "Add Customer",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Customer newCustomer = new Customer(
                      name: customerName,
                      balance: int.parse(customerBalance),
                      number: int.parse(customerNumber),
                      email: customerEmail);
                  await newCustomer.save();
                  Navigator.pop(context);
                  Flushbar(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    padding: EdgeInsets.all(20),
                    borderRadius: 10,
                    message: "Customer Added !",
                    duration: Duration(seconds: 3),
                    icon: Icon(Icons.person_add,
                        size: 28, color: Colors.greenAccent),
                    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                    // leftBarIndicatorColor: Colors.blue[300],
                  )..show(context);
                }
              },
            ),
            SizedBox(
              height: 50.0,
            )
          ],
        ));
  }
}
