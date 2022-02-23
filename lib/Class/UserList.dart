import 'package:cloud_firestore/cloud_firestore.dart';


/// a user list mananging the current user who registered in the ERP system. For interApp uses such as order taking.
/// NOT for managing the account detail/authentication/


class UserList {
  DocumentReference? docRef;
  DateTime createDate;
  String? displayName;
  String? email;
  num? credit;
List<DelAddress>? delAddress;



  UserList({this.docRef,required this.createDate, this.displayName, this.email, this.delAddress, this.credit});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'displayName': displayName,
        'email': email,
    'delAddress': (delAddress ?? []).map((e) => e.toMap).toList(),
    'credit': credit,

      };
  factory UserList.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserList(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      displayName: doc.data()!['displayName']?? 'Undefined',
      email: doc.data()!['email']?? '',
      delAddress: List<DelAddress>.from((doc.data()?['delAddress'] ?? []).map((e) => DelAddress.fromMap(e)).toList()),
      credit: doc.data()!['credit'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






class DelAddress {
  String? address;
  String? remark;


  DelAddress({this.address, this.remark});

  Map<String, dynamic> get toMap => {
    'address': address,
    'remark': remark,

  };

  factory DelAddress.fromMap(Map<String, dynamic> map) {
    return DelAddress(
      address: map['address'],
      remark: map['remark'],

    );
  }}




class CreditRecord {
  DocumentReference? docRef;
  DateTime timestamp;
  num amount;
  String? remark;




  CreditRecord({this.docRef, required this.timestamp,required this.amount, this.remark});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'amount': amount,
        'remark': remark,


      };
  factory CreditRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CreditRecord(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp'],
      amount: doc.data()?['amount'],
      remark: doc.data()?['remark'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
