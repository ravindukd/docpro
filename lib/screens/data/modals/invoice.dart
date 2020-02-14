// To parse this JSON data, do
//
//     final invoice = invoiceFromJson(jsonString);

import 'dart:convert';

Invoice invoiceFromJson(String str) => Invoice.fromJson(json.decode(str));

String invoiceToJson(Invoice data) => json.encode(data.toJson());

class Invoice {
  List<dynamic> tests;
  int total;
  int barcode;
  String customer;
  int discount;
  int paid;
  int due;

  Invoice({
    this.tests,
    this.total = 0,
    this.barcode,
    this.customer,
    this.discount = 0,
    this.paid = 0,
    this.due = 0,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    total: json["total"],
    tests: ['ALP'],
    barcode: json["barcode"],
    customer: json["customer"],
    discount: json["discount"],
    paid: json["paid"],
    due: json["due"],
  );

  Map<String, dynamic> toJson() => {
    "tests": List<dynamic>.from(tests.map((x) => x)),
    "total": total,
    "barcode": barcode,
    "customer": customer,
    "discount": discount,
    "paid": paid,
    "due": due,
  };
}
