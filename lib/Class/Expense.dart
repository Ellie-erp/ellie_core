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
  Currency currency;
num rate;

num? adjAmount;
String? refNo;


  Expense({this.docRef, required this.createDate, required this.updateDate, required this.seller ,this.transportCost, required this.expStatus,this.currency=Currency.HKD ,this.rate=1, this.adjAmount, this.refNo});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,

    'expStatus' : EXPStatus.values.indexOf(this.expStatus),
    'currency': Currency.values.indexOf(this.currency),

    'rate' : rate,

    'adjAmount' : adjAmount,
    'refNo' : refNo,
      };

  factory Expense.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Expense(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      seller: doc.data()?['seller'],
      transportCost: doc.data()?['transportCost'] ?? 0,

      expStatus: EXPStatus.values.elementAt(doc.data()!['poStatus'] ?? 0),
      currency:  Currency.values.elementAt(doc.data()!['currency'] ?? 0),
      rate: doc.data()?['rate'] ?? 1,


      adjAmount: doc.data()?['adjAmount'],
      refNo: doc.data()?['refNo'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






