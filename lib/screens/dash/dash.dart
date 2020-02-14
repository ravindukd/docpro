import 'package:DocPro/screens/data/customerSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import './customers.dart';
import './home.dart';
import './../data/selectCustomer.dart';
import './../data/customerSelect.dart';

class Dash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _dashState();
}

class _dashState extends State<Dash> {
  int _currentIndex = 0;
  String _currentPage = 'Dashboard';
  PageController _pageController;

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

  Widget _drawerTile(i, iconName, solidIcon, name) {
    return Container(
//      color: _currentIndex == i ? Colors.pink : Colors.white,
      child: ListTile(
          leading: Icon(
            _currentIndex == i ? solidIcon : iconName,
            color: _currentIndex == i ? Colors.blue : Colors.black,
          ),
          title: Text(
            name,
            style: TextStyle(
              color: _currentIndex == i ? Colors.blue : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              _currentIndex = i;
              _currentPage = name;
            });
            _pageController.jumpToPage(i);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      kTabletBreakpoint: 1024,
      kDesktopBreakpoint: 1024,
      title: Text('Lifeline Labs'),
      drawer: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              currentAccountPicture: Image.asset('asset/splash_girl.png'),
              accountName: Text('Ravindu Kavishka'),
              accountEmail: Text('ravindukd@gmail.com')),
          _drawerTile(0, CupertinoIcons.lab_flask, CupertinoIcons.lab_flask_solid, 'Dashboard'),
          _drawerTile(1, CupertinoIcons.group, CupertinoIcons.group_solid, 'Customers'),
          _drawerTile(2, CupertinoIcons.bookmark, CupertinoIcons.bookmark_solid, 'Reports'),
          _drawerTile(3, CupertinoIcons.collections, CupertinoIcons.collections_solid, 'Tests'),
        ],
      ),
      endIcon: Icons.filter_list,
      endDrawer: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Recent Updates',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(CupertinoIcons.bell_solid),
          ),
          ListTile(
            leading: Icon(Icons.filter_list),
            title: Text('Filter List'),
            subtitle: Text('Hide and show items'),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.image_aspect_ratio),
            title: Text('Size Settings'),
            subtitle: Text('Change size of images'),
          ),
          ListTile(
            title: Slider(
              value: 0.5,
              onChanged: (val) {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.sort_by_alpha),
            title: Text('Sort List'),
            subtitle: Text('Change layout behavior'),
            trailing: Switch(
              value: false,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
      trailing: Row(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                pageSelect(context);
              },
              color: Colors.blueAccent,
              child: Text(
                _currentPage,
                style: TextStyle(color: Colors.white),
              )),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
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
            Home(),
            Customer(),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCustomer()));
        },
      ),
    );
  }

  void pageSelect(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Navigator'),
            actions: <Widget>[
              _pageSelectBtn(0, 'Dashboard'),
              _pageSelectBtn(1, 'Customers'),
              _pageSelectBtn(2, 'Reports'),
              _pageSelectBtn(3, 'Tests'),
            ],
          );
        });
  }

  Widget _pageSelectBtn(index, name) {
    return CupertinoButton(
        child: Text(name),
        onPressed: () {
          setState(() {
            _currentIndex = index;
            _currentPage = name;
            _pageController.jumpToPage(index);
            Navigator.pop(context);
          });
        });
  }
}

void shoCup(context) {
  showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return new SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: new CupertinoPicker(
            magnification: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            onSelectedItemChanged: (i) => print(i),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Text(
                  'Dashboard',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Text(
                  'Customers',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Text(
                  'Reports',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Text(
                  'Tests',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
