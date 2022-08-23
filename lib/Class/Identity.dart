import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female }

///人事部,用作日後 身份認証,出糧,請假用
class Identity {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String engName;
  String chineseName;
  String? accountId;
  String tel;
  String address;
  Gender gender;

  Identity(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.engName,
      required this.chineseName,
      this.accountId,
      this.tel = '',
      this.address = '',
      required this.gender});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'engName': engName,
        'chineseName': chineseName,
        'accountId': accountId,
        'tel': tel,
        'address': address,
        'gender': Gender.values.indexOf(gender),
      };
  factory Identity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Identity(
        docRef: doc.reference,
        createDate: doc.data()!['createDate']?.toDate(),
        updateDate: doc.data()!['updateDate']?.toDate(),
        engName: doc.data()!['engName'],
        chineseName: doc.data()!['chineseName'],
        accountId: doc.data()!['accountId'],
        tel: doc.data()!['tel'],
        address: doc.data()!['address'],
        gender: Gender.values.elementAt(doc.data()!['gender'] ?? 0));
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
