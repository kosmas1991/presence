import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:present/cubits/tagread/tagread_cubit.dart';
import 'package:present/cubits/tagread/tagread_state.dart';

class SubmitPresentScreen extends StatefulWidget {
  const SubmitPresentScreen({super.key});

  @override
  State<SubmitPresentScreen> createState() => _SubmitPresentScreenState();
}

class _SubmitPresentScreenState extends State<SubmitPresentScreen> {
  bool tagRead = false;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  Map<String, dynamic> result = {};

  @override
  void initState() {
     context.read<TagreadCubit>().emitNewState(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            child: BlocBuilder<TagreadCubit, TagreadState>(
              builder: (context, state) {
                return !state.tagread
                    ? Column(
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
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 150,
                              height: 150,
                              child: FittedBox(
                                  child: Image.asset(
                                'assets/images/success.png',
                                fit: BoxFit.fill,
                              ))),
                          Text(
                            "Successfully read the tag!",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      );
              },
            )),
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
          fire
              .collection('submits')
              .doc('${result['1']} ${result['0']}')
              .set(result);
          context.read<TagreadCubit>().emitNewState(true);
        });
        result['date'] = DateTime.now();
      }

      //NfcManager.instance.stopSession();
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
        context.read<TagreadCubit>().emitNewState(false);
      });
    });
  }
}
