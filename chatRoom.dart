
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController mesag = TextEditingController();
  CollectionReference chatref = FirebaseFirestore.instance.collection("Chats");
  CollectionReference userRef=FirebaseFirestore.instance.collection("Users");
  var user = FirebaseAuth.instance.currentUser!.uid;
  var username;
  getUserData()async{
    // ignore: unused_local_variable
    DocumentReference documentReference=
    userRef.doc(FirebaseAuth.instance.currentUser!.uid);
    var snap = await documentReference.get();
    username= snap["ad"];
  }

  setMessage(String message)async{
    int time= DateTime.now().millisecondsSinceEpoch;

    await chatref.add({
      "sender" : user,
      "message" : message,
      "time" : time,
      "sendername":username
    });
  }
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dağıtık Sistemler"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:chatref.orderBy('time',descending: true).snapshots() ,
                builder: (context,AsyncSnapshot snap){
                  if(snap.hasData){
                    return ListView.builder(
                      reverse: true,
                      itemCount: snap.data.docs.length,
                      itemBuilder: (context,i){
                        if(snap.data.docs[i]["sender"]==user){
                          return Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width*0.80,
                                  ),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0x97A394FF),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                    child: Text("${snap.data.docs[i]["message"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18),
                                    )
                                )
                              ],
                            ),
                          );
                        }else{
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("${snap.data.docs[i]["sendername"]}"),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                    ),
                                    Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width*0.70,
                                        ),
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Color(0x97A394FF),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Text("${snap.data.docs[i]["message"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );;
                        }
                      },
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            ),Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: mesag,
                      decoration: InputDecoration(
                        hintText: "Mesag"
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        child: Container(
                            child: Icon(Icons.send)
                        ),
                      onTap: (){
                          if(mesag.text.isNotEmpty){
                            setMessage(mesag.text);
                            mesag.clear();
                          }
                      },
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
