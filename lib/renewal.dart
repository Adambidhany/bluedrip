import 'dart:convert';
import 'dart:typed_data';
import 'package:bluedrip/config.dart';
import 'package:http/http.dart' as http;
import 'package:bluedrip/util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class renewal extends StatefulWidget {
  renewal({Key? key}) : super(key: key);

  @override
  State<renewal> createState() => _renewalState();
}

class _renewalState extends State<renewal> {
  Uint8List? _imagebils;
  void slectImagebils() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _imagebils = im;
    });
  }

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nowdate = DateTime.now().add(Duration(days: 365)).toString();

    var response = await http.post(Uri.parse(CONFIG.update), body: {
      "apPassword": "bluedrip",
      "id": preferences.getString("id"),
      "insuranceExDate": nowdate,
      "bils": base64Encode(_imagebils!)
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title:
                Text("اعادة تجديد", style: TextStyle(color: Color(0xff8873f4))),
            elevation: 0,
            backgroundColor: Color(0XFFfefefe),
            iconTheme: IconThemeData(color: Color(0xff8873f4)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: size.height * .10,
              ),
              Container(
                  alignment: Alignment.center,
                  child: ListTile(
                    onTap: slectImagebils,
                    leading: Icon(Icons.add_a_photo),
                    trailing: _imagebils != null
                        ? Icon(Icons.check)
                        : Icon(Icons.clear),
                    title: Text("ارفاق صورة فاتورة الدفع"),
                  )),
              Container(
                margin: EdgeInsets.all(30),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(255, 169, 20, 238),
                          Color.fromARGB(255, 77, 79, 219)
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "تجديد",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () async {
                    var response = await update();

                    if (response['status'] == 'success') {
                      Fluttertoast.showToast(
                          msg: " تم الحفظ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    dellog();
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}
