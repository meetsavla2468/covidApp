import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class world extends StatefulWidget {
  const world({Key? key}) : super(key: key);

  @override
  State<world> createState() => _worldState();
}

class _worldState extends State<world> {
  final String url = "https://corona.lmao.ninja/v2/countries/";
  late Future <List> datas;
  Future <List> getData() async{
    var response = await Dio().get(url);
    return response.data;
  }
  @override
  void initState(){
    super.initState();
    datas = getData();
  }

  Future showcard(String cases, death, recover) async{
    await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              backgroundColor: const Color(0xFF363636),
            shape: const RoundedRectangleBorder(),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Total Cases :$cases", style: const TextStyle(fontSize: 22, color: Colors.white),),
                  Text("Total Deaths :$death", style: const TextStyle(fontSize: 22, color: Colors.red),),
                  Text("Total Recovered :$recover", style: const TextStyle(fontSize: 22, color: Colors.green),),
                ],
              ),
            ),
          );
        }
     );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countrywise Statistics"),
        backgroundColor: const Color(0xFF152238),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding:const EdgeInsets.all(10),
        child: FutureBuilder(
          future: datas,
          builder: (BuildContext context, SnapShot){
            if(SnapShot.hasData){
              return GridView.builder(
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: 230,
                itemBuilder: (BuildContext context, index)=>SizedBox(
                  height: 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: ()=> showcard(
                        (SnapShot.data as dynamic)[index]['cases'].toString(),
                        (SnapShot.data as dynamic)[index]['deaths'].toString(),
                        (SnapShot.data as dynamic)[index]['recovered'].toString(),
                      ),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  <Widget>[
                                const Padding(padding: EdgeInsets.only(top: 8)),
                                Text("Total Cases :${(SnapShot.data as dynamic)[index]['cases'].toString()}",
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                const Padding(padding: EdgeInsets.only(top: 2)),
                                const Image(image: AssetImage("assets/wdeath.png"),height: 80, width: 85,),
                                Text((SnapShot.data as dynamic)[index]['country'], style: const TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),),
                                const Padding(padding: EdgeInsets.only(top: 8)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ),
              );
            }
            else{
              return GridView.builder(
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: 230,
                itemBuilder: (BuildContext context, index)=>SizedBox(
                  height: 50,
                  width: 50,
                  child: GestureDetector(
                    onTap: ()=> showcard(
                      "40679",
                      "4325",
                      "35669",
                    ),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:  const <Widget>[
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Text("Total Cases : Cases",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              Padding(padding: EdgeInsets.only(top: 2)),
                              Image(image: AssetImage("assets/wdeath.png"),height: 80, width: 85,),
                              Text("Country Name", style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),),
                              Padding(padding: EdgeInsets.only(top: 8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}