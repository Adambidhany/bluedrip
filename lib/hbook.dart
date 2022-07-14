import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class hbook extends StatefulWidget {
  hbook({Key? key}) : super(key: key);

  @override
  State<hbook> createState() => _hbookState();
}

class _hbookState extends State<hbook> {
  gethbook() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(CONFIG.bookmark), body: {
      "apPassword": "bluedrip",
      "type": "select",
      "id": preferences.getString("id")
    });
    return json.decode(response.body);
  }

  delbook(String id) async {
    await http.post(Uri.parse(CONFIG.bookmark),
        body: {"apPassword": "bluedrip", "type": "delete", "id": id});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("مواعيد الحجوزات",
              style: TextStyle(color: Color(0xff8873f4))),
          elevation: 0,
          backgroundColor: Color(0XFFfefefe),
          iconTheme: IconThemeData(color: Color(0xff8873f4)),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(children: [
            FutureBuilder(
              future: gethbook(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(snapshot.data[index]['name']),
                                Text(snapshot.data[index]['date']),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text(
                                              "هل انت متأكد انك تريد الغاء الحجز"),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("الغاء ")),
                                            TextButton(
                                                onPressed: () {
                                                  delbook(snapshot.data[index]
                                                          ['bookid']
                                                      .toString());
                                                  Navigator.of(context)
                                                      .pushNamed("home");
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(" حذف الموعد"))
                                          ]);
                                    });
                              },
                              icon: Icon(Icons.bookmark_remove,
                                  color: Color(0xff8873f4)),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: AlertDialog(
                                        content: Container(
                                          height: 250,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ListTile(
                                                  trailing:
                                                      Text("اسم المستشفى  "),
                                                  title: Text(snapshot
                                                      .data[index]['name']),
                                                ),
                                                ListTile(
                                                  trailing:
                                                      Text("تاريخ الحجز  "),
                                                  title: Text(snapshot
                                                      .data[index]['date']),
                                                ),
                                                ListTile(
                                                  trailing: Text("العنوان"),
                                                  title: Text(snapshot
                                                          .data[index]['city'] +
                                                      " " +
                                                      snapshot.data[index]
                                                          ['address']),
                                                ),
                                                ListTile(
                                                  trailing:
                                                      Text("تفاصيل الحجز"),
                                                  title: Text(snapshot
                                                      .data[index]['comments']),
                                                ),
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
                  return Text("لا يوجد حجوزات");
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ]),
        ),
      ),
    );
  }
}
