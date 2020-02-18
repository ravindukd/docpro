import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './customerSelect.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './modals/invoice.dart';
import './modals/customer.dart';
import './payment.dart';
import 'dart:math';
import 'package:page_transition/page_transition.dart';

class SelectTest extends StatefulWidget {
  final Customer customer;

  SelectTest({this.customer});

  @override
  State<StatefulWidget> createState() => _SelectTestState(customer: customer);
}

class _SelectTestState extends State<SelectTest> {
  final Customer customer;

  _SelectTestState({this.customer});

  bool isLoading = false;
  Invoice invoice = new Invoice();

  var dataDocs = {};
  String selectedValue;

  Widget customerChip(context) {
    return Chip(
      label: Text(
        customer.name,
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
      hint: Text('SELECT TEST JOBS'),
      searchHint: Text(
        'Select Test',
        style: TextStyle(fontSize: 20),
      ),
      onChanged: (value) {
        setState(() {
          invoice.total = invoice.total + dataDocs[value]['price'];
          invoice.tests.add(value);
        });
      },
    );
  }

  Widget selectedTests() {
    return ListView(
      children: invoice.tests
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
                      invoice.tests.remove(i);
                      print(i);
                    });
                  },
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(invoice.toJson());
          var i = invoice.toJson();

          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft, child: PaymentInvoice(invoice: invoice)));
        },
        label: Text('Done'),
        icon: Icon(CupertinoIcons.check_mark_circled),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Select Tests'),
        actions: <Widget>[
          customerChip(context),
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Select Test Jobs'),
              ),
              Center(child: _testsDropDown()),
              Container(
                  height: 400,
                  width: 400,
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: selectedTests(),
                  )),
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
    );
  }

  @override
  void initState() {
    super.initState();
    var rng = new Random();
    invoice.tests = [];
    invoice.customer = customer.id;
    invoice.barcode = rng.nextInt(999999);
  }
}
