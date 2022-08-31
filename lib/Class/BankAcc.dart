import 'package:cloud_firestore/cloud_firestore.dart';

class BankAcc {
  DocumentReference? docRef;
  DateTime createDate;
  String bankName;
  String accName;
  String accNo;
  bool isActive;
  DateTime updateDate;


  BankAcc({
    this.docRef,
    required this.createDate,
    required this.bankName,
    required this.accName,
    required this.accNo,
    this.isActive=true,
    required this.updateDate,
  });
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'bankName': bankName,
        'accName': accName,
        'accNo': accNo,
    'isActive' : isActive,
    'updateDate': updateDate,
      };
  factory BankAcc.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BankAcc(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      bankName: doc.data()!['bankName'],
      accName: doc.data()!['accName'],
      accNo: doc.data()!['accNo'],
      isActive: doc.data()!['isActive']?? true,
      updateDate: doc.data()!['updateDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
