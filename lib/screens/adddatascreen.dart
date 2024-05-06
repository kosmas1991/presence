import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:present/cubits/tagread/tagread_cubit.dart';
import 'package:present/cubits/tagread/tagread_state.dart';
import 'package:present/widgets/textfield.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  late Future<bool> isAvailable;

  String result = '';
  @override
  void initState() {
    isAvailable = NfcManager.instance.isAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController1 = TextEditingController();
    TextEditingController textEditingController2 = TextEditingController();
    context.read<TagreadCubit>().emitNewState(false);

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: isAvailable,
          builder: (context, snapshot) {
            print('NFC availability -> ${snapshot.data}');
            if (snapshot.hasData) {
              return snapshot.data! == true
                  ? Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyFormField(
                              hintText: 'first name',
                              textEditingController: textEditingController1),
                          SizedBox(
                            height: 20,
                          ),
                          MyFormField(
                              hintText: 'last name',
                              textEditingController: textEditingController2),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                              onPressed: () {
                                writeDataToTag(
                                    context: context,
                                    firstname: textEditingController1.text,
                                    lastname: textEditingController2.text);
                              },
                              icon: Icon(Icons.send),
                              label: Text('Send'))
                        ],
                      ),
                    )
                  : Center(child: Text('No NFC support'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void writeDataToTag(
      {required BuildContext context,
      required String firstname,
      required String lastname}) {
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
                          "Data sent to NFC tag",
                          style: TextStyle(fontSize: 15),
                        ),

                      ],
                    );
            },
          ),
        ),
      ),
    );
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(firstname),
        NdefRecord.createText(lastname),
      ]);

      try {
        await ndef.write(message);
        result = 'Success to "Ndef Write"';
        //NfcManager.instance.stopSession();
        context.read<TagreadCubit>().emitNewState(true);
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } catch (e) {
        result = e.toString();
        NfcManager.instance.stopSession(errorMessage: result.toString());

        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }
    });
  }
}
