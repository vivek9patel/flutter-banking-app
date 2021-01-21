import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class HistoryTile extends StatefulWidget {
  @override
  _HistoryTile createState() => _HistoryTile();
}

class _HistoryTile extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<QuerySnapshot>(context) == null) {
      return Center(child: CircularProgressIndicator());
    }
    List<QueryDocumentSnapshot> transactionHistory =
        Provider.of<QuerySnapshot>(context).docs.reversed.toList();
    return ListView.builder(
        itemCount: transactionHistory.length,
        itemBuilder: (context, index) {
          dynamic history = transactionHistory[index].data();
          return HistoryCard(
            sender: history['sender'],
            receiver: history['receiver'],
            dateTime: history["date_time"],
            amount: history["amount"],
            doneBy: history["done_by"] ?? "anonymous",
          );
        });
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key key,
    @required this.sender,
    @required this.receiver,
    @required this.dateTime,
    @required this.amount,
    @required this.doneBy,
  }) : super(key: key);

  final String sender, receiver;
  final Timestamp dateTime;
  final int amount;
  final String doneBy;

  String _getBalance(int balance) {
    String balanceWithComma = balance.toString();

    balanceWithComma = balanceWithComma.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return balanceWithComma;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeInstance = dateTime.toDate();
    String date = dateTimeInstance.day.toString();
    int month = dateTimeInstance.month;
    String hour = dateTimeInstance.hour.toString();
    String minute = dateTimeInstance.minute.toString();
    String second = dateTimeInstance.second.toString();
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];

    Color randomColor = Color.fromARGB((Random().nextInt(100) + 155) % 255,
        Random().nextInt(155), Random().nextInt(155), Random().nextInt(100));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date + "\u1d57\u02b0",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: "Roboto"),
                    ),
                    Text(
                      months[month - 1],
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                Flexible(
                  child: Container(
                    width: 120,
                    child: Text(sender,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800])),
                  ),
                ),
                Icon(Icons.arrow_right_alt_rounded),
                Flexible(
                  child: Container(
                    width: 120,
                    child: Text(receiver,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800])),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '-\$' + _getBalance(amount),
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ]),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hour + ":" + minute + ":" + second,
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: "Roboto"),
                    ),
                    Row(
                      children: [
                        Text(
                          "by ",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(doneBy,
                            style: TextStyle(
                                fontSize: 13,
                                color: randomColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto",
                                letterSpacing: 1))
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
