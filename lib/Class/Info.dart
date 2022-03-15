import 'package:cloud_firestore/cloud_firestore.dart';

enum Department {
  GENERAL,
  RETAIL,
  WHOLESALE,
  ESHOP,
  PCM,
  ACCOUNTING,
  IT,
}

enum InfoStatus {
  ACTIVE,
  DRAFT,
}

enum InfoType { Announcement, Guideline }

class Info {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String title;
  String? content;
  InfoType infoType;
  InfoStatus infoStatus;
  Department department;

  Info(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.title,
      this.content,
      required this.infoType,
      required this.infoStatus,
      required this.department});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'title': title,
        'content': content,
        'infoType': InfoType.values.indexOf(this.infoType),
        'infoStatus': InfoStatus.values.indexOf(this.infoStatus),
        'department': Department.values.indexOf(this.department),
      };
  factory Info.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Info(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      title: doc.data()!['title'],
      content: doc.data()!['content'] ?? '',
      infoType: InfoType.values.elementAt(doc.data()?['infoType'] ?? 0),
      infoStatus: InfoStatus.values.elementAt(doc.data()?['infoStatus'] ?? 1),
      department: Department.values.elementAt(doc.data()?['department'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
