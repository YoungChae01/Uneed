import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolSchedule extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<SchoolSchedule> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("DB에 데이터 추가/읽기/갱신/삭제"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton( // 데이터 추가
              child: Text("create button", style: TextStyle(color : Colors.red)),
              onPressed: () async {
                String subject = "공학수학";
                DocumentReference docRef = firestore.collection('test').doc(subject);
                await docRef.set({'학년': 2, '학기': 1, '교수명':'양재환 교수님'});
              },
            ),
            ElevatedButton( // 데이터 읽기
              child: Text("read button", style: TextStyle(color : Colors.orange)),
              onPressed: (){
                String name = "";
                firestore.collection("test").doc("수질화학").get()
                    .then((DocumentSnapshot ds) {
                  Map<String, dynamic>? data = ds.data() as Map<String, dynamic>?;  // 타입 명시적으로 지정
                  if (data != null) {
                    name = data["교수명"];
                    print(name);
                  }
                });
              },
            ),
            ElevatedButton( // 데이터 갱신
              child: Text("update button", style: TextStyle(color : Colors.green)),
              onPressed: (){
                firestore.collection("test").doc("환경기초공학설계")
                    .update({"학년":2});
              },
            ),
            ElevatedButton( // 데이터 삭제
              child: Text("delete button", style: TextStyle(color : Colors.blue)),
              onPressed: (){
                //특정 document 전체 삭제
                firestore.collection("test").doc("삭제할문서").delete();
                //특정 document 의 field 하나를 삭제
                firestore.collection('test').doc('수질화학').update({'삭제할필드': FieldValue.delete()});
              },
            ),
          ],
        ),
      ),
    );
  }
}