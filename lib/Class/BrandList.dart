import 'package:cloud_firestore/cloud_firestore.dart';

class BrandList {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String name;
  String? detail;




  BrandList({this.docRef, required this.createDate, required this.updateDate, required this.name ,this.detail,});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'name': name,
        'detail': detail,


      };
  factory BrandList.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BrandList(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      name: doc.data()!['name'],
      detail: doc.data()!['detail'] ?? '',


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}