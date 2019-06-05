import 'package:flutter/material.dart';
import 'package:buddies_osaka/src/resources/AuthenticationResources.dart';
import 'package:buddies_osaka/src/ui/HomePage.dart';
import 'package:buddies_osaka/src/ui/MembersPage.dart';
import 'package:buddies_osaka/src/ui/ChatListPage.dart';
import 'package:buddies_osaka/src/ui/NotificationsPage.dart';

class NavigationPage extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final AuthenticationResources _authentication = AuthenticationResources();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PageController _pageController;
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF204D9E),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Color(0xFFFF),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Text(
                            'teste@email.com',
                            style: TextStyle(
                                color: Color(0xFF204D9E),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.insert_emoticon),
              title: Text("Community"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.call_received),
              title: Text("Sign Out"),
              onTap: () {
                _authentication.signOut;
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(
                      'What would you like to create?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black45,
                          fontFamily: 'Montserrat'),
                    ),
                    content: Container(
                      //padding: ,
                      height: 200.0,
                      child: Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: 60.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(60.0),
                                color: Color(0xFF204D9E),
                                elevation: 1.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      'Blog Post',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: 60.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(60.0),
                                color: Color(0xFF204D9E),
                                elevation: 1.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      'Event',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: 60.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(60.0),
                                color: Color(0xFF204D9E),
                                elevation: 1.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      'Question',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          MembersPage(),
          ChatListPage(),
          NotificationsPage()
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Home'),
              activeIcon: Icon(Icons.home, color: Color(0xFF204D9E))),
          BottomNavigationBarItem(
              icon: Icon(Icons.group, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Members'),
              activeIcon: Icon(Icons.group, color: Color(0xFF204D9E))),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Chat'),
              activeIcon: Icon(Icons.chat, color: Color(0xFF204D9E))),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Notifications'),
              activeIcon: Icon(Icons.notifications, color: Color(0xFF204D9E))),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
