import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:bluedrip/config.dart';

Future registerdb({
  required String name,
  required String password,
  required Uint8List profile,
  required String birthdate,
  required String address,
  required String phone,
  required Uint8List bils,
  required Uint8List identy,
}) async {
  var nowdate = DateTime.now().toString();
  var uri = CONFIG.regsiter;
  String rsponse = "";
  await http.post(Uri.parse(uri), body: {
    "name": name,
    "password": password,
    "insuranceExDate": nowdate,
    "birthdate": birthdate,
    "address": address,
    "phone": phone,
    "status": "0",
    "profile": base64Encode(profile),
    "bils": base64Encode(bils),
    "identy": base64Encode(identy),
   "apPassword": "bluedrip"
  }).then((response) {
    rsponse = json.decode(response.body).toString();
  });

  return rsponse;
}
