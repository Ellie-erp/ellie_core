import 'package:cloud_firestore/cloud_firestore.dart';

import 'Info.dart';

enum TermType{
  Term,
  QA,
}

/// Term & Q&A content for the website.
/// Under Firebase/Location(eShop)/OSTerm

class OSTerm {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String title;
  String content;
  InfoStatus infoStatus;
  TermType termType;




  OSTerm({this.docRef, required this.createDate,required this.updateDate,required this.title , required this.content, required this.infoStatus, required this.termType});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'title': title,
        'content': content,
    'infoStatus' : InfoStatus.values.indexOf(this.infoStatus),
    'termType' : TermType.values.indexOf(this.termType),

      };
  factory OSTerm.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return OSTerm(
      docRef: doc.reference,
      infoStatus: InfoStatus.values.elementAt(doc.data()?['infoStatus'] ?? 0),
      termType: TermType.values.elementAt(doc.data()?['termType'] ?? 0),
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      title: doc.data()?['title'],
      content: doc.data()?['content'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
