import 'package:DocPro/screens/data/selectTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './modals/customer.dart';

class SelectCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController nicText;
  Customer customer = new Customer();
  int currentStep = 0;
  bool isLoading = false;
  var cst;
  var idc;

  List<Step> steps() {
    return [
      Step(
        title: Text('Select Customer'),
        subtitle: Text('Search by NIC'),
        content: isLoading
            ? CupertinoActivityIndicator()
            : TextFormField(
                decoration: InputDecoration(
                  labelText: 'NIC',
                  hintText: 'Only exact matching NIC will be searched.',
                ),
                controller: nicText,
              ),
        state: currentStep >= 0 ? StepState.complete : StepState.disabled,
        isActive: currentStep >= 0,
      ),
      Step(
          title: Text('Create Customer'),
          subtitle: Text('Register'),
          content: Container(
              child: Builder(
                  builder: (context) => Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Title'),
                                onSaved: (val) => setState(() => customer.title = val),
                                validator: (val) => val.isEmpty ? 'Please enter your name' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Full Name'),
                                onSaved: (val) => setState(() => customer.name = val),
                                validator: (val) => val.isEmpty ? 'Please enter your name' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Contact'),
                                onSaved: (val) => setState(() => customer.contact = val),
                                validator: (val) =>
                                    val.isEmpty ? 'Please enter your contact number' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'NIC'),
                                onSaved: (val) => setState(() => customer.nic = val),
                                validator: (val) =>
                                    val.isEmpty ? 'Please enter your NIC number' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Date of Birth'),
                                onSaved: (val) => setState(() => customer.dob = val),
                                validator: (val) =>
                                    val.isEmpty ? 'Please enter your birthday' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Gender'),
                                onSaved: (val) => setState(() => customer.gender = val),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter your gender. ie. Male/Female'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ))),
          state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 1),
      Step(
          title: Text('Confirm Customer'),
          subtitle: Text('Verify Details'),
          content: isLoading
              ? CupertinoActivityIndicator()
              : Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(CupertinoIcons.person_solid),
                        ),
                        title: cst == null ? Text('Name : ') : Text('Name : ' + cst['name']),
                        subtitle: cst != null ? Text('NIC : ' + cst['nic']) : Text('NIC : '),
                        trailing: IconButton(
                            icon: Icon(
                              CupertinoIcons.clear_thick_circled,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              cst = null;
                              goTo(0);
                            }),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_balance),
                        title: cst == null || cst['due'] == null
                            ? Text('Amount Due : 0')
                            : Text('Amount Due : ' + cst['due'].toString()),
                        subtitle: cst != null ? Text('DOB : ' + cst['dob']) : Text('Name : '),
                      ),
                    ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Done'),
        icon: Icon(CupertinoIcons.check_mark_circled),
      ),
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
        buttons.add(_nameConfirm(doc, doc.documentID));
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
            actions: <Widget>[_nameConfirm(customers.first, customers.first.documentID)],
            title: Text('Which one is correct?'),
          );
        },
        context: context,
      );
    }
  }

  nextButtonHandler() {
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
          formSave();
          print(cst);
          goTo(2);
        });
        showMessage('Saved');
      }
    } else if (currentStep == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SelectTest(
                    customer: cst,
                    idc: idc,
                  )));
    }
  }

  formSave() async {
    setState(() {
      isLoading = true;
    });
    DocumentReference cstRef = Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .document();
    cstRef.setData(customer.toJson());
    var cc = await formGetBack(cstRef.documentID);
    setState(() {
      cst = cc;
      idc = cstRef.documentID;
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
    setState(() {
      idc = doc.documentID;
    });
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

  Widget _nameConfirm(doc, id) {
    return CupertinoButton(
        child: Text(doc['name']),
        onPressed: () {
          setState(() {
            cst = doc;
            idc = id;
            isLoading = false;
            Navigator.pop(context);
          });
        });
  }

  Widget actionChip() {
    return Center(
        child: cst == null
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
                  cst['name'],
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
                    cst = null;
                    goTo(0);
                  });
                },
              ));
  }
}
