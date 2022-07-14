import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bluedrip/config.dart';
import 'package:bluedrip/util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addcase extends StatefulWidget {
  addcase({Key? key}) : super(key: key);

  @override
  State<addcase> createState() => _addcaseState();
}

class _addcaseState extends State<addcase> {
  Uint8List? _imagebils;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _details = TextEditingController();
  void slectImagebils() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _imagebils = im;
    });
  }

  addCase() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nowdate = DateTime.now().toString();

    var response = await http.post(Uri.parse(CONFIG.emergencycase), body: {
      "apPassword": "bluedrip",
      "type": "insert",
      "details": _details.text,
      "title": _title.text,
      "date": nowdate,
      "patientID": preferences.getString("id"),
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
                Text("اضافة حالة ", style: TextStyle(color: Color(0xff8873f4))),
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
                height: size.height * .15,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _title,
                  decoration: InputDecoration(labelText: "عنوان الحالة"),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _details,
                  decoration: InputDecoration(labelText: "تفاصيل  الحالة "),
                ),
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
                      "تسجيل",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () async {
                    var response = await addCase();

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

                    Navigator.of(context).pushReplacementNamed("home");
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}
