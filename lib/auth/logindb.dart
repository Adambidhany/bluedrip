import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:http/http.dart' as http;

Future logindb({
  required String password,
  required String phone,
}) async {
  var rsponse ;
  var uri = CONFIG.login;
  await http.post(Uri.parse(uri), body: {
    "password": password,
    "phone": phone,
    "apPassword": "bluedrip"
  }).then((response) {
    rsponse = json.decode(response.body);
  });
  return rsponse;
}
