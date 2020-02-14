//
//
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:bottom_navy_bar/bottom_navy_bar.dart';
//import 'package:flutter/widgets.dart';
//import './screens/main/home.dart';
//import './screens/update.dart';
//
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Flutter Fire Test Application',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: HomePage(),
//    );
//  }
//}
//
//class Update extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.amber,
//      appBar: AppBar(
//        title: Text('Update Data'),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          Navigator.pop(context);
//        },
//        label: Text('Done'),
//        icon: Icon(Icons.update),
//      ),
//    );
//  }
//}
//
//void _openDlg(ctx) {
//  showDialog(
//      context: ctx,
//      child: Dialog(
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10))),
//        child: Container(
//          padding: EdgeInsets.all(16),
//          height: 200,
//          width: 300,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Container(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      'Hello',
//                      style: TextStyle(fontSize: 20),
//                    ),
//                    Text('SOme text'),
//                  ],
//                ),
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  FlatButton(onPressed: () {}, child: Text('OK')),
//                  RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(15))),
//                    color: Colors.pinkAccent,
//                    onPressed: () {},
//                    child: Text(
//                      'Fine',
//                      style: TextStyle(color: Colors.white),
//                    ),
//                  ),
//                ],
//              )
//            ],
//          ),
//        ),
//      ));
//}
//
//class HomePage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<HomePage> {
//  int _currentIndex = 0;
//  PageController _pageController;
//
//  @override
//  void initState() {
//    super.initState();
//    _pageController = PageController();
//  }
//
//  @override
//  void dispose() {
//    _pageController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      drawer: Drawer(
//        child: Column(
//          children: <Widget>[
//            ListTile(
//              title: Text('Dashboard'),
//              leading: Icon(Icons.dashboard),
//              onTap: () {
//                setState(() => _currentIndex = 0);
//              },
//            ),
//            ListTile(
//              title: Text('Update Data'),
//              leading: Icon(Icons.update),
//              onTap: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => Update()));
//              },
//            ),
//          ],
//        ),
//      ),
//      appBar: AppBar(title: Text("Flutter Web Test - Mickfrost")),
//      body: SizedBox.expand(
//        child: PageView(
//          controller: _pageController,
//          onPageChanged: (index) {
//            setState(() => _currentIndex = index);
//          },
//          children: <Widget>[
//            Home(),
//            Container(
//              width: 869,
//              child: TestList(),
//            ),
//            Container(
//              color: Colors.green,
//            ),
//            Container(
//              color: Colors.blue,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          _openDlg(context);
//        },
//        label: Text('Update'),
//        icon: Icon(Icons.update),
//      ),
//      bottomNavigationBar: BottomNavyBar(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        selectedIndex: _currentIndex,
//        onItemSelected: (index) {
//          setState(() => _currentIndex = index);
//          _pageController.jumpToPage(index);
//        },
//        items: <BottomNavyBarItem>[
//          BottomNavyBarItem(
//              activeColor: Colors.pink,
//              title: Text('Home'),
//              icon: Icon(Icons.home)),
//          BottomNavyBarItem(
//              activeColor: Colors.pinkAccent,
//              title: Text('Applications'),
//              icon: Icon(Icons.apps)),
//          BottomNavyBarItem(
//              activeColor: Colors.pinkAccent,
//              title: Text('Messages'),
//              icon: Icon(Icons.chat_bubble)),
//          BottomNavyBarItem(
//              activeColor: Colors.pinkAccent,
//              title: Text('Settings'),
//              icon: Icon(Icons.settings)),
//        ],
//      ),
//    );
//  }
//}
//
