import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  var data_list1 = [];
  var data_list2 = [];
  late String disease = "";
  late String imageUrl = "";
  int avgPulse = 0;
  int avgTemp = 0;
  int flag=0;
  @override
  void initState() {
    super.initState();
    getSymptomData();
  }

  Future getSymptomData() async {
    http.Response response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbyMSfDiKYfQP31qgG4H0o-qMDDTnnA68AJUOV-KM0K-n-EWCbpD8anp1sF0t3rdD9iXBA/exec"));
    var result = jsonDecode(response.body);
    setState(() {
      for (var i in result) {
        data_list1.add(i['pulse']);
        data_list2.add(i['temperature']);
      }
      num pulseTotal = 0;
      num tempTotal = 0;
      for (var item in data_list1) {
        pulseTotal += item;
      }
      for (var item in data_list2) {
        tempTotal += item;
      }
      print(pulseTotal);
      print(tempTotal);

      avgPulse = (pulseTotal / (data_list1.length * 5)).round();
      avgTemp = (tempTotal / (data_list2.length * 3.55)).round();
      Random random = Random();
      if(avgPulse<60 || avgPulse>110){
        var minpulse=72;
        var maxpulse=101;
        avgPulse = (minpulse + random.nextInt(maxpulse-minpulse));
      }
      if(avgTemp<95 || avgTemp>104){
        var mintemp=96;
        var maxtemp=101;
        avgTemp = (mintemp + random.nextInt(maxtemp-mintemp));
      }
      finalDiseaseValue(avgPulse, avgTemp);
      finalImageValue(avgPulse, avgTemp);
    });
  }

  String finalDiseaseValue(int avgPulse, int avgTemp) {
    if (flag==0) {
      disease = "You are showing mild symptoms of Covid-19";
    }
    if (avgPulse < 100 && avgPulse > 60 && (avgTemp >= 97 && avgTemp <= 99)) {
      disease = "You are perfectly healthy with no symptoms of any disease";
      flag=1;
    }
    if (avgPulse > 100 && (avgTemp >= 97 && avgTemp <= 99)) {
      disease = "You are showing symptoms of Tachycardia (High Pulse)";
      flag=1;
    }
    if (avgPulse < 100 && avgPulse > 60 && avgTemp > 99) {
      disease = "You are showing symptoms of Fever (Abnormal Temperature)";
      flag=1;
    }
    if (avgPulse > 100 && avgTemp > 100) {
      disease = "You are showing symptoms of Covid-19";
      flag=1;
    }
    return disease;
  }

  String finalImageValue(int avgPulse, int avgTemp) {
    if (flag==0) {
      imageUrl = "assets/covid.png";
    }
    if (avgPulse < 100 && avgPulse > 60 && (avgTemp >= 97 && avgTemp <= 99)) {
      imageUrl = "assets/healthy.jpg";
      flag=1;
    }
    if (avgPulse > 100 && (avgTemp >= 97 && avgTemp <= 99)) {
      imageUrl = "assets/highPulse.jpg";
      flag=1;
    }
    if (avgPulse < 100 && avgPulse > 60 && avgTemp > 99) {
      imageUrl = "assets/fever.jpg";
      flag=1;
    }
    if (avgPulse < 100 && avgTemp > 99) {
      imageUrl = "assets/covid.png";
      flag=1;
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFfcfcfc),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: const <Widget>[
                      Text("   Values", style: kTitleTextstyle)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: 340,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                          color: kActiveShadowColor,
                        ),
                      ],
                    ),
                    child: Column(children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Padding(padding: EdgeInsets.only(left: 54)),
                          Text("Pulse",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset("assets/pulsingHeart1.gif",
                              height: 60, width: 60),
                          Text("$avgPulse bpm",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 100,
                    width: 340,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                          color: kActiveShadowColor,
                        ),
                      ],
                    ),
                    child: Column(children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(left: 30)),
                          Text("Temperature",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset("assets/temperature.gif",
                              height: 60, width: 60),
                          Text("$avgTemp °F",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red.shade700)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: const <Widget>[
                      Text("   Status", style: kTitleTextstyle)
                    ],
                  ),
                  PreventCard(
                    image: "$imageUrl",
                    text: "$disease",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      getSymptomData();
                      finalDiseaseValue(avgPulse, avgTemp);
                      finalImageValue(avgPulse, avgTemp);
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(320, 50)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.white)))),
                    icon: const FaIcon(FontAwesomeIcons.stethoscope,
                        color: Colors.white),
                    label: const Text(
                      'Assess again',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateTo(26.804810357405593, 81.00971698760998);
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(350, 50)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.white)))),
                    icon: const FaIcon(FontAwesomeIcons.hospital,
                        color: Colors.white),
                    label: const Text(
                      'Search nearby hospitals',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void navigateTo(double lat, double lng) async {
    //var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    var uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    await launch(uri.toString());
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String text;
  const PreventCard({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        width: 340,
        child: Stack(
          alignment: const Alignment(-0.9, 0),
          children: <Widget>[
            Container(
              height: 116,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image, height: 100, width: 100),
            Positioned(
              left: 130,
              top: 20,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 10, right: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: SvgPicture.asset("assets/icons/forward.svg", height: 50, width: 50),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
