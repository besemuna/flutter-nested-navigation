import 'package:flutter/material.dart';

import 'bottom_nav.dart';

void main() {
  runApp(MyApp());
}

enum TabItem {
  One,
  Two,
  Three,
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nested Navigation',
      home: NestedNavigation(),
    );
  }
}

class NestedNavigation extends StatefulWidget {
  @override
  _NestedNavigationState createState() => _NestedNavigationState();
}

class _NestedNavigationState extends State<NestedNavigation> {
  TabItem _currentTab = TabItem.One;

  _selectTab(TabItem tabItem) {
    if (_currentTab == tabItem) {
      tabKey[_currentTab].currentState.popUntil((route) => route.isFirst);
    }
    setState(() {
      _currentTab = tabItem;
    });
  }

  Map<TabItem, GlobalKey<NavigatorState>> tabKey = {
    TabItem.One: GlobalKey<NavigatorState>(),
    TabItem.Two: GlobalKey<NavigatorState>(),
    TabItem.Three: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Color> tabColors = {
    TabItem.One: Colors.brown,
    TabItem.Two: Colors.blue,
    TabItem.Three: Colors.purple,
  };

  _buildNavigator({TabItem tab}) {
    return Offstage(
      offstage: _currentTab != tab,
      child: Navigator(
        key: tabKey[tab],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => NumberPage(
            color: tabColors[tab],
            number: tab,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isCurrentRoutePoppable =
            await tabKey[_currentTab].currentState.maybePop();

        if (isCurrentRoutePoppable) {
          return await Future.value(false);
        } else {
          if (_currentTab != TabItem.One) {
            setState(() {
              _currentTab = TabItem.One;
            });

            return await Future.value(false);
          }
        }

        return await Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildNavigator(tab: TabItem.One),
            _buildNavigator(tab: TabItem.Two),
            _buildNavigator(tab: TabItem.Three),
          ],
        ),
        bottomNavigationBar: BottomNav(
          currentTab: _currentTab,
          onChanged: (TabItem tabItem) {
            _selectTab(tabItem);
          },
        ),
      ),
    );
  }
}

class NumberPage extends StatefulWidget {
  final TabItem number;
  final Color color;

  const NumberPage({Key key, this.number, this.color}) : super(key: key);
  @override
  _NumberPageState createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  _push(context, index, color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NumberDetailsPage(
          color: color,
          number: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        int number = int.parse("${widget.number.index}0");
        return GestureDetector(
          onTap: () {
            _push(context, index, widget.color);
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              border: Border(
                bottom: BorderSide(color: Colors.white),
              ),
            ),
            child: ListTile(
              title: Text(
                "${number + index + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NumberDetailsPage extends StatelessWidget {
  final number;
  final color;
  const NumberDetailsPage({Key key, this.number, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number $number"),
        backgroundColor: color,
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          color: color,
          child: Text(
            "$number",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
