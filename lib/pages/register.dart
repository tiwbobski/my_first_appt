import 'dart:convert';
import 'dart:math' hide log;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customers_register_post_req.dart';
import 'package:my_first_app/model/request/response/customers_register_post_res.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = "";
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController confirmPassCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ชื่อ-นามสกุล'),
                  TextField(
                    controller: nameCtl,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('หมายเลขโทรศัพท์'),
                  TextField(
                    controller: phoneCtl,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('อีเมล์'),
                  TextField(
                    controller: emailCtl,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รหัสผ่าน'),
                  TextField(
                    controller: passCtl,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ยืนยันรหัสผ่าน'),
                  TextField(
                    controller: confirmPassCtl,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {
                register();
              },
              child: Text('สมัครสมาชิก'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text('หากมีบัญชีอยู่แล้ว?'), Text('เข้าสู่ระบบ')],
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    if (passCtl.text == confirmPassCtl.text) {
      CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
        fullname: nameCtl.text,
        phone: phoneCtl.text,
        email: emailCtl.text,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOuxrvcNMfGLh73uKP1QqYpKoCB0JLXiBMvA&s",
        password: passCtl.text,
      );
      http
          .post(
            Uri.parse("$url/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerRegisterPostRequestToJson(req),
          )
          .then((value) {
            log(value.body);
            CustomerRegisterPostReponse customerRegisterPostReponse =
                customerRegisterPostReponseFromJson(value.body);
            log(customerRegisterPostReponse.register.phone);
            log(customerRegisterPostReponse.message);
          })
          .catchError((error) {
            log('Error $error');
          });
    }
  }

  void back() {
    Navigator.pop(context);
  }
}
