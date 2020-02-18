import 'package:DocPro/screens/data/selectTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import './../data/modals/customer.dart';

class SelectCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Customer formCustomer = new Customer();
  Customer customer;

  TextEditingController nicText;
  int currentStep = 0;
  bool isLoading = false;

  List<Step> steps() {
    return [
      Step(
        title: Text('Search'),
        subtitle: Text('by NIC'),
        content: isLoading
            ? CupertinoActivityIndicator()
            : Center(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'NIC',
                      hintText: 'Only exact matching NIC will be searched.',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
                  controller: nicText,
                ),
              ),
        state: currentStep >= 0 ? StepState.complete : StepState.disabled,
        isActive: currentStep >= 0,
      ),
      Step(
          title: Text('Register'),
          subtitle: Text('New Customer'),
          content: Center(
            child: Container(
                child: Builder(
                    builder: (context) => Form(
                          key: _formKey,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Title'),
                                  onSaved: (val) => setState(() => formCustomer.title = val),
                                  validator: (val) =>
                                      val.isEmpty ? 'Please enter your title' : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Full Name'),
                                  onSaved: (val) => setState(() => formCustomer.name = val),
                                  validator: (val) => val.isEmpty ? 'Please enter your name' : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Contact'),
                                  onSaved: (val) => setState(() => formCustomer.contact = val),
                                  validator: (val) =>
                                      val.isEmpty ? 'Please enter your contact number' : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'NIC'),
                                  onSaved: (val) => setState(() => formCustomer.nic = val),
                                  validator: (val) =>
                                      val.isEmpty ? 'Please enter your NIC number' : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Date of Birth'),
                                  onSaved: (val) => setState(() => formCustomer.dob = val),
                                  validator: (val) =>
                                      val.isEmpty ? 'Please enter your birthday' : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Gender'),
                                  onSaved: (val) => setState(() => formCustomer.gender = val),
                                  validator: (val) => val.isEmpty
                                      ? 'Please enter your gender. ie. Male/Female'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ))),
          ),
          state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 1),
      Step(
          title: Text('Confirm'),
          subtitle: Text('Details'),
          content: isLoading
              ? CupertinoActivityIndicator()
              : Center(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(CupertinoIcons.person_solid),
                          ),
                          title:
                              customer == null ? Text('Name : ') : Text('Name : ' + customer.name),
                          subtitle:
                              customer != null ? Text('NIC : ' + customer.nic) : Text('NIC : '),
                          trailing: IconButton(
                              icon: Icon(
                                CupertinoIcons.clear_thick_circled,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                customer = null;
                                goTo(0);
                              }),
                        ),
                        ListTile(
                          leading: Icon(Icons.account_balance),
                          title: customer == null || customer.due == null
                              ? Text('Amount Due : 0')
                              : Text('Amount Due : ' + customer.due.toString()),
                          subtitle:
                              customer != null ? Text('DOB : ' + customer.dob) : Text('DOB : '),
                        ),
                      ],
                    ),
                  ),
                ),
          state: currentStep >= 2 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Select Customer'),
        actions: <Widget>[
          actionChip(),
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
          child: Stepper(
            type: StepperType.horizontal,
            steps: steps(),
            currentStep: currentStep,
            onStepContinue: nextButtonHandler,
            onStepTapped: (step) => goTo(step),
            onStepCancel: cancelButtonHandler,
          ),
        ),
      ),
    );
  }

  searchCustomerByNIC() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot qs = await Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .where("nic", isEqualTo: nicText.text.toString())
        .getDocuments();
    var customers = qs.documents;
    if (customers.length == 0) {
      showMessage('No Customer found', Colors.blue);
      goTo(1);
    } else if (customers.length > 1) {
      List<Widget> buttons = [];
      customers.forEach((doc) {
        buttons.add(_nameConfirm(doc));
      });
      showDialog(
        builder: (_) {
          return CupertinoAlertDialog(
            actions: buttons,
            title: Text('Which one is correct?'),
          );
        },
        context: context,
      );
      showMessage('Customer Seach Completed. Verify Data before continuing.', Colors.blue);
      goTo(2);
    } else {
      showDialog(
        builder: (_) {
          return CupertinoAlertDialog(
            actions: <Widget>[_nameConfirm(customers.first)],
            title: Text('Is this Correct?'),
          );
        },
        context: context,
      );
      showMessage('Customer Seach Completed. Verify Data before continuing.', Colors.blue);
      goTo(2);
    }
  }

  nextButtonHandler() async {
    if (currentStep == 0) {
      if (nicText.text != null && nicText.text != '') {
        searchCustomerByNIC();
      } else {
        goTo(1);
      }
    } else if (currentStep == 1) {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        setState(() {
          isLoading = true;
        });
        print('Loading Started');
        print(formCustomer.toJson());

        DocumentReference ref = formCustomer.saveToFb();
        Customer refCustomer = await formCustomer.getBacks(ref);
        print('PASS 1');
        setState(() {
          print('Setting State');
          customer = refCustomer;
          print('PASS 2');
          isLoading = false;
          goTo(2);
        });
        showMessage('Saved');
      }
    } else if (currentStep == 2) {
      Navigator.pushReplacement(context,
          PageTransition(type: PageTransitionType.fade, child: SelectTest(customer: customer)));
    }
  }

  formSave() async {
    setState(() {
      isLoading = true;
      customer.age = customer.calAge();
      print(customer.age);
    });
    DocumentReference cstRef = Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .document();
    cstRef.setData(customer.toJson());
    var cc = await formGetBack(cstRef.documentID);
    setState(() {
      isLoading = false;
    });
  }

  formGetBack(cstRef) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .document(cstRef)
        .get();
    var customer = doc.data;
    setState(() {});
    return customer;
  }

  cancelButtonHandler() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
    if (currentStep == 0) {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
//    currentStep == 1 ? formCustomer = : formCustomer = null;
    setState(() => currentStep = step);
  }

  void initState() {
    super.initState();
    nicText = new TextEditingController(text: '');
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  Widget actionChip() {
    print(customer);
    return Center(
        child: customer == null
            ? Chip(
                label: isLoading
                    ? CupertinoActivityIndicator()
                    : Text(
                        '',
                        style: TextStyle(color: Colors.white),
                      ),
                avatar: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    CupertinoIcons.person_solid,
                    color: Colors.red,
                  ),
                ),
                backgroundColor: Colors.red,
              )
            : Chip(
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
                  setState(() {
                    customer = null;
                    goTo(0);
                  });
                },
              ));
  }

  Widget _nameConfirm(doc) {
    return CupertinoButton(
        child: Text(doc['name']),
        onPressed: () {
          setState(() {
            customer = new Customer.fromJson(doc.data);
            isLoading = false;
            Navigator.pop(context);
          });
        });
  }
}
