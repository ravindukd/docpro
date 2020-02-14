import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Dashboard', style: TextStyle(fontSize: 32)),
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    IconButton(
                        icon: Icon(Icons.search, color: Colors.blue),
                        onPressed: () {},
                        color: Colors.blue),
                  ],
                ),
              )
            ],
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text('Customer'),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Container(
            width: 600,
            height: 300,
            child: ListView(),
          )
        ],
      ),
    );
  }
}
