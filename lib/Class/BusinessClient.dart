import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessClient {
  DocumentReference? docRef;
  DateTime createDate;
  String orgName;
  String orgNameEn;
  String tel;
  String address;
  DateTime updateDate;
  String? staffId;
  String? staffName;




  BusinessClient({this.docRef, required this.createDate,required this.orgName,required this.orgNameEn ,required this.tel,required this.address, required this.updateDate, this.staffName, this.staffId});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'orgName': orgName,
        'orgNameEn': orgNameEn,
        'tel': tel,
        'address': address,
    'updateDate' : updateDate,
    'staffId': staffId,
    'staffName' : staffName,


      };
  factory BusinessClient.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BusinessClient(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      orgName: doc.data()!['orgName'],
      orgNameEn: doc.data()!['orgNameEn'],
      tel: doc.data()!['tel'],
      address: doc.data()!['address'],
     updateDate: doc.data()!['updateDate']?.toDate(),
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}



class BCBranch {
  DocumentReference? docRef;
  String branchName;
  String? tel;
  String? address;
  String? contactName;
DateTime createDate;
DateTime updateDate;



  BCBranch({this.docRef,required  this.branchName, this.tel, this.address ,this.contactName, required this.createDate, required this.updateDate});
  Map<String, dynamic> get toMap => {
        'branchName': branchName,
        'tel': tel,
        'address': address,
        'contactName': contactName,
    'createDate': createDate,
    'updateDate' : updateDate,
      };
  factory BCBranch.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BCBranch(
      docRef: doc.reference,
      branchName: doc.data()!['branchName'],
      tel: doc.data()!['tel']?? '',
      address: doc.data()!['address']?? '',
      contactName: doc.data()!['contactName']?? '',
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}