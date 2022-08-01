import 'dart:convert';
import 'package:end_sem_project/models/casesModel.dart';
import 'package:end_sem_project/screens/home_screen.dart';
import 'package:end_sem_project/screens/dashboard.dart';
import 'package:end_sem_project/screens/india.dart';
import 'package:end_sem_project/screens/world.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

class cases extends StatefulWidget {
  const cases({Key? key}) : super(key: key);

  @override
  State<cases> createState() => _casesState();
}

class _casesState extends State<cases> {
  var currentIndex=0;
  final String url = "https://corona.lmao.ninja/v2/all";
  var flag=0;
  Future <casesModel> getJsonData() async{
    var response = await http.get(
      Uri.parse(url)
    );
    if(response.statusCode==200){
      flag=1;
      final convertDataJSON = jsonDecode(response.body);
      return casesModel.fromJson(convertDataJSON);
    }
    else{
      flag=0;
      final convertDataJSON = jsonDecode(response.body);
      return casesModel.fromJson(convertDataJSON);
    }
  }
  @override
  void initState(){
    super.initState();
    getJsonData();
  }
  navigateToCountry() async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const world()));
  }
  navigateToState() async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const india()));
  }
  navigateToSpread(url) async{
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Text('      Worldwide Updates', style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),
                    Padding(padding: EdgeInsets.only(top: 5)),
                  ],
                ),
              ),
              Container(
                child: Card(color: const Color(0xFFFFFFFF),
                  child: ListTile(title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      Text("Total Cases", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),

                      Text("Recovered", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),

                      Text("Deaths", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  ),
                ),
              ),
              FutureBuilder<casesModel>(
                future: getJsonData(),
                builder: (BuildContext context, SnapShot)
                {
                  if(SnapShot.hasData){
                    final covid = SnapShot.data;
                    return Column(
                      children: <Widget>[
                        Card(
                          color: const Color(0xFFFFFFFF),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                const Padding(padding: EdgeInsets.all(1)),
                                Text("${covid!.cases}",style: const TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text("${covid!.recovered}", style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                                Text("${covid!.deaths}", style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  else if(SnapShot.hasError){
                    return Column(
                      children: <Widget>[
                        Card(
                          color: const Color(0xFFFFFFFF),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const <Widget>[
                                Text("581985710",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text("551982435", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                                Text("6419467", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                                //Padding(padding: EdgeInsets.only(right: 0)),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  else{
                    return const CircularProgressIndicator();
                    }
                }
              ),
              const Padding(padding: EdgeInsets.only(top: 2, left: 2)),

              const Padding(padding: EdgeInsets.only(top: 4)),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()=>navigateToCountry(),
                    child: Card(
                      child: Container(
                        height: 176,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const <Widget>[
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Image(image: AssetImage("assets/world.png"),
                                height: 90,width: 100,),
                              Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                              Text('Countrywise Statistics',style: TextStyle(fontSize: 14,color: Colors.black, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ),
                    GestureDetector(
                      onTap: ()=> navigateToState(),
                    child:  Card(
                      child: Container(
                        height: 176,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),

                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const <Widget>[
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Image(image: AssetImage("assets/india.png"),height: 90,width: 90,),
                              Padding(padding: EdgeInsets.all(10)),
                              Text("Indian\nStatewise Statistics", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text("Spread of Virus", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  OutlinedButton(
                    onPressed: () {
                      var url = Uri.parse('https://www.worldometers.info/coronavirus/');
                      navigateToSpread(url);
                    },
                    child: const Text('See details',style: TextStyle(fontSize: 15,color: Colors.black, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlueAccent,
                    boxShadow: [
                    BoxShadow(
                    offset: const Offset(0, 8),
                     blurRadius: 20,
                     color: kShadowColor,
                    ),
                  ],
                ),
                child: const Image(image: AssetImage("assets/41562_2021_1122_Fig1_HTML.png")),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 100)),
                  ElevatedButton.icon(
                    onPressed: () {
                      launch('tel:1075');
                    },
                    style: ButtonStyle(
                        minimumSize:
                        MaterialStateProperty.all(const Size(170, 50)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blue),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.white)))),
                    icon: const FaIcon(FontAwesomeIcons.phone,
                        color: Colors.white),
                    label: const Text('Call Helpline', style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                ],
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}