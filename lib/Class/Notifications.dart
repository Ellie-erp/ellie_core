
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum NoticeType {
  POS,
  PCM,
  WHOLESALE,
}


class Notifications {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String? subtitle;
  NoticeType noticeType;
  String get noticeTypeName => describeEnum(noticeType);



  Notifications({this.docRef, required this.createDate,required this.title, this.subtitle,required this.noticeType});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'subtitle': subtitle,
    'noticeType' : NoticeType.values.indexOf(this.noticeType),

      };
  factory Notifications.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Notifications(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      title: doc.data()?['title'],
      subtitle: doc.data()?['subtitle'],
      noticeType: NoticeType.values.elementAt(doc.data()?['noticeType'] ?? 0),

    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
