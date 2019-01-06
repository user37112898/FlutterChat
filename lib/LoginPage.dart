import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatapplication/ChatScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async{
    print("okay google");
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    FirebaseUser user = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );
    print("Sign in by "+user.displayName);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatScreen(user.displayName,user.photoUrl)));
    return user;
  }

  void _handleSignOut(){
    googleSignIn.signOut();
  }

  Widget loginScreen(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text("Login"),
            onPressed: () => _handleSignIn().then((FirebaseUser user) => print(user)).catchError((e)=>print(e)),
          ),
          RaisedButton(
            onPressed: _handleSignOut,
            child: Text("SignOut"),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        centerTitle: true,
      ),
      body: loginScreen(),
    );
  }
}