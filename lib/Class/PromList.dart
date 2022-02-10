
import 'package:cloud_firestore/cloud_firestore.dart';


///Class for list of promotion used  for promotion announcement on eshop, ElliePass, POS, reference use.
///also for grouping traditional promotion rules setting, easier to control

class PromList {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String title;
  String? content;
  DateTime startDate;
  DateTime endDate;




  PromList({this.docRef,required this.createDate,required this.updateDate,required this.title ,this.content, required this.startDate, required this.endDate});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'title': title,
        'content': content,
    'startDate' : startDate,
    'endDate' : endDate,


      };
  factory PromList.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromList(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      title: doc.data()!['title'],
      content: doc.data()!['content'] ?? '',
      startDate: doc.data()!['startDate']?.toDate()  ?? DateTime.now(),
      endDate: doc.data()!['endDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
