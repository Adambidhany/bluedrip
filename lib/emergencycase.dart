import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class emergencycase extends StatefulWidget {
  emergencycase({Key? key}) : super(key: key);

  @override
  State<emergencycase> createState() => _emergencycaseState();
}

class _emergencycaseState extends State<emergencycase> {
  getemergencycase() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(CONFIG.emergencycase), body: {
      "apPassword": "bluedrip",
      "type": "select",
      "id": preferences.getString("id")
    });
    return json.decode(response.body);
  }

  delbook(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await http.post(Uri.parse(CONFIG.emergencycase), body: {
      "apPassword": "bluedrip",
      "type": "delete",
      "id": id.toString(),
      "patientID": preferences.getString("id")
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("حالات الطوارئ",
                style: TextStyle(color: Color(0xff8873f4))),
            elevation: 0,
            backgroundColor: Color(0XFFfefefe),
            iconTheme: IconThemeData(color: Color(0xff8873f4)),
            centerTitle: true,
          ),
          body: Container(
            child: ListView(children: [
              FutureBuilder(
                future: getemergencycase(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: ListTile(
                              subtitle: Text(snapshot.data[index]['date']),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(snapshot.data[index]['title']),
                                  snapshot.data[index]['response'] != 0
                                      ? Text("تم الرد")
                                      : Text("لم يتم الرد ")
                                ],
                              ),
                              trailing: Container(
                                width: snapshot.data[index]['response'] == 2
                                    ? 100
                                    : 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (snapshot.data[index]['response'] == 2)
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  actions: [
                                                    Image.network(
                                                      CONFIG.SERVER +
                                                          "images/emergencycase/${snapshot.data[index]['id']}-bils.png",
                                                      height: size.height * .7,
                                                      width: size.width,
                                                      fit: BoxFit.fill,
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.photo),
                                        color: Color(0xff8873f4),
                                      ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Text(
                                                      "هل انت متأكد انك تريد الغاء "),
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("الغاء ")),
                                                    TextButton(
                                                        onPressed: () {
                                                          delbook(snapshot
                                                                  .data[index]
                                                              ['id']);

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(" حذف "))
                                                  ]);
                                            });
                                      },
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: AlertDialog(
                                          content: Container(
                                            child: ListView(children: [
                                              ListTile(
                                                trailing: Text("الحالة "),
                                                title: Text(snapshot.data[index]
                                                    ['title']),
                                              ),
                                              ListTile(
                                                trailing:
                                                    Text("تاريخ الحالة  "),
                                                title: Text(snapshot.data[index]
                                                    ['date']),
                                              ),
                                              ListTile(
                                                trailing: Text("تفاصيل الحالة"),
                                                title: Text(snapshot.data[index]
                                                    ['details']),
                                              ),
                                              ListTile(
                                                trailing: Text(" الاستجابة"),
                                                title: Text(snapshot.data[index]
                                                    ['responseDatails']),
                                              ),
                                              if (snapshot.data[index]
                                                      ['response'] ==
                                                  2)
                                                Image.network(
                                                  CONFIG.SERVER +
                                                      "images/emergencycase/${snapshot.data[index]['id']}-bils.png",
                                                )
                                            ]),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("لا يوجد حالات");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed("addcase");
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xff8873f4),
          )),
    );
  }
}
