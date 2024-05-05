import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
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
        Navigator.pop(context);
        Navigator.pop(context);
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
