import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:my_project/main.dart';
import 'package:my_project/src/pages/login.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var token = "";
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _data = [];

  String uri = 'https://makalam.com/api/articles/';
  bool _isLoading = false;
  bool determinate = false;

  @override
  void initState() {
    super.initState();
    if (uri != ''){
        _loadData();
      }
    _checkToken();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        if (uri != ''){
          _loadData();
        }
      }
    });
  }
  callbackFunc(str) async {
    setState(() {
      token = str;
    });
  }
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(uri);
    var response = await http.get(url,
        headers: {'Content-Type': 'application/json',
        'X-Firebase-AppCheck': 'eyJraWQiOiJRNmZ5eEEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOjczMDk1OTUyOTQ1NTp3ZWI6NjM3ZGEyZTgyNmU1ZGYzMjY0YTIxYSIsImF1ZCI6WyJwcm9qZWN0c1wvNzMwOTU5NTI5NDU1IiwicHJvamVjdHNcL21ha2FsYW0iXSwicHJvdmlkZXIiOiJyZWNhcHRjaGFfZW50ZXJwcmlzZSIsImlzcyI6Imh0dHBzOlwvXC9maXJlYmFzZWFwcGNoZWNrLmdvb2dsZWFwaXMuY29tXC83MzA5NTk1Mjk0NTUiLCJleHAiOjE3MjQ0MTcwNzIsImlhdCI6MTcyNDQxMzQ3MiwianRpIjoiQkEwYWNaWmNZYXlPTDVoY2xDVzlzaWlCV1ZIWUxZb0twbEhmbkFWaDhRUSJ9.I-59xDwz-8ZVYuIJ4KqJLcSM2SLqy2ZCfl7T8f3T_tN-0pSEmuiGP29LUEqNXkGh2kkvXqHDlT3poKy8BYnUHlZ1LLkGXK7DD4LmR-h8kjyQYSr3xnu5da0okgFFPIxcEvKdMdOLC4nNVZj3riLQ_HYVQB0bP_T3ciAtePjWcSE-bz08_eOESJg5KgPSKps_phAR6n3KiL2qZ_1nmTCSf3iSsBbadpoCDFbAlcSEDFl_6jhkNron8WZ6KkGP8SRraGM2CYHQ3SIdBANqLpChszcMBXsz23BAFLo6i91cBkSZ7pVbRq_wGDODDKPR7JetwbkAr1sTJvkc6g2LJbfFxwPd1gzMCA7_JjGw61sa72XM_Y3DUnzYeRORfqNZljbenb1ZPYxK0Jp4HYqqY-NqMq4QgQ3y38r7uALOXJiw8DrdpNPfSfRHllim08oJ3z0NSYuPGA7XRBhcna351AVSSnCWv5xWQr4qagZg4jf5ni2ci7fKCUsERR2rjQchI8NQ',});
    
    if (response.statusCode == 200){
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
      determinate = true;
      _data.addAll(json['results']);
      _isLoading = false;
      if (json['next'] != null){
        uri = json['next'];
      } else {
        uri = '';
      }
    });
    }
  }

  Future<void> _checkToken() async {    
    var allRows = await dbHelper.queryAllRows();
    var data = [];
    for (final row in allRows) {
      data.add(row);
    }
    if (data.isNotEmpty) {
      setState(() {
        token = data[0]['token']; 
      });
    }
    debugPrint('token $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 27, 44, 0.8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
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
        actions: token == "" ? [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  Login(title: "Makalam", callbackFunc: callbackFunc)));
                },
            child: const Text('Gir ',
            style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          const Text('Hasap aç ',
          style: TextStyle(
                color: Colors.white,
                fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
        ] : [
          GestureDetector(
            onTap: () async {
                await dbHelper.deleteAllRows();
                 setState(() {
                  token = '';
                });
              },
            child: const Text('Ulgamdan çyk ',
            style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemCount: _data.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _data.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 14, 80, 133), Color.fromARGB(255, 16, 11, 44)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      ),
              border: Border.all(color: Colors.white, width: 1, ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(4, 4), 
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(10,2,10,2),
            height: 100,
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Expanded(flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(_data[index]['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                    )),
                    Expanded(
                      flex: 2,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Text(_data[index]['author']['first_name'] + ' ' + _data[index]['author']['last_name'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          ),),

                        Expanded(child: Text(_data[index]['published_date_humanized'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          ),)
                      ],
                    )
                  ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                         Expanded(child: 
                          Row(
                            children: [
                              const Icon(
                                Icons.comment_sharp,
                                size: 15,
                                color: Colors.white,
                              ),
                              Text("  ${_data[index]['comment_count']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ),
                        Expanded(child: 
                          Row(
                            children: [
                              const Icon(
                                Icons.visibility_sharp,
                                size: 15,
                                color: Colors.white,
                              ),
                              Text("  ${_data[index]['view_count']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ),

                        Expanded(child: 
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 15,
                                color: Colors.white,
                              ),
                              Text("  ${_data[index]['like_count']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    )
                  ),
                ],
              )
            ),
                Expanded(flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(1,4,1,4,),
                  child: Image.network(_data[index]['author']['avatar']),
                  )),],
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}