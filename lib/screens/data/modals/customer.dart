import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  String id;
  String name;
  String contact;
  String nic;
  String dob;
  int age;
  String title;
  String gender;
  int due;
  CollectionReference cstFb = Firestore.instance
      .collection('labs')
      .document('hsfiY8YtyANYwhQvZAQf')
      .collection('customers');

  Customer({
    this.id,
    this.name,
    this.contact,
    this.nic,
    this.dob,
    this.title,
    this.gender,
    this.due,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        nic: json["nic"],
        dob: json["dob"],
        title: json["title"],
        gender: json["gender"],
      );

  int calAge() {
    DateTime dob = DateTime.parse(this.dob);
    Duration dur = DateTime.now().difference(dob);
    int differenceInYears = (dur.inDays / 365).floor();
    print('Age Calculation $differenceInYears');
    return differenceInYears;
  }

  DocumentReference saveToFb() {
    DocumentReference ref = this.cstFb.document();
    ref.setData(this.toJson());
    this.id = ref.documentID;
    print('Saving Completed. Saved Document ID: ' + this.id);
    return ref;
  }

  getBack(ref) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .document(ref.documentID)
        .get();
    print('Data Back Completed. Data: ');
    print(doc.data);

    Map<String, dynamic> customer = doc.data;
    print('Firebase Customer: ');
    print(customer['name']);
//    Customer cc = new Customer.fromJson(customer);
//    print('Customer Updated. New Name: ' + cc.name);
    return customer;
  }

  getBacks(ref) async {
    print('called getBack');
    DocumentSnapshot doc = await Firestore.instance
        .collection('labs')
        .document('hsfiY8YtyANYwhQvZAQf')
        .collection('customers')
        .document(ref.documentID)
        .get();
    print('Data Back Completed. Data: ');
    print(doc.data);
    Customer customer = new Customer.fromJson(doc.data);
    print('Object Customer: ' + customer.name);
    return customer;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        "nic": nic,
        "dob": dob,
        "title": title,
        "gender": gender,
        "due": due,
        "age": calAge()
      };
}
