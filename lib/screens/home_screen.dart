import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
import 'package:curved_drawer_fork/curved_drawer_fork.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUserModel = UserModel();

  @override
  void initState() {
    signInWithGoogle();
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedUserModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  navigateToWHO(url) async {
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
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.white,
        color: Colors.blue.shade400,
        animationDuration: const Duration(milliseconds: 299),
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          Icon(
            Icons.monitor_heart,
            color: Colors.black,
          ),
          Icon(
            Icons.paste_outlined,
            color: Colors.black,
          ),
          Icon(
            Icons.lightbulb,
            color: Colors.black,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          "Covid Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              logout();
            },
            shape:
                const CircleBorder(side: BorderSide(color: Colors.transparent)),
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 124,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      googleSignIn
                          ? "$userName"
                          : "${loggedUserModel.firstName}  ${loggedUserModel.lastName}",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Check Symptoms", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Analyse your body symptoms', style: TextStyle(color: Colors.grey,  fontSize: 16)),
              trailing: const Icon(Icons.health_and_safety_outlined),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const dashboard()));
              },
            ),
              const Divider(thickness: 1.2),
            ListTile(
              title: const Text('Call Helpline - 1075', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Reach out for help', style: TextStyle(color: Colors.grey, fontSize: 16)),
              trailing: const Icon(Icons.call),
              onTap: () {
                launch('tel:1075');
              },
            ),
            const Divider(thickness: 1.2),
            ListTile(
              title: const Text('MythBusters', style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Get clear answer for doubts', style:  TextStyle(color: Colors.grey, fontSize: 16)),
              trailing: const Icon(Icons.lightbulb_outline),
              onTap: () {
                var url = Uri.parse(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
                navigateToWHO(url);
              },
            ),
            const Divider(thickness: 1.2),
            ListTile(
              title: const Text('Download data', style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('See all the data fetched by sensors', style:  TextStyle(color: Colors.grey, fontSize: 16)),
              trailing: const Icon(Icons.file_copy),
              onTap: () {
                var url = Uri.parse(
                    'https://docs.google.com/spreadsheets/d/e/2PACX-1vTIApXnoXRo8XHjMIuG2gjvGjO_-ys7pYmULlJZkc24613sTRnTTNVG9q3UhoIt9ASmT6K1kJGEULF_/pubhtml');
                navigateToWHO(url);
              },
            ),
            const Divider(thickness: 1.2),
            ListTile(
              title: const Text('Update profile', style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Update your profile details', style:  TextStyle(color: Colors.grey, fontSize: 16)),
              trailing: const Icon(Icons.account_circle),
              onTap: () {
                var url = Uri.parse(
                    'https://myaccount.google.com/personal-info?hl=en');
                googleSignIn
                    ? navigateToWHO(url)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const updateProfile()));
              },
            ),
            const Divider(thickness: 1.2),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
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

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
