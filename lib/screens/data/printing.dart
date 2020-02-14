import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import './modals/invoice.dart';

class PrintInv extends StatelessWidget {
  final Invoice invoice;

  PrintInv({this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 300,
        child: SingleChildScrollView(
          child: Html(
            data: """<div>
        <div>
        <h5>""" +
                invoice.customer.toString() +
                """</h5>
        <table>
        <caption>Invoice</caption>
           <tr><th>Sub Total<sup>*</sup></th><th>""" +
                invoice.total.toString() +
                """</th></tr>
           <tr><td>Discount</td><td>""" +
                invoice.discount.toString() +
                """</td></tr>
           <tr><td><b>Total</b></td><td><b>""" +
                (invoice.total - invoice.discount).toString() +
                """</b></td></tr>
        </table>
        </div>
  """,
            //Optional parameters:
            padding: EdgeInsets.all(8.0),
            linkStyle: const TextStyle(
              color: Colors.redAccent,
              decorationColor: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            onLinkTap: (url) {
              print("Opening $url...");
            },
            onImageTap: (src) {
              print(src);
            },
            //Must have useRichText set to false for this to work
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Column(children: children);
                }
              }
              return null;
            },
            customTextAlign: (dom.Node node) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return TextAlign.justify;
                }
              }
              return null;
            },
            customTextStyle: (dom.Node node, TextStyle baseStyle) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return baseStyle.merge(TextStyle(height: 2, fontSize: 20));
                }
              }
              return baseStyle;
            },
          ),
        ),
      ),
    );
  }
}
