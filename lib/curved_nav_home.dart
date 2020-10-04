import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:whatisinfridgedatabase/itemList.dart';

import 'itemEntry.dart';

import 'About.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  int _currentIndex = 0;
  final List<Widget> _children = [
    ItemEntry(),
    ListViewAll(),
    About(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("What's in my fridge?") ,
          backgroundColor: Colors.green[700],
        ),

        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.add, size: 40,color: Colors.white,),
            Icon(Icons.event_note, size: 40,color: Colors.white,),
            Icon(Icons.new_releases, size: 40,color: Colors.white,),

          ],
          color: Colors.green[700],
          buttonBackgroundColor: Color.fromRGBO(0, 96, 15, 1),
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body:_children[_page],);
  }
}
