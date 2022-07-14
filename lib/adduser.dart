import 'dart:convert';
import 'dart:typed_data';
import 'package:bluedrip/config.dart';
import 'package:bluedrip/util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class adduser extends StatefulWidget {
  adduser({Key? key}) : super(key: key);

  @override
  State<adduser> createState() => _adduserState();
}

class _adduserState extends State<adduser> {
  GlobalKey<FormState> form = new GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  final TextEditingController _userAddress = TextEditingController();
  final TextEditingController _userphone = TextEditingController();

  final TextEditingController _birthdate = TextEditingController(
      text: DateTime.now().subtract(Duration(days: 7300)).toString());
  Uint8List? _image;
  Uint8List? _imageidenty;
  Uint8List? _imagebils;
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  bool _obscureText = true;
  void slectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void slectImageidenty() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _imageidenty = im;
    });
  }

  void slectImagebils() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _imagebils = im;
    });
  }

  @override
  void dispose() {
    _userphone.dispose();
    _userPassword.dispose();
    _birthdate.dispose();
    _userAddress.dispose();
    _userName.dispose();

    super.dispose();
  }

  adduserdb() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(CONFIG.adduser), body: {
      "name": _userName.text,
      "password": _userPassword.text,
      "insuranceExDate": preferences.getString("insuranceExDate"),
      "birthdate": _birthdate.text,
      "address": _userAddress.text,
      "phone": _userphone.text,
      "status": "0",
      "profile": base64Encode(_image!),
      "bils": base64Encode(_imagebils!),
      "identy": base64Encode(_imageidenty!),
      "parentID": preferences.getString("id"),
      "apPassword": "bluedrip"
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: 'Login...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(" اضافة مستفيدين ",
              style: TextStyle(color: Color(0xff8873f4))),
          elevation: 0,
          backgroundColor: Color(0XFFfefefe),
          iconTheme: IconThemeData(color: Color(0xff8873f4)),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //iamge backgroung

              //the  tital of the page
              Form(
                key: form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.03),
                    //image
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: _image == null
                          ? CircleAvatar(
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: slectImage,
                                  icon: Icon(Icons.add_a_photo)),
                              radius: 60,
                              backgroundImage:
                                  AssetImage("assets/images/avatar.jpg"))
                          : CircleAvatar(
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: slectImage,
                                  icon: Icon(Icons.add_a_photo)),
                              radius: 60,
                              backgroundImage: MemoryImage(_image!)),
                    ),

                    //textformfiled for username
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (text) {
                          if (text == "")
                            return " حقل اجباري";
                          else if (text!.length < 10)
                            return "ادخل الاسم بالكامل";
                          else if (text.length > 100)
                            return "الاسم اكثر من المطلوب";

                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: _userName,
                        decoration: InputDecoration(labelText: "الاسم"),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    //textformfiled for phone number
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (text) {
                          if (text == "")
                            return " حقل اجباري";
                          else if (text!.length < 5)
                            return "ادخل  الرقم الصحيح";
                          else if (text.length > 15)
                            return "الرقم اكثر من المطلوب";

                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        controller: _userphone,
                        decoration: InputDecoration(labelText: "رقم الهاتف"),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    //textformfiled for phone adress
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (text) {
                          if (text == "")
                            return " حقل اجباري";
                          else if (text!.length < 5)
                            return "ادخل العنوان الصحيح";
                          else if (text.length > 100)
                            return "الاسم اكثر من المطلوب";

                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        controller: _userAddress,
                        decoration: InputDecoration(labelText: "العنوان"),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    //textformfiled for phone password
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (text) {
                          if (text == "")
                            return " حقل اجباري";
                          else if (text!.length < 5)
                            return "قصيرة جدا";
                          else if (text.length > 25) return "طويلة جدا";

                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: _userPassword,
                        decoration: InputDecoration(
                            labelText: "كلمة السر",
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(Icons.visibility),
                            )),
                        obscureText: _obscureText,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    //the birthdate picker
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        //dateMask: 'yyyy/MM/dd',
                        controller: _birthdate,
                        //initialValue: _initialValue,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'BirthDate',

                        onChanged: (val) =>
                            setState(() => _valueChanged3 = val),
                        validator: (val) {
                          setState(() => _valueToValidate3 = val ?? '');
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _valueSaved3 = val ?? ''),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    //identy image upload
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          trailing: _imageidenty != null
                              ? Icon(Icons.check)
                              : Icon(Icons.clear),
                          onTap: slectImageidenty,
                          leading: Icon(Icons.add_a_photo),
                          title: Text("ارفاق صورة الهوية"),
                        )),
                    SizedBox(height: size.height * 0.05),
                    //bills image upload
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          onTap: slectImagebils,
                          leading: Icon(Icons.add_a_photo),
                          trailing: _imagebils != null
                              ? Icon(Icons.check)
                              : Icon(Icons.clear),
                          title: Text("ارفاق صورة اثبات الصلة"),
                        )),
                    SizedBox(height: size.height * 0.05),
                    //sigin button
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: MaterialButton(
                        onPressed: () async {
                          if (form.currentState!.validate() &&
                              _imageidenty != null &&
                              _image != null &&
                              _imagebils != null) {
                            pr = ProgressDialog(context,
                                type: ProgressDialogType.Normal,
                                isDismissible: true,
                                showLogs: true);
                            await pr.show();

                            var response = await adduserdb();
                            if (response['status'] == "success") {
                              Fluttertoast.showToast(
                                  msg: "adduser Success",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              pr.hide().then((isHidden) {
                                print(isHidden);
                              });

                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            } else if (response['status'] == "failed") {
                              Fluttertoast.showToast(
                                  msg: "regiser Failed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              pr.hide().then((isHidden) {
                                print(isHidden);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: " connect error",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              pr.hide().then((isHidden) {
                                print(isHidden);
                              });
                            }
                          }
                        },
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
