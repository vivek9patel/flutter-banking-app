import 'package:basic_banking/models/history.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basic_banking/database/databseService.dart';
import 'package:flutter/services.dart';

class MakeTransaction extends StatefulWidget {
  const MakeTransaction({Key key, this.currentUser}) : super(key: key);
  final String currentUser;
  @override
  _MakeTransactionState createState() => _MakeTransactionState();
}

class _MakeTransactionState extends State<MakeTransaction> {
  List<String> customerNamesList;
  String _senderName, _receiverName;
  String _transferAmount;
  bool isBalSet = false;

  @override
  void initState() {
    super.initState();
    getCustomerNames();
  }

  void getCustomerNames() {
    List<String> customerNames = [];

    Future<QuerySnapshot> customerList = DatabaseService().getCustomerList();
    customerList.then((querySnapshots) {
      if (querySnapshots.docs.isNotEmpty) {
        querySnapshots.docs.forEach((docs) {
          String name = docs.data()["name"];
          customerNames.add(name);
        });
        setState(() {
          customerNamesList = customerNames;
        });
      } else {
        print("Customer List Empty!");
        setState(() {
          customerNamesList = ["No Customers!"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void _transferMoney() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (_senderName != null &&
          _receiverName != null &&
          _transferAmount != null) {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          builder: (context) {
            return BottomSheetConfirmation(
              senderName: _senderName,
              transferAmount: _transferAmount,
              receiverName: _receiverName,
              currentUser: widget.currentUser,
            );
          },
          elevation: 5.0,
        );
      }
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                SenderDropDown(
                    customerNamesList: customerNamesList,
                    setSender: (val) => setState(() => _senderName = val)),
                SizedBox(
                  width: 50,
                ),
                ReciverDropDown(
                  customerNamesList: customerNamesList,
                  setRecevier: (val) => setState(() => _receiverName = val),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 60,
                  child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        hintText: 'Enter Amount',
                        labelText: 'Amount *',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          _transferAmount = value;
                        });
                      }),
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    _transferMoney();
                  },
                  child:
                      Text("Transfer", style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BottomSheetConfirmation extends StatefulWidget {
  const BottomSheetConfirmation({
    Key key,
    @required String senderName,
    @required String transferAmount,
    @required String receiverName,
    @required String currentUser,
  })  : _senderName = senderName,
        _transferAmount = transferAmount,
        _receiverName = receiverName,
        _currentUser = currentUser,
        super(key: key);

  final String _senderName;
  final String _transferAmount;
  final String _receiverName;
  final String _currentUser;

  @override
  _BottomSheetConfirmationState createState() =>
      _BottomSheetConfirmationState();
}

class _BottomSheetConfirmationState extends State<BottomSheetConfirmation> {
  int _senderBalance, _receiverBalance;
  String _senderDocId, _receiverDocId;
  String currentUser;
  void initState() {
    super.initState();
    currentUser = widget._currentUser;
    getAccBalance(widget._senderName).then((value) {
      setState(() {
        _senderBalance = value["accBal"];
        _senderDocId = value["docId"];
      });
    });
    getAccBalance(widget._receiverName).then((value) {
      setState(() {
        _receiverBalance = value["accBal"];
        _receiverDocId = value["docId"];
      });
    });
  }

  Future<Map<String, Object>> getAccBalance(String name) async {
    final CollectionReference collectionReference =
        DatabaseService().customerCollection;
    int accBal;
    String docId;
    var result = await collectionReference.where('name', isEqualTo: name).get();
    docId = result.docs.first.id;
    accBal = result.docs.first["balance"];
    return {"accBal": accBal, "docId": docId};
  }

  int _transferTo(String senderName, String receiverName, int amount) {
    if (senderName != null || receiverName != null || amount != null) {
      int transfferResult;
      if (senderName == receiverName) {
        transfferResult = 0;
      } else if (_senderBalance >= amount) {
        // deduct amount from sender
        _senderBalance -= amount;
        // add amount to receiver
        _receiverBalance += amount;

        DatabaseService()
            .customerCollection
            .doc(_senderDocId)
            .update({"balance": _senderBalance}).then((value) {
          print("Amount Deducted Successfully");
        });

        DatabaseService()
            .customerCollection
            .doc(_receiverDocId)
            .update({"balance": _receiverBalance}).then((value) {
          print("Amount Added Successfully");
        });

        History(
                sender: senderName,
                receiver: receiverName,
                amount: amount,
                dateTime: DateTime.now(),
                currentUser: currentUser)
            .save()
            .then((value) => print("Transaction History Saved!"))
            .catchError((err) {
          print(err);
        });

        transfferResult = 1;
      } else {
        transfferResult = 2;
      }
      return transfferResult ?? 0;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return _senderBalance == null || _receiverBalance == null
        ? Container(
            height: 200,
            width: 200,
            child: Center(child: CircularProgressIndicator()))
        : Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Row(
                    children: [
                      Text("From Sender: ${widget._senderName} "),
                      Text("[\$$_senderBalance]")
                    ],
                  ),
                )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Transfer Amount: "),
                    Text(
                      "\$${widget._transferAmount}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Row(
                    children: [
                      Text("To Receiver: ${widget._receiverName} "),
                      Text("[\$$_receiverBalance]")
                    ],
                  ),
                )),
              ),
              SizedBox(height: 30),
              RaisedButton(
                  color: Colors.green[400],
                  child: Text(
                    "Make Transaction",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    int isTranssferd = _transferTo(
                        widget._senderName,
                        widget._receiverName,
                        int.parse(widget._transferAmount));
                    Navigator.pop(context);
                    if (isTranssferd == 1) {
                      // Transfer Successful
                      Flushbar(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        padding: EdgeInsets.all(20),
                        borderRadius: 10,
                        message: "Transfer Successful!",
                        duration: Duration(seconds: 3),
                        icon: Icon(Icons.check_circle,
                            size: 28, color: Colors.greenAccent),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        // leftBarIndicatorColor: Colors.blue[300],
                      )..show(context);
                    } else if (isTranssferd == -1) {
                      // Transfer Error
                      Flushbar(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        padding: EdgeInsets.all(20),
                        borderRadius: 10,
                        message: "Transfer Unsuccessful!",
                        duration: Duration(seconds: 3),
                        icon: Icon(Icons.cancel,
                            size: 28, color: Colors.redAccent),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        // leftBarIndicatorColor: Colors.blue[300],
                      )..show(context);
                    } else if (isTranssferd == 2) {
                      // Insufficient Balance
                      Flushbar(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        padding: EdgeInsets.all(20),
                        borderRadius: 10,
                        message: "Insufficient Balance!",
                        duration: Duration(seconds: 3),
                        icon: Icon(Icons.cancel,
                            size: 28, color: Colors.redAccent),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        // leftBarIndicatorColor: Colors.blue[300],
                      )..show(context);
                    } else {
                      // Names are Same
                      Flushbar(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        padding: EdgeInsets.all(20),
                        borderRadius: 10,
                        message: "Sender & Receiver are Same!",
                        duration: Duration(seconds: 3),
                        icon: Icon(Icons.cancel,
                            size: 28, color: Colors.redAccent),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        // leftBarIndicatorColor: Colors.blue[300],
                      )..show(context);
                    }
                  }),
              SizedBox(height: 30)
            ])),
          );
  }
}

