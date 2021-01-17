import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // customer collection stream
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('cutomers');

  Stream<QuerySnapshot> get customers {
    return customerCollection.snapshots();
  }
}
