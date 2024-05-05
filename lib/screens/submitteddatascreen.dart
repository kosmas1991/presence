import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SubmittedDataScreen extends StatelessWidget {
  const SubmittedDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore fire = FirebaseFirestore.instance;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('submitted data'),
              StreamBuilder(
                stream: fire.collection('submits').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data!.docs.length,
                        itemBuilder: (context, index) {
                          var data2 = data.docs[index].data();
                          return Text(
                              '${data2['0'].toString()} ${data2['1'].toString()} ${timeago.format(data2['date'].toDate())}');
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
