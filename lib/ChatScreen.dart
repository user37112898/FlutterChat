import 'package:flutter/material.dart';
import 'ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  String displayName;
  String displayUrl;
  ChatScreen(this.displayName,this.displayUrl);
  @override
  _ChatScreenState createState() => _ChatScreenState(displayName,displayUrl);
}

class _ChatScreenState extends State<ChatScreen> {

  String displayName;
  String displayUrl;

  _ChatScreenState(this.displayName,this.displayUrl);

  CollectionReference collectionReference =
      Firestore.instance.collection("myChat");
  final DocumentReference documentReference =
      Firestore.instance.document("Mychat/doc");

  final List<ChatMessage> messages = <ChatMessage>[];

  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollContoller = ScrollController(initialScrollOffset: 500);

  double scrollLength =0 ;

  void handleSubmitted(String text) async {
    print("\n\nstart");
    Map<String, String> data = <String, String>{"user": displayName,"message":text,"userDpUrl":displayUrl};
    collectionReference.add(data);
//    documentReference.setData(data).whenComplete(() {
//      print("Data added");
//    }).catchError((e) => print(e));

    Future<QuerySnapshot> cm = collectionReference.getDocuments();
    textEditingController.clear();
    ChatMessage temp = ChatMessage(text);
    setState(() {
      messages.insert(0, temp);
    });
    scrollContoller.jumpTo(scrollLength);
  }

//  void jumpToLast(double scrollLength){
//    scrollContoller.jumpTo(scrollLength);
//  }

  @override
  Widget build(BuildContext context) {

    const double padding = 7.0;
    const double height = 16.0;

    return Scaffold(
      
      appBar: AppBar(
        title: Text("FlutterChat"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(child: Image.network(displayUrl,fit: BoxFit.cover,height: 20, width: 20,),),
        ),
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.lightBlueAccent.withOpacity(0.1),Colors.blueAccent.withOpacity(0.3),])
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding,vertical: 5.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // TODO make changges here
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("myChat").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  print(snapshot.data.documents.map((document)=> document).toList());
                  print(snapshot.data.documents.map);

                  return snapshot.data.documents == null?
                  CircularProgressIndicator(

                  )
                  :
                  Flexible(
                    child: ListView(
                      controller: scrollContoller,
                      children: snapshot.data.documents.map((DocumentSnapshot document){
                        double extraHeight = ((document['message'].toString().length)/25).toDouble();
                        scrollLength += 11+(2*padding)+height+(height*extraHeight);
                        return Container(
                          height: 11+(2*padding)+height+(height*extraHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: padding),
                                child: document['user'] != displayName
                                ?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ClipOval(child: Image.network(document['userDpUrl'],fit: BoxFit.cover,height: 38,),),
                                    Expanded(child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 50, 0),
                                      child: Container(height: (height)+(height*extraHeight),child: Text(document['message'],textAlign: TextAlign.left,),),
                                    )),
                                  ],
                                )
                                :
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(child: Padding(
                                      padding: const EdgeInsets.fromLTRB(100, 0, 10, 0),
                                      child: Container(height: (height)+(height*extraHeight),child: Text(document['message'],textAlign: TextAlign.left,),),
                                    )),

                                  ],
                                )
                                ,
                                //Container(height: 25+(17*extraHeight),child: Text(document['message'],textAlign: TextAlign.left,),),
                              ),
                              Divider(height: 1,)
                            ],
                          )
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.3),Colors.lightBlueAccent.withOpacity(0.3)],),
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        decoration: InputDecoration(hintText: "Enter Text..."),
                        controller: textEditingController,
                      )),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => handleSubmitted(textEditingController.text),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}