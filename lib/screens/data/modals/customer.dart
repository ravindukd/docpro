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
  String title;
  String gender;
  int due;

  Customer(
      {this.id, this.name, this.contact, this.nic, this.dob, this.title, this.gender, this.due});



  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json["id"],
      name: json["name"],
      contact: json["contact"],
      nic: json["nic"],
      dob: json["dob"],
      title: json["title"],
      gender: json["gender"],
      due: json["die"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        "nic": nic,
        "dob": dob,
        "title": title,
        "gender": gender,
        "due": due
      };
}
