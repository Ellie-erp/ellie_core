import 'package:cloud_firestore/cloud_firestore.dart';

enum Department {
  GENERAL,
  RETAIL,
  WHOLESALE,
  ESHOP,
  PCM,
  ACCOUNTING,

}

class Announce {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String? subtitle;
  Department department;





  Announce({this.docRef, required this.createDate, required this.title, this.subtitle, required this.department});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'subtitle': subtitle,
    'department' : Department.values.indexOf(this.department),



      };
  factory Announce.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Announce(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      title: doc.data()!['title'],
      subtitle: doc.data()!['subtitle'] ?? '',
      department: Department.values.elementAt(doc.data()?['department'] ?? 0),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
