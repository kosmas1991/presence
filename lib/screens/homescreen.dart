import 'package:flutter/material.dart';
import 'package:present/screens/adddatascreen.dart';
import 'package:present/screens/submitpresent.dart';
import 'package:present/screens/submitteddatascreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDataScreen(),
                          ));
                    },
                    icon: Icon(Icons.abc),
                    label: Text('Send my data to NFC tag'))),
            Center(
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmitPresentScreen(),
                          ));
                    },
                    icon: Icon(Icons.person),
                    label: Text('Submit my presence'))),
            Center(
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmittedDataScreen(),
                          ));
                    },
                    icon: Icon(Icons.data_array),
                    label: Text('Show submitted data'))),
          ],
        ),
      ),
    );
  }
}
