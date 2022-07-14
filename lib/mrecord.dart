import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class mrecord extends StatefulWidget {
  mrecord({Key? key}) : super(key: key);

  @override
  State<mrecord> createState() => _mrecordState();
}

class _mrecordState extends State<mrecord> {
  getmrecord() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(CONFIG.mrecord),
        body: {"apPassword": "bluedrip", "id": preferences.getString("id")});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(" السجل المرضي", style: TextStyle(color: Color(0xff8873f4))),
          elevation: 0,
          backgroundColor: Color(0XFFfefefe),
          iconTheme: IconThemeData(color: Color(0xff8873f4)),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(children: [
            ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("التشخيص"),
                Text("المستشفى"),
                Text("عنوان المستشفى"),
                Text("التاريخ"),
              ],
            )),
            FutureBuilder(
              future: getmrecord(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(snapshot.data[index]['diagnosis']),
                                Text(snapshot.data[index]['name']),
                                Text(snapshot.data[index]['city']),
                                Text(snapshot.data[index]['date']),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        ListTile(
                                          trailing: Text("اسم المستشفى  "),
                                          title: Text(
                                              snapshot.data[index]['name']),
                                        ),
                                        ListTile(
                                          trailing: Text("التاريخ  "),
                                          title: Text(
                                              snapshot.data[index]['date']),
                                        ),
                                        ListTile(
                                          trailing: Text("العنوان"),
                                          title: Text(snapshot.data[index]
                                                  ['city'] +
                                              " " +
                                              snapshot.data[index]['address']),
                                        ),
                                        ListTile(
                                          trailing: Text("التشخيص"),
                                          title: Text(snapshot.data[index]
                                              ['diagnosis']),
                                        ),
                                        ListTile(
                                          trailing: Text("العلاج"),
                                          title: Text(snapshot.data[index]
                                              ['prescription']),
                                        ),
                                        ListTile(
                                          trailing: Text("تعليقات الطبيب  "),
                                          title: Text(
                                              snapshot.data[index]['comments']),
                                        ),
                                      ],
                                    );
                                  });
                            }),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
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
