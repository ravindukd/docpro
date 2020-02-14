import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './customerSelect.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './modals/invoice.dart';
import './payment.dart';

class TestSelect extends StatefulWidget {
  final customer, idc;
  TestSelect({this.customer, this.idc});
  @override
  State<StatefulWidget> createState() => _TestSelectState(customer: customer, idc: idc);
}

class _TestSelectState extends State<TestSelect> {
  var customer, idc;
  TextEditingController paymentCtrl;
  TextEditingController discountCtrl;

  _TestSelectState({this.customer, this.idc});

  String selectedValue;
  List item = [];
  bool value = false;
  double total = 0;
  var dataDocs = {};
  Invoice invoice = new Invoice();

  void initState() {
    super.initState();
    paymentCtrl = new TextEditingController();
    discountCtrl = new TextEditingController();
  }

  Widget _testsDropDown() {
    List<DropdownMenuItem> items = [];
    Firestore.instance.collection('Test').snapshots().listen((data) {
      data.documents.forEach((doc) {
        dataDocs[doc.documentID] = doc;
        items.add(DropdownMenuItem(
            child: Container(
                width: 300,
                padding: EdgeInsets.all(4),
                child: ListTile(
                    title: Text(
                      doc["name"],
                    ),
                    leading: Text(
                      doc.documentID,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(doc["specimen"]),
                    trailing: Text(
                      'Rs. ' + doc["price"].toString(),
                    ))),
            value: doc.documentID));
      });
    });
    return SearchableDropdown(
      items: items,
      value: selectedValue,
      hint: Text('TEST JOBS'),
      searchHint: Text(
        'Select Test',
        style: TextStyle(fontSize: 20),
      ),
      onChanged: (value) {
        setState(() {
          invoice.total = invoice.total + dataDocs[value]['price'];
          item.add(value);
        });
      },
    );
  }

  Widget customerChip(context) {
    return Chip(
      label: Text(
        customer['name'],
        style: TextStyle(color: Colors.blue),
      ),
      backgroundColor: Colors.white,
      deleteIcon: Icon(
        Icons.remove_circle,
        color: Colors.red,
      ),
      avatar: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(
          CupertinoIcons.person_solid,
          color: Colors.white,
        ),
      ),
      onDeleted: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CustomerSelect()));
      },
    );
  }

  Widget selectedTests() {
    return ListView(
      children: item
          .map((i) => ListTile(
                title: Text(dataDocs[i]['name']),
                trailing: Text(
                  'Rs.' + dataDocs[i]['price'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      invoice.total = invoice.total - dataDocs[i]['price'];
                      item.remove(i);
                      print(i);
                    });
                  },
                ),
              ))
          .toList(),
    );
  }

  void transaction() {
    payment();
  }

  payment() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Payment'),
            content: Container(
              child: Column(
                children: <Widget>[
                  Text(total.toString()),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'discount'),
                    controller: discountCtrl,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'payment'),
                    controller: paymentCtrl,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    invoice.paid = int.parse(paymentCtrl.text);
                    invoice.discount = int.parse(discountCtrl.text);
                    invoice.due = invoice.total - invoice.discount - invoice.paid;
                    invoice.customer = idc;
                    invoice.barcode = 223344;
                    invoice.tests = item;
                  });
                  print(invoice.toJson());
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentInvoice(
                            invoice: invoice,
                          )));
                },
                child: Text('DONE'),
                color: Colors.blue,
              ),
            ],
          );
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          transaction();
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerSelect()));
        },
        label: Text('Done'),
        icon: Icon(CupertinoIcons.check_mark_circled),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Select Tests'),
        actions: <Widget>[customerChip(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('SELECT TEST'),
                _testsDropDown(),
                Container(
                    height: 400,
                    width: 400,
                    child: Card(margin: EdgeInsets.all(8), child: selectedTests())),
                Container(
                  width: 400,
                  child: Card(
                    margin: EdgeInsets.all(4),
                    child: ListTile(
                      title: Text('Total'),
                      trailing: Text(
                        'Rs.' + invoice.total.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  testList() {}
}
