import 'package:bluedrip/config.dart';
import 'package:bluedrip/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String id = '';
  String name = '';
  String phone = '';
  @override
  void initState() {
    getlog();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    String url = CONFIG.SERVER + "images/profile/$id.png";
    GlobalKey<ScaffoldState> scakey = new GlobalKey<ScaffoldState>();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: scakey,
          drawer: Drawer(
            elevation: 10.0,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.grey.shade500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(url),
                        radius: 40.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            phone,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title:
                      Text('الصفحة الرئيسية ', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("home");
                  },
                ),
                Divider(height: 3.0),
                // ListTile(
                //   leading: Icon(Icons.settings),
                //   title: Text('الاعدادات', style: TextStyle(fontSize: 18)),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('تسجيل خروج', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    dellog();
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0XFFfefefe),
            leading: IconButton(
              onPressed: () {
                scakey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.short_text,
                size: 30,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("profile");
                },
                child: Container(
                    child: CircleAvatar(backgroundImage: NetworkImage(url))),
              ),
            ],
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("مرحبا,",
                      style: TextStyle(fontSize: 14, color: Color(0xffb9bfcd))),
                  Text(name, style: TextStyle(fontSize: 18)),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '\n  خدماتنا الطبية ',
                              style: TextStyle(
                                color: Color(0xFF25257E),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("hospital");
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    width: size.width * .2,
                                    height: size.width * .2,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF25257E).withAlpha(30),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.medical_services,
                                        color: Colors.white,
                                        size: size.width * .14,
                                      ),
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'مراكز تلقي الخدمة',
                                  style: TextStyle(
                                    color: Color(0xFF25257E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("mrecord");
                            },
                            child: Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: size.width * .2,
                                  height: size.width * .2,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF25257E).withAlpha(30),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.white,
                                      size: size.width * .14,
                                    ),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'السجل المرضي',
                                style: TextStyle(
                                  color: Color(0xFF25257E),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("hbook");
                            },
                            child: Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: size.width * .2,
                                  height: size.width * .2,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF25257E).withAlpha(30),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: size.width * .14,
                                    ),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                ' الحجوزات',
                                style: TextStyle(
                                  color: Color(0xFF25257E),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * .1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("emergencycase");
                            },
                            child: Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: size.width * .2,
                                  height: size.width * .2,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF25257E).withAlpha(30),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.emergency,
                                      color: Colors.white,
                                      size: size.width * .14,
                                    ),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'حالات الطوارئ',
                                style: TextStyle(
                                  color: Color(0xFF25257E),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("renewal");
                            },
                            child: Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: size.width * .2,
                                  height: size.width * .2,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF25257E).withAlpha(30),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.published_with_changes_outlined,
                                      color: Colors.white,
                                      size: size.width * .14,
                                    ),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'تجديد الاشتراك',
                                style: TextStyle(
                                  color: Color(0xFF25257E),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("adduser");
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    width: size.width * .2,
                                    height: size.width * .2,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF25257E).withAlpha(30),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.person_add,
                                        color: Colors.white,
                                        size: size.width * .14,
                                      ),
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'اضافة مستفيدين للتأمين',
                                  style: TextStyle(
                                    color: Color(0xFF25257E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getlog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      id = preferences.get("id").toString();
      name = preferences.get("name").toString();
      phone = preferences.get("phone").toString();
    });
  }
}
