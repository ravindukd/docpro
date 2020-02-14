import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './customerSelect.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './modals/invoice.dart';
import './payment.dart';

class WizardFinal extends StatefulWidget {
  final customer, idc;

  WizardFinal({this.customer, this.idc});

  @override
  State<StatefulWidget> createState() => _WizardFinalState();
}

class _WizardFinalState extends State<WizardFinal> {

  PageController _pageController;
  int _currentIndex = 0;
  String _currentPage = 'Dashboard';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Done'),
        icon: Icon(CupertinoIcons.check_mark_circled),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Select Tests'),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
