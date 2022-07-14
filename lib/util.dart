import 'dart:convert';
import 'package:bluedrip/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

Savelog(var user) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("id", user['id'].toString());
  preferences.setString("name", user['name']);
  preferences.setString("phone", user['phone']);
  preferences.setString("address", user['address']);
  preferences.setString("birthdate", user['birthdate']);
  preferences.setString("insuranceExDate", user['insuranceExDate']);
}

dellog() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
}

class Hospital {
  final String id;
  final String name;
  final String phone;
  final String type;
  final String Specialization;
  final String city;
  final String address;

  const Hospital({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.Specialization,
    required this.city,
    required this.address,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json['id'].toString(),
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        type: json['type'],
        Specialization: json['Specialization'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'phone': phone,
        'type': type,
        'Specialization': Specialization,
        'city': city,
      };
}

class HospitalApi {
  static Future<List<Hospital>> getHospital(String query) async {
    final url = Uri.parse(CONFIG.hospital);
    final response = await http.post(url, body: {"apPassword": "bluedrip"});

    if (response.statusCode == 200) {
      final List hospitals = json.decode(response.body);

      return hospitals.map((json) => Hospital.fromJson(json)).where((hospital) {
        final String hname = hospital.name;
        final String hcity = hospital.city;
        final String haddress = hospital.address;
        final String hSpecialization = hospital.Specialization;
        final String htype = hospital.type;
        final searchLower = query;

        return hname.contains(searchLower) ||
            hcity.contains(searchLower) ||
            hSpecialization.contains(searchLower) ||
            htype.contains(searchLower) ||
            haddress.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
