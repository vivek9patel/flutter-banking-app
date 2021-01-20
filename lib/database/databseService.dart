import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // history collection stream
  final Query historyCollection = FirebaseFirestore.instance
      .collection('transaction_history')
      .orderBy("date_time");
  Stream<QuerySnapshot> get history {
    return historyCollection.snapshots();
  }

  // customer collection stream
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('cutomers');

  Stream<QuerySnapshot> get customers {
    return customerCollection.snapshots();
  }

  // getting customer's list from firestore
  Future<QuerySnapshot> getCustomerList() async {
    try {
      return customerCollection.get();
    } catch (err) {
      print(err);
      return null;
    }
  }
}
