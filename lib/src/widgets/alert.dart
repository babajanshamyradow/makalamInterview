import 'package:flutter/material.dart';

class ErrorAlert extends StatefulWidget {
  const ErrorAlert({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: const SizedBox(
          width: 80,
          height: 180,
          child: Column(
            children: [
              Center(child: Icon(Icons.warning, size: 130, color: Colors.red)),
              Text(
                'Bagyşlan Ulanyjy adyňyz ýa-da parolyňyz nädogry!',
                textAlign: TextAlign.center,
              ),
            ],
          )),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF020617),
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'Close');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
