import 'dart:typed_data';
import 'package:bluedrip/auth/registerdb.dart';
import 'package:bluedrip/util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


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
        body: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //iamge backgroung
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/top1.png",
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/top2.png",
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              // Positioned(
              //   top: 50,
              //   left: 30,
              //   child: Image.asset("assets/images/main.png",
              //       width: size.width * 0.35),
              // ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/bottom1.png",
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/bottom2.png",
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              //the  tital of the page
              Form(
                key: form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.1),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "تسجيل",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),

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
                          title: Text("ارفاق صورة فاتورة الدفع"),
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
                              _imagebils != null
                              ) {


   pr = ProgressDialog(context,
                            type: ProgressDialogType.Normal,
                            isDismissible: true,
                            showLogs: true);
                        await pr.show();

                            String response = await registerdb(
                                address: _userAddress.text,
                                name: _userName.text,
                                password: _userPassword.text,
                                phone: _userphone.text,
                                birthdate: _birthdate.text,
                                profile: _image!,
                                bils: _imagebils!,
                                identy: _imageidenty!);
                            if (response.contains("success")) {
                              Fluttertoast.showToast(
                                  msg: "register Success",
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
                                  .pushReplacementNamed("nactive");
                            } else if (response.contains("failed")) {
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

                    //text under the button
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed("login");
                        },
                        child: Text(
                          "اضغط هنا اذا كان لديك حساب مسبقا",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2661FA)),
                        ),
                      ),
                    )
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
