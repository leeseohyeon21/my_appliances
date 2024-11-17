import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
        // actions: [
        //   IconButton(onPressed: (){
        //     FirebaseAuth.instance.signOut();
        //   },
        //       icon: Icon(Icons.search)
        //   ),
        //   IconButton(onPressed: (){},
        //       icon: Icon(Icons.list)
        //   ),
        //   IconButton(onPressed: (){},
        //       icon: Icon(Icons.notifications)
        //   ),
        // ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          ItemPage(),
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
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            context.push('/input');
          },
        //backgroundColor: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
        child: Icon(
            Icons.add
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: '히스토리'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: '채팅'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '내정보'
            ),
          ],
        onTap: (index){
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
      ),
    );
  }
}
