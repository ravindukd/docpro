import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './modals/invoice.dart';
import './printing.dart';
class PaymentInvoice extends StatefulWidget {
  final Invoice invoice;

  PaymentInvoice({this.invoice});

  @override
  State<StatefulWidget> createState() => PIState(invoice: invoice);
}

class PIState extends State<PaymentInvoice> {
  TextEditingController discountController;
  TextEditingController paymentController;

  Invoice invoice;

  PIState({this.invoice});

  @override
  void initState() {
    super.initState();
    discountController = new TextEditingController();
    paymentController = new TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrintInv(invoice: invoice,)));
        },
        label: Text('Done'),
        icon: Icon(CupertinoIcons.check_mark_circled),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Invoice'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          width: 600,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Sub Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Text(
                    invoice.total.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('(Discount)'),
                  trailing: TextFormField(controller: discountController,),
                ),
                ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  trailing: Text(
                    (invoice.total - invoice.discount).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('(Paid)'),
                  trailing: Text(invoice.paid.toString()),
                ),
                ListTile(
                  title: Text('Due'),
                  trailing: Text(invoice.due.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
