import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_appliances/screens/splash_screen.dart';
import 'package:my_appliances/states/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:my_appliances/router/router.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {

    //퓨처 함수로 로딩구현
    return FutureBuilder<Object>(
      future: _initialization,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),  //페이드인아웃 효과
          child: _splashLodingWidget(snapshot),   //스냅샷실행 위젯지정
        );
      }
    );
  }

  Widget _splashLodingWidget(AsyncSnapshot<Object?> snapshot) {
    if(snapshot.hasError) {
      print('Error occurred while loading: ${snapshot.error}');
      return MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error: &{snapshot.error}')),
        ),
      );
    } else if(snapshot.connectionState == ConnectionState.done) {
      return MyAppliances();
    }
    else{
      return SplashScreen();
    }
  }
}

class MyAppliances extends StatelessWidget {
  const MyAppliances({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserNotifier>(
     create: (BuildContext context){
       return UserNotifier();
     },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          hintColor: Colors.grey[350],
          fontFamily: 'DoHyeon',
          primarySwatch: Colors.purple, //앱의 기본 색상
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.white,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white70,
              minimumSize: Size(48, 48)
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontFamily: 'DoHyeon'),
            titleLarge: TextStyle(fontSize: 17, color: Colors.black87),
            titleMedium: TextStyle(fontSize: 13,color: Colors.black38),
            labelLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w300)
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),
            elevation: 2,
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black38,
          )
        ),
        routerConfig: router,
      ),
    );
  }
}
