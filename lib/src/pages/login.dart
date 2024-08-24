import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:my_project/main.dart';
import 'package:my_project/src/database/init.dart';
import 'package:my_project/src/widgets/alert.dart';


class Login extends StatefulWidget {
  const Login({super.key, required this.title, required this.callbackFunc});
  final String title;
  final Function callbackFunc;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isChecked = false; 
  bool determinate = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(204, 20, 28, 45),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Row(
          children: [
            const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            const SizedBox(width: 10,),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white
            ),
          ),
          ],
        ),
      ),
      body: !determinate ? Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 60,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(20, 27, 44, 0.8),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hasabyňyza giriň',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'Ulanyjy ady',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF374151),
                         filled: true,
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 165, 165, 165)),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(7.0),),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                          }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters long';
                          }
                        return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                      'Parol',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10,),
                  TextFormField(
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration:  InputDecoration(
                        suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      fillColor: const Color(0xFF374151),
                      filled: true,
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 165, 165, 165)),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 10.0),
                        borderRadius: BorderRadius.circular(7.0),),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                          }
                        if (value.length < 3) {
                          return 'Password must be at least 3 characters long';
                          }
                        return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          activeColor: Colors.white,
                          checkColor: const Color(0xFF020617),
                          value: _isChecked,
                          onChanged: _toggleCheckbox,
                        ),
                        const Text('Meni ýatla',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      ],
                    ),
                    const Text('Paroly unutdyňyzmy?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 125, 125, 128),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  SizedBox(
                    width: double.infinity, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF374151),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                      onPressed: () {
                        login();
                        setState(() {determinate = true;});
                      },
                      child: const Text('Gir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Häzirem hasabyňyz ýokmy? Hasap aç',
                        style: TextStyle(
                          color: Color.fromARGB(255, 125, 125, 128),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ): const Center(child: CircularProgressIndicator(
        color: Colors.white))
    );
  }

  void login() async {
    try {
    String uri = "https://makalam.com/api/authentication/token/";
    final url = Uri.parse(uri);

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json',
        'X-Firebase-AppCheck': 'eyJraWQiOiJRNmZ5eEEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOjczMDk1OTUyOTQ1NTp3ZWI6NjM3ZGEyZTgyNmU1ZGYzMjY0YTIxYSIsImF1ZCI6WyJwcm9qZWN0c1wvNzMwOTU5NTI5NDU1IiwicHJvamVjdHNcL21ha2FsYW0iXSwicHJvdmlkZXIiOiJyZWNhcHRjaGFfZW50ZXJwcmlzZSIsImlzcyI6Imh0dHBzOlwvXC9maXJlYmFzZWFwcGNoZWNrLmdvb2dsZWFwaXMuY29tXC83MzA5NTk1Mjk0NTUiLCJleHAiOjE3MjQ0MTcwNzIsImlhdCI6MTcyNDQxMzQ3MiwianRpIjoiQkEwYWNaWmNZYXlPTDVoY2xDVzlzaWlCV1ZIWUxZb0twbEhmbkFWaDhRUSJ9.I-59xDwz-8ZVYuIJ4KqJLcSM2SLqy2ZCfl7T8f3T_tN-0pSEmuiGP29LUEqNXkGh2kkvXqHDlT3poKy8BYnUHlZ1LLkGXK7DD4LmR-h8kjyQYSr3xnu5da0okgFFPIxcEvKdMdOLC4nNVZj3riLQ_HYVQB0bP_T3ciAtePjWcSE-bz08_eOESJg5KgPSKps_phAR6n3KiL2qZ_1nmTCSf3iSsBbadpoCDFbAlcSEDFl_6jhkNron8WZ6KkGP8SRraGM2CYHQ3SIdBANqLpChszcMBXsz23BAFLo6i91cBkSZ7pVbRq_wGDODDKPR7JetwbkAr1sTJvkc6g2LJbfFxwPd1gzMCA7_JjGw61sa72XM_Y3DUnzYeRORfqNZljbenb1ZPYxK0Jp4HYqqY-NqMq4QgQ3y38r7uALOXJiw8DrdpNPfSfRHllim08oJ3z0NSYuPGA7XRBhcna351AVSSnCWv5xWQr4qagZg4jf5ni2ci7fKCUsERR2rjQchI8NQ',
        },
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text
        }));
      
      debugPrint(_usernameController.text);
      debugPrint(_passwordController.text);

    if (response.statusCode == 200) {
      debugPrint('Success: ${response.body}');
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> row = { DatabaseSQL.columnName: json['token']};
      await dbHelper.insert(row);

      widget.callbackFunc(json['token']);
      setState(() {
        determinate = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      
    } else {
      debugPrint('Failed with status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      setState(() {
        determinate = false;
      });
      // ignore: use_build_context_synchronously
      showConfirmationDialogError(context);
    }
  } catch (e) {
    debugPrint('Error: $e');
  } 
  }

   showConfirmationDialogError(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const ErrorAlert();
      },
    );
  }
}


