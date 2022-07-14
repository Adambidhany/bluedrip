import 'dart:async';
import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:bluedrip/util.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class hospital extends StatefulWidget {
  hospital({Key? key}) : super(key: key);

  @override
  State<hospital> createState() => _hospitalState();
}

class _hospitalState extends State<hospital> {
  List<Hospital> hpital = [];
  String query = '';
  Timer? debouncer;
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  final TextEditingController _bookdate = TextEditingController(
      text: DateTime.now().subtract(Duration(days: 7300)).toString());
  final TextEditingController _comments = TextEditingController();
  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    _bookdate.dispose();
    _comments.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final hpital = await HospitalApi.getHospital(query);

    setState(() => this.hpital = hpital);
  }

  addbook(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(CONFIG.bookmark), body: {
      "apPassword": "bluedrip",
      "type": "insert",
      "hospitalID": id.toString(),
      "comments": _comments.text,
      "date": _bookdate.text,
      "patientID": preferences.getString("id")
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0XFFfefefe),
            actions: [
              buildSearch(),
            ],
            iconTheme: IconThemeData(color: Color(0xff8873f4)),
            centerTitle: true,
          ),
          body: hpital.length == 0
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: hpital.length,
                        itemBuilder: (context, index) {
                          final hopital = hpital[index];

                          return buildHospital(hopital);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      );
  Widget buildSearch() => Container(
        height: 55,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
            hintText: "ابحث عن مستشفى",
            hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            suffixIcon: SizedBox(
                width: 50, child: Icon(Icons.search, color: Color(0xff8873f4))),
          ),
          onChanged: searchHospital,
        ),
      );

  Future searchHospital(String query) async => debounce(() async {
        final Hospital = await HospitalApi.getHospital(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.hpital = Hospital;
        });
      });

  Widget buildHospital(Hospital hopital) => ListTile(
        title: Text(hopital.name),
        subtitle: Text("النوع: " +
            hopital.type +
            "\n" +
            "التخصص : " +
            hopital.Specialization +
            "\n" +
            "العنوان : " +
            hopital.address +
            " " +
            hopital.city),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff8873f4), width: .1)),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.bookmark_add, color: Color(0xff8873f4)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                                content: Container(
                                  height: 150,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: DateTimePicker(
                                            type: DateTimePickerType
                                                .dateTimeSeparate,
                                            //dateMask: 'yyyy/MM/dd',
                                            controller: _bookdate,
                                            //initialValue: _initialValue,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                            icon: Icon(Icons.event),
                                            dateLabelText: 'BirthDate',

                                            onChanged: (val) => setState(
                                                () => _valueChanged3 = val),
                                            validator: (val) {
                                              setState(() => _valueToValidate3 =
                                                  val ?? '');
                                              return null;
                                            },
                                            onSaved: (val) => setState(
                                                () => _valueSaved3 = val ?? ''),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            controller: _comments,
                                            decoration: InputDecoration(
                                                labelText:
                                                    " اضافت اي تفاصيل اخرى"),
                                          ),
                                        ),
                                      ]),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("الغاء الحجز")),
                                  TextButton(
                                      onPressed: () async {
                                        var response =
                                            await addbook(hopital.id);

                                        if (response['status'] == 'success') {
                                          Fluttertoast.showToast(
                                              msg: " تم الحجز",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                        _comments.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(" تسجيل الموعد"))
                                ]),
                          );
                        });
                  }),
              IconButton(
                  icon: Icon(Icons.phone, color: Color(0xff8873f4)),
                  onPressed: () {
                    launchUrl(Uri.parse("tel:" + hopital.phone));
                  }),
            ],
          ),
        ),
      );
}