typedef void StringCallback(String val);

class SenderDropDown extends StatefulWidget {
  SenderDropDown({Key key, this.customerNamesList, this.setSender})
      : super(key: key);
  final List<String> customerNamesList;
  final StringCallback setSender;

  @override
  _SenderDropDownState createState() => _SenderDropDownState();
}

class _SenderDropDownState extends State<SenderDropDown> {
  String _currentSender = 'Vivek Patel';

  @override
  Widget build(BuildContext context) {
    return widget.customerNamesList != null
        ? DropdownButton(
            value: _currentSender,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                _currentSender = newValue;
              });
              widget.setSender(newValue);
            },
            items: widget.customerNamesList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        : CircularProgressIndicator();
  }
}

class ReciverDropDown extends StatefulWidget {
  ReciverDropDown({Key key, this.customerNamesList, this.setRecevier})
      : super(key: key);
  final List<String> customerNamesList;
  final StringCallback setRecevier;

  @override
  _ReciverDropDownState createState() => _ReciverDropDownState();
}

class _ReciverDropDownState extends State<ReciverDropDown> {
  String _currentReciever = "Om Patel";

  @override
  Widget build(BuildContext context) {
    return widget.customerNamesList != null
        ? DropdownButton(
            value: _currentReciever,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                _currentReciever = newValue;
              });
              widget.setRecevier(newValue);
            },
            items: widget.customerNamesList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        : CircularProgressIndicator();
  }
}
