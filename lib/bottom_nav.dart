import 'package:flutter/material.dart';
import "main.dart";

class BottomNav extends StatefulWidget {
  final Function onChanged;
  final TabItem currentTab;

  const BottomNav({Key key, this.onChanged, this.currentTab}) : super(key: key);
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Map<TabItem, String> tabNames = {
    TabItem.One: "One",
    TabItem.Two: "Two",
    TabItem.Three: "Three",
  };

  _tabColor(TabItem tabItem) {
    return tabItem == widget.currentTab ? Colors.blue : Colors.grey;
  }

  _buildTabItem(tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.account_box,
        color: _tabColor(tabItem),
      ),
      label: tabNames[tabItem],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentTab.index,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      selectedItemColor: Colors.blue,
      selectedIconTheme: IconThemeData(color: Colors.blue),
      onTap: (index) {
        widget.onChanged(TabItem.values[index]);
      },
      items: [
        _buildTabItem(TabItem.One),
        _buildTabItem(TabItem.Two),
        _buildTabItem(TabItem.Three),
      ],
    );
  }
}
