import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessClient {
  DocumentReference? docRef;
  DateTime createDate;
  String? orgName;
  String orgNameEn;
  String tel;
  String address;




  BusinessClient({this.docRef, required this.createDate, this.orgName,required this.orgNameEn ,required this.tel,required this.address,});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'orgName': orgName,
        'orgNameEn': orgNameEn,
        'tel': tel,
        'address': address,


      };
  factory BusinessClient.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BusinessClient(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      orgName: doc.data()!['orgName'],
      orgNameEn: doc.data()!['orgNameEn'],
      tel: doc.data()!['tel'],
      address: doc.data()!['address'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}