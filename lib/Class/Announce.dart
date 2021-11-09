import 'package:cloud_firestore/cloud_firestore.dart';

class Announce {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String? subtitle;




  Announce({this.docRef, required this.createDate, required this.title, this.subtitle});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'subtitle': subtitle,


      };
  factory Announce.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Announce(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      title: doc.data()!['title'],
      subtitle: doc.data()!['subtitle'] ?? '',


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
