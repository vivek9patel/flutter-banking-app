import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String sender;
  String receiver;
  int amount;
  DateTime dateTime;

  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('transaction_history');

  History({this.sender, this.receiver, this.amount, this.dateTime});

  Future<void> save() async {
    try {
      await _historyCollection.add({
        "sender": sender,
        "receiver": receiver,
        "amount": amount,
        "date_time": dateTime
      });
    } catch (err) {
      print(err);
    }
  }
}
