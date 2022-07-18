import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:end_sem_project/models/user_mode.dart';
import 'package:end_sem_project/screens/cases.dart';
import 'package:end_sem_project/screens/dashboard.dart';
import 'package:end_sem_project/screens/mythbusters.dart';
import 'package:end_sem_project/screens/updateProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:end_sem_project/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUserModel = UserModel();

  @override
  void initState(){
    signInWithGoogle();
    super.initState();

    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value){
          this.loggedUserModel = UserModel.fromMap(value.data());
          setState((){});
    });
  }

  navigateToWHO(url) async{
      await launchUrl(url);
  }
  int currentIndex = 0;
  bool googleSignIn = false;
  String? userEmail = "";
  String? userImageURL;
  String? userName = "Login";
  final screens = [
    const dashboard(),
    const cases(),
    const mythBusters(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text("Covid Tracker", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              logout();
            },
            child: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  [
           SizedBox(
             height: 104,
             child: DrawerHeader(
              decoration:const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: <Widget>[
                  Text(googleSignIn? "$userName"  : "${loggedUserModel.firstName}  ${loggedUserModel.lastName}",
                style: const TextStyle(color: Colors.black),),
               ],
             ),
           ),
           ),
            ListTile(
              title:const Text('Check Symptoms'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const dashboard()));
              },
            ),
            ListTile(
              title:const Text('Call Helpline - 1075'),
              onTap: () {
                launch('tel:1075');
              },
            ),
            ListTile(
              title:const Text('MythBusters'),
              onTap: () {
                var url = Uri.parse('https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
                navigateToWHO(url);
              },
            ),
            ListTile(
              title:const Text('Download Sensor data'),
              onTap: (){
                var url = Uri.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vTIApXnoXRo8XHjMIuG2gjvGjO_-ys7pYmULlJZkc24613sTRnTTNVG9q3UhoIt9ASmT6K1kJGEULF_/pubhtml');
                navigateToWHO(url);
              },
            ),
            ListTile(
              title:const Text('Update profile'),
              onTap: (){
                var url = Uri.parse('https://myaccount.google.com/personal-info?hl=en');
                googleSignIn?  navigateToWHO(url): Navigator.push(context, MaterialPageRoute(builder: (context)=>const updateProfile()));
              },
            ),
         ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        elevation: 5,
        onTap: (index) => setState(() =>currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart, color: Colors.white,), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.paste_outlined,color: Colors.white,), label: 'Cases'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb,color: Colors.white,),label: "FAQ's"),
         ],
        ),

      );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    userEmail = googleUser?.email;
    userImageURL = googleUser?.photoUrl;
    // print(userImageURL);
    setState(() {
      userName = googleUser?.displayName;
      googleSignIn = true;
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> logout() async{
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }
}