import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_appliances/states/user_provider.dart';

import 'home/items_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 가전', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          IconButton(onPressed: (){
            context.read<UserProvider>().SetUserAuth(false);
          },
              icon: Icon(Icons.search)
          ),
          IconButton(onPressed: (){
            context.read<UserProvider>().SetUserAuth(false);
          },
              icon: Icon(Icons.list)
          ),
          IconButton(onPressed: (){
            context.read<UserProvider>().SetUserAuth(false);
          },
              icon: Icon(Icons.notifications)
          ),
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          ItemPage(),
          Container(
            color: Colors.accents[0],
          ),
          Container(
            color: Colors.accents[4],
          ),
          Container(
            color: Colors.accents[10],
          ),
          Container(
            color: Colors.accents[15],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
          onTap: (index){
            setState(() {
              _bottomSelectedIndex = index;
            });
          },
        type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                  _bottomSelectedIndex == 0
                      ? 'assets/icons/home.png'
                      : 'assets/icons/home.png'),),
                label: '홈'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                    _bottomSelectedIndex == 1
                        ? 'assets/icons/calendar.png'
                        : 'assets/icons/calendar.png'),),
                label: '히스토리'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                    _bottomSelectedIndex == 2
                        ? 'assets/icons/chat.png'
                        : 'assets/icons/chat.png'),),
                label: '채팅'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(
                    _bottomSelectedIndex == 3
                        ? 'assets/icons/user.png'
                        : 'assets/icons/user.png'),),
                label: '내정보'
            ),
          ]
      ),
    );
  }
}
