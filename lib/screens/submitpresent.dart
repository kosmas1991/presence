import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SubmitPresentScreen extends StatefulWidget {
  const SubmitPresentScreen({super.key});

  @override
  State<SubmitPresentScreen> createState() => _SubmitPresentScreenState();
}

class _SubmitPresentScreenState extends State<SubmitPresentScreen> {
  FirebaseFirestore fire = FirebaseFirestore.instance;
  Map<String, dynamic> result = {};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result.toString(),
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    _tagRead(context: context);
                  },
                  icon: Icon(Icons.person),
                  label: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }

  void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  void _tagRead({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context2) => Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterLogo(
                size: 150,
              ),
              Text(
                "Approach NFC tag to the device",
                style: TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          ),
        ),
      ),
    );


        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Ndef? ndefvariable = Ndef.from(tag);
      if (ndefvariable == null) {
        print('Tag is not compatible with NDEF');
        return;
      } else {
     ndefvariable.read().then((NdefMessage message) {
          int counter = 0;
          message.records.map((NdefRecord record) {
            setState(() {
              result['${counter}'] =
                  String.fromCharCodes(record.payload, 3, 100);
            });
            counter++;
          }).toList();
          fire.collection('submits').doc('${result['1']} ${result['0']}').set(result);
        });
        result['date'] = DateTime.now();
      }

      //NfcManager.instance.stopSession();
      Navigator.pop(context);
      Navigator.pop(context);
    });

  }
}
