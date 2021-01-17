import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String name;
  String email;
  int balance;
  int number;
  final CollectionReference _customerCollection =
      FirebaseFirestore.instance.collection('cutomers');

  Customer({this.name, this.balance, this.number, this.email});

  Future<void> save() async {
    try {
      await _customerCollection.add(
          {"name": name, "number": number, "email": email, "balance": balance});
    } catch (err) {
      print(err);
    }
  }
}
