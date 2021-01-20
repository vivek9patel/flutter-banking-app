import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String sender;
  String receiver;
  int amount;
  DateTime dateTime;
  String currentUser;
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('transaction_history');

  History(
      {this.sender,
      this.receiver,
      this.amount,
      this.dateTime,
      this.currentUser});

  Future<void> save() async {
    try {
      await _historyCollection.add({
        "sender": sender,
        "receiver": receiver,
        "amount": amount,
        "date_time": dateTime,
        "done_by": currentUser
      });
    } catch (err) {
      throw err;
    }
  }
}
