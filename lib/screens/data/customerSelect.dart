import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'modals/customer.dart';
import './testSelect.dart';

class CustomerSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomerSelectState();
}

class CustomerSelectState extends State<CustomerSelect> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Customer newCustomer = new Customer();
  TextEditingController nicText;

  List<String> _genders = <String>['', 'MALE', 'FEMALE'];
  String _gender = '';

  int currentStep = 0;
  bool complete = false;
  var cst;

  void initState() {
    super.initState();
    nicText = new TextEditingController(text: '');
  }

  bool _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
      return false;
    } else {
      form.save();
      DocumentReference cstRef = Firestore.instance
          .collection('labs')
          .document('hsfiY8YtyANYwhQvZAQf')
          .collection('customers')
          .document();
      cstRef.setData(newCustomer.toJson());
      searchCustomerByNIC(newCustomer.nic, context);
      showMessage('Data Added to Database Successfully', Colors.blue);
      return true;
    }
  }

  Widget _nameConfirm(id, name, doc) {
    return CupertinoButton(
        child: Text(name),
        onPressed: () {
          setState(() {
            cst = doc;
            Navigator.pop(context);
          });
        });
  }

  void searchCustomerByNIC(nic, context) {
    try {
      Firestore.instance
          .collection('labs')
          .document('hsfiY8YtyANYwhQvZAQf')
          .collection('customers')
          .where("nic", isEqualTo: nic.toString())
          .snapshots()
          .listen((data) {
        //fb Search Complete
        if (data.documents.length == 0) {
          showMessage('No Customer found with the given NIC', Colors.red);
          goTo(1);
        } else if (data.documents.length == 1) {
          //Single User
          data.documents.forEach((doc) {
            showDialog(
              builder: (_) {
                return CupertinoAlertDialog(
                  actions: <Widget>[_nameConfirm(doc.documentID, doc['name'], doc)],
                  title: Text('Is this Correct?'),
                );
              },
              context: context,
            );
          });

          showMessage(
              'Customer Seach Completed. Verify Data before continuing. Results 1', Colors.blue);
          goTo(2);
        } else {
          //Multiple Users
          List<Widget> ww = [];
          data.documents.forEach((doc) {
            ww.add(_nameConfirm(doc.documentID, doc['name'], doc));
          });

          showDialog(
            builder: (_) {
              return CupertinoAlertDialog(
                actions: ww,
                title: Text('Which one is correct?'),
              );
            },
            context: context,
          );
          showMessage('Customer Seach Completed. Verify Data before continuing.', Colors.blue);
          goTo(2);
        }
      });
    } catch (e) {
      //Error
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Error occured'),
            content: Text(e),
          ));
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  nextButtonHandler() {
    if (currentStep == 0) {
      if (nicText.text == '') {
        showMessage('Search by NIC is discarded due to NIC field is empty', Colors.orange);
        goTo(1);
      } else {
        searchCustomerByNIC(nicText.text, context);
      }
    } else if (currentStep == 1) {
      _submitForm() ? goTo(currentStep + 1) : goTo(1);
    } else {
      currentStep + 1 != 3
          ? goTo(currentStep + 1)
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TestSelect(
                        customer: cst,
                      )));
    }
  }

  cancelButtonHandler() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  List<Step> steps() {
    return [
      Step(
        title: const Text('Select Customer'),
        subtitle: Text('Search by NIC'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'NIC', hintText: 'NIC should 100% correct'),
              controller: nicText,
            ),
          ],
        ),
      ),
      Step(
        isActive: true,
        state: StepState.editing,
        title: const Text('Confirmation'),
        subtitle: const Text('Verify Customer'),
        content: Card(
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
      ),
    ];
  }

  Widget actionChip() {
    return Center(
        child: cst == null
            ? Chip(
                label: Text(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TestSelect(
                        customer: cst,
                      )));
        },
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
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
}

//
//
//class DropdownTestList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('Test').snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (snapshot.hasError)
//          return  Text('Error: ${snapshot.error}');
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting: return  Text('Loading...');
//          default:
//            return ListView(
//              children: snapshot.data.documents.map((DocumentSnapshot document) {
//                return  ListTile(
//                  title:  Text(document['title']),
//                  subtitle:  Text(document['author']),
//                );
//              }).toList(),
//            );
//        }
//      },
//    );
//  }
//}

//Step(
//isActive: true,
//state: StepState.indexed,
//title: const Text('Test Select'),
//content: Column(
//children: <Widget>[
//FormField(
//builder: (FormFieldState state) {
//return InputDecorator(
//decoration: InputDecoration(
//icon: const Icon(Icons.color_lens),
//labelText: 'Test',
//),
//isEmpty: _test == '',
//child: DropdownButtonHideUnderline(
//child: DropdownButton(
//value: _test,
//isDense: true,
//onChanged: (String newValue) {
//setState(() {
//_test = newValue;
//state.didChange(newValue);
//});
//},
//items: _tests.map((String value) {
//return DropdownMenuItem(
//value: value,
//child: Text(value ?? 'hellp'),
//);
//}).toList(),
//),
//),
//);
//},
//),
//],
//),
//),
