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
          isScrollControlled: false,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 400,
            width: 500,
            child: Card(
              elevation: 5.0,
              shadowColor: Color.fromARGB(55, 0, 0, 0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SenderDropDown(
                          customerNamesList: customerNamesList,
                          setSender: (val) =>
                              setState(() => _senderName = val)),
                      SizedBox(
                        width: 10,
                      ),
                      ReciverDropDown(
                        customerNamesList: customerNamesList,
                        setRecevier: (val) =>
                            setState(() => _receiverName = val),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text("Amount *",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600])),
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(130, 40, 33, 173),
                                  width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
                            child: TextField(
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    fontFamily: "Roboto"),
                                autofocus: false,
                                decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.monetization_on_rounded,
                                      size: 22,
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Enter Amount',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Raleway",
                                        letterSpacing: 0)),
                                keyboardType: TextInputType.number,
                                onChanged: (String value) {
                                  setState(() {
                                    _transferAmount = value;
                                  });
                                }),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromARGB(130, 40, 33, 173),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        color: Color.fromARGB(200, 40, 33, 173),
                        onPressed: () {
                          _transferMoney();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                          child: Text("Transfer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
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
    String senderBalance = _senderBalance.toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    String recevierBalance = _receiverBalance.toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    String transfferAmount = widget._transferAmount.toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return _senderBalance == null || _receiverBalance == null
        ? Container(
            height: 200,
            width: 200,
            child: Center(child: CircularProgressIndicator()))
        : Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                height: 20,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(50)),
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    thickness: 8,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            shadowColor: Color.fromARGB(80, 0, 0, 0),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromARGB(130, 40, 33, 173),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                              child: Row(
                                children: [
                                  Text("From Sender: "),
                                  Text(
                                    "${widget._senderName} ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Colors.grey[700]),
                                  ),
                                  Text("[\$$senderBalance]",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          color: Colors.grey))
                                ],
                              ),
                            )),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                        child: Row(
                          children: [
                            Text("Transfer Amount: "),
                            Card(
                              color: Color.fromARGB(255, 239, 241, 245),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 10, 8, 10),
                                child: Text(
                                  "\$" + transfferAmount,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 40, 33, 173)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            shadowColor: Color.fromARGB(80, 0, 0, 0),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromARGB(130, 40, 33, 173),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                              child: Row(
                                children: [
                                  Text("To Receiver: "),
                                  Text("${widget._receiverName} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                  Text("[\$$recevierBalance]",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          color: Colors.grey))
                                ],
                              ),
                            )),
                      ),
                      SizedBox(height: 30),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.transparent, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.green[400],
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                            child: Text(
                              "Confirm Transaction",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
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
                                dismissDirection:
                                    FlushbarDismissDirection.HORIZONTAL,
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
                                dismissDirection:
                                    FlushbarDismissDirection.HORIZONTAL,
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
                                dismissDirection:
                                    FlushbarDismissDirection.HORIZONTAL,
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
                                dismissDirection:
                                    FlushbarDismissDirection.HORIZONTAL,
                                // leftBarIndicatorColor: Colors.blue[300],
                              )..show(context);
                            }
                          }),
                      SizedBox(height: 30)
                    ]),
              )
            ]));
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
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  "Select Sender *",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _currentSender,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      iconSize: 26,
                      elevation: 1,
                      iconEnabledColor: Colors.deepPurple,
                      iconDisabledColor: Colors.grey,
                      style: TextStyle(
                          color: Colors.deepPurple[400],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
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
                    ),
                  ),
                ),
              ),
            ],
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
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text(
                      "Select Receiver *",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                    )),
                Card(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _currentReciever,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            iconSize: 26,
                            elevation: 1,
                            iconEnabledColor: Colors.deepPurple,
                            iconDisabledColor: Colors.grey,
                            style: TextStyle(
                                color: Colors.deepPurple[400],
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2),
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
                          ),
                        )))
              ])
        : CircularProgressIndicator();
  }
}
