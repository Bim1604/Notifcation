import 'package:fire_base/screens/student_view.dart';
import 'package:fire_base/screens/web_socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tokenFCM = "";
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String name = "";
  String email = "";
  String image = "";

  void getTokenFCM() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      tokenFCM = token ?? "";
    });
  }

  Future<void> copyToken() async {
    await Clipboard.setData(ClipboardData(text: tokenFCM));
  }

  Future<void> _handleSignIn() async {
    try {
      var googleInfo =  await _googleSignIn.signIn();
      if (googleInfo != null) {
        setState(() {
          name = googleInfo.displayName ?? "";
          email = googleInfo.email;
          image = googleInfo.photoUrl ?? "";
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        name = "";
        email = "";
        image = "";
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const StudentView();
          },));
      }, child: const Icon(Icons.add),),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal:  10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tên: $name'),
              Text('Email: $email'),
              if (image.isNotEmpty)
                Image.network(image, width: size.width * .3, height: size.width * .3,),
              InkWell(
                onTap:(){
                  getTokenFCM();
                },
                splashColor: Colors.blue,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical:  10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: size.width,
                  height: 40,
                  child: const Text(
                    'Get token FCM',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Token FCM: $tokenFCM',
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      copyToken();
                    },
                    splashColor: Colors.blue,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: const Text(
                        'Copy',
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap:(){
                  _handleSignIn();
                },
                splashColor: Colors.blue,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical:  10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: size.width,
                  height: 40,
                  child: const Text(
                    'Login with google',
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  _handleSignOut();
                },
                splashColor: Colors.blue,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical:  10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: size.width,
                  height: 40,
                  child: const Text(
                    'Sign out google',
                  ),
                ),
              ),
              InkWell(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WebSocketScreen();
                  },));
                },
                splashColor: Colors.blue,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical:  10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  width: size.width,
                  height: 40,
                  child: const Text(
                    'Navigator',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
