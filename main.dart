import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dagitik/chatRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: login(),
    );
  }
}
class login extends StatelessWidget {
  login({Key? key}) : super(key: key);
  TextEditingController eposat=TextEditingController();
  TextEditingController sefre=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: eposat,
                decoration: InputDecoration(
                  hintText: "E-Posta"
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: sefre,
                decoration: InputDecoration(
                    hintText: "Sifre"
                ),
              ),
            ),
            InkWell(
              child: Container(
                width: 100,
                height: 40,
                color: Colors.blue,
                margin: EdgeInsets.all(20),
                child: Center(child: Text("giriş"))
              ),
              onTap: ()async{
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: eposat.text,
                      password: sefre.text
                  );
                  if(userCredential!=null){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (Users)=>MyHomePage()));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                    return null;
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                    return null;
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key, }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference userRef=FirebaseFirestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Dağıtık Sistemler"),
      ),
      body: ListView(
        children: [
          InkWell(
            child: Container(
                color: Colors.amberAccent,
                margin: EdgeInsets.all(10),
                height: 80,
                child: Row(children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    height: 80,width: 80,
                    color: Colors.cyanAccent,
                    child: Icon(Icons.person_rounded),
                  ),
                  Text("Dağıtık Sistem Odası", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,letterSpacing: 1,
                      fontFamily: "arefRuqaa"
                  ),)
                ],)
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoom()));
            },
          )
        ],
      )
    );
  }
}

