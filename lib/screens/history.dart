import 'package:flutter/material.dart';
import 'package:basic_banking/database/databseService.dart';
import 'package:basic_banking/components/historyTile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().history,
        child: Scaffold(
          body: HistoryTile(),
        ));
  }
}
