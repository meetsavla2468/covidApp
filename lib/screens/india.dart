import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class india extends StatefulWidget {
  const india({Key? key}) : super(key: key);

  @override
  State<india> createState() => _indiaState();
}

class _indiaState extends State<india> {
  late Future <List> datas;
  final String url = "https://api.rootnet.in/covid19-in/stats/latest";
  Future <List> getData() async{
    var response  = await Dio().get(url);
    return response.data['data']['regional'];
  }

  @override
  void initState() {
    super.initState();
    datas = getData();
  }
  Future showcardstate(String cases, death, recover) async{
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
        title: const Text('Statewise Statistics'), backgroundColor: const Color(0xFF152238),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: FutureBuilder(
          future: datas,
          builder: (BuildContext context, SnapShot)
          {
            if(SnapShot.hasData){
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 36,
                  itemBuilder: (BuildContext context, index)=>SizedBox(
                    height: 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: ()=> showcardstate(
                        (SnapShot.data as dynamic)[index]['totalConfirmed'].toString(),
                        (SnapShot.data as dynamic)[index]['deaths'].toString(),
                        (SnapShot.data as dynamic)[index]['discharged'].toString(),
                      ),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(padding: EdgeInsets.only(top: 4)),
                              Text("Cases : ${(SnapShot.data as dynamic)[index]['totalConfirmed'].toString()}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              const Image(image: AssetImage("assets/cases.png"),height: 84, width: 84,),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Text("${(SnapShot.data as dynamic)[index]['loc']}",
                                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}