import 'package:flutter/material.dart';

class nactive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/Something Wrong.jpg",
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  "تم التسجيل لكن الحساب غير مفعل بعد",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
