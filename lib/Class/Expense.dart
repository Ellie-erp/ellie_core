import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

import 'PCMItem.dart';
import 'PCMSuppiler.dart';
enum EXPStatus {
  DRAFT,
  ACTIVE,
  DISABLE,
}




class Expense {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String seller;
  num? transportCost;
  EXPStatus expStatus;
num? total;
String? refNo;
String staffId;
String staffName;
String remark;


  Expense({this.docRef, required this.createDate, required this.updateDate, required this.seller ,this.transportCost, required this.expStatus , this.total, this.refNo,required this.staffId,required this.staffName, required this.remark});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,
    'expStatus' : EXPStatus.values.indexOf(this.expStatus),
    'total' : total,
    'refNo' : refNo,
    'staffId' : staffId,
    'staffName' : staffName,
    'remark' : remark,
      };

  factory Expense.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Expense(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      seller: doc.data()?['seller'],
      transportCost: doc.data()?['transportCost'] ?? 0,
      expStatus: EXPStatus.values.elementAt(doc.data()!['poStatus'] ?? 0),
      total: doc.data()?['total'] ?? 0,
      refNo: doc.data()?['refNo'] ?? '',
      staffId: doc.data()?['staffId'],
      staffName: doc.data()?['staffName'],
      remark: doc.data()?['remark'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






