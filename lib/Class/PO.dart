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
List<POItem>? poItem;


  PO({this.docRef, required this.createDate, required this.updateDate, required this.seller ,this.transportCost,required this.term, required this.poStatus, this.poItem});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,
    'term' : Term.values.indexOf(this.term),
    'poStatus' : POStatus.values.indexOf(this.poStatus),
    'poItem': (poItem ?? []).map((e) => e.toMap).toList(),

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
      poItem: List<POItem>.from((doc.data()!['poItem'] ?? []).map((e) => POItem.fromMap(e)).toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






class POItem {
  DateTime updateDate;
  String name;
  num? ctn;
  num qty;
  Unit unit;
  num unitPrice;
  String? remark;


  POItem({required this.updateDate, required this.name, this.ctn,required this.qty, required this.unit, required this.unitPrice, this.remark});

  Map<String, dynamic> get toMap => {
    'updateDate': updateDate,
    'name': name,
    'ctn' : ctn,
    'qty' : qty,
    'unit' : unit,
    'unitPrice' : unitPrice,
    'remark' : remark,

  };

  factory POItem.fromMap(Map<String, dynamic> map) {
    return POItem(
      updateDate: map['updateDate']?.toDate(),
      name: map['name'],
      ctn: map['ctn'],
      qty: map['qty'],
      unit: map['unit'],
      unitPrice: map['unitPrice'],
      remark: map['remark'],
    );
  }}