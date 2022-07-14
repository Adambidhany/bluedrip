import 'package:bluedrip/config.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name = "";
  var id;
  final TextEditingController _id = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();
  final TextEditingController _insuranceExDate = TextEditingController();

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name")!;

      _id.text = prefs.getString("id")!;
      id = prefs.getString("id")!;
      _address.text = prefs.getString("address")!;
      _phone.text = prefs.getString("phone")!;
      _birthdate.text = prefs.getString("birthdate")!;
      _insuranceExDate.text = prefs.getString("insuranceExDate")!;
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    _id.dispose();
    _address.dispose();
    _birthdate.dispose();
    _insuranceExDate.dispose();
    _phone.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(39, 105, 171, 1),
          shadowColor: Color.fromRGBO(39, 105, 171, 0),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(4, 9, 35, 1),
                    Color.fromRGBO(39, 105, 171, 1),
                  ],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.43,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double innerHeight = constraints.maxHeight;
                            double innerWidth = constraints.maxWidth;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: innerHeight * 0.72,
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 80,
                                        ),
                                        Text(
                                          _name,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(39, 105, 171, 1),
                                            fontFamily: 'Nunito',
                                            fontSize: 37,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      actions: [
                                                        Center(
                                                          child: QrImage(
                                                            data: id,
                                                            version:
                                                                QrVersions.auto,
                                                            size: 300.0,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.qr_code, size: 40))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      child: Image.network(
                                        CONFIG.SERVER +
                                            'images/profile/$id.png',
                                        width: width * 0.45,
                                        height: height * 0.25,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: height * 0.5,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text("رقم التأمين:"),
                                      Flexible(
                                        child: TextField(
                                          controller: _id,
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text("العنوان:"),
                                      Flexible(
                                        child: TextField(
                                          controller: _address,
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text("الهاتف:"),
                                      Flexible(
                                        child: TextField(
                                          controller: _phone,
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(" تاريخ الميلاد:"),
                                      Flexible(
                                        child: TextField(
                                          controller: _birthdate,
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text("صلاحية التأمين:"),
                                      Flexible(
                                        child: TextField(
                                          controller: _insuranceExDate,
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
