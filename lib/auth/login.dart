import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util.dart';
import 'logindb.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

GlobalKey<FormState> formlogin = new GlobalKey<FormState>();
final TextEditingController _userphone = TextEditingController();
final TextEditingController _userPassword = TextEditingController();
bool _obscureText = true;

class _loginState extends State<login> {
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkuser = prefs.getString("id");
    if (checkuser == null) {
    } else {
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
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
          body: Form(
        key: formlogin,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
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
            ListView(
              padding: EdgeInsets.only(top: size.width * .35),
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (text) {
                      if (text == "")
                        return " حقل اجباري";
                      else if (text!.length < 5)
                        return "ادخل  الرقم الصحيح";
                      else if (text.length > 15) return "الرقم اكثر من المطلوب";

                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _userphone,
                    decoration: InputDecoration(labelText: "رقم الهاتف"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
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
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: MaterialButton(
                    onPressed: () async {
                      if (formlogin.currentState!.validate()) {
                        pr = ProgressDialog(context,
                            type: ProgressDialogType.Normal,
                            isDismissible: true,
                            showLogs: true);
                        await pr.show();

                        var response = await logindb(
                          password: _userPassword.text,
                          phone: _userphone.text,
                        );

                        if (response['status'] == 'success') {
                          Fluttertoast.showToast(
                              msg: "Login Success",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          pr.hide().then((isHidden) {
                            print(isHidden);
                          });
                          Savelog(response);

                          Navigator.of(context).pushReplacementNamed("home");
                        } else if (response['status'] == "failed") {
                          Fluttertoast.showToast(
                              msg: "Login Failed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          pr.hide().then((isHidden) {
                            print(isHidden);
                          });
                        } else if (response['status'] == "notactive") {
                          Fluttertoast.showToast(
                              msg: "account not active",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          pr.hide().then((isHidden) {
                            print(isHidden);
                            Navigator.of(context)
                                .pushReplacementNamed("nactive");
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
                        "تسجيل دخول ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {Navigator.of(context).pushNamed("Register")},
                    child: Text(
                      "اضغط هنا اذا لم يكن لديك حساب مسبقا",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
