import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

import 'PCMSuppiler.dart';
enum POStatus {
  DRAFT,
  ACTIVE,
}


class PO {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String seller;
  num? transportCost;
  Term term;
  String get termName => describeEnum(term);
  POStatus poStatus;
  String get poStatusName => describeEnum(poStatus);



  PO({this.docRef, required this.createDate, required this.updateDate, required this.seller ,this.transportCost,required this.term, required this.poStatus});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,
    'term' : Term.values.indexOf(this.term),
    'poStatus' : POStatus.values.indexOf(this.poStatus),


      };
  factory PO.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PO(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      seller: doc.data()?['seller'],
      transportCost: doc.data()?['transportCost'] ?? 0,
      term: Term.values.elementAt(doc.data()!['term'] ?? 0),
      poStatus: POStatus.values.elementAt(doc.data()!['poStatus'] ?? 0),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






