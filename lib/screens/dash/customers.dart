import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Customers',
              style: TextStyle(fontSize: 32),
            ),
            CustomersList()
          ],
        ));
  }
}

class CustomersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('labs')
          .document('hsfiY8YtyANYwhQvZAQf')
          .collection('customers')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CupertinoActivityIndicator();
          default:
            return Card(
              margin: EdgeInsets.all(8),
              child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('NIC')),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('DOB')),
                    DataColumn(label: Text('Contact')),
                  ],
                  rows:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return DataRow(cells: [
                      DataCell(Text(document['name'])),
                      DataCell(Text(document['nic'])),
                      DataCell(Text(document['gender'])),
                      DataCell(Text(document['dob'])),
                      DataCell(Text(document['contact'])),
                    ]);
                  }).toList()),
            );
        }
      },
    );
  }
}
