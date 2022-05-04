import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellie_core/Class/Sales.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

class PriceRecord {
  DocumentReference? docRef;
  DateTime timestamp;
  num price;
  Unit unit;
  String get unitName => describeEnum(Unit);
  SalesType salesType;
  String get salesTypeName => describeEnum(SalesType);
  String? staffId;
  String? staffName;



  PriceRecord({this.docRef,required this.timestamp,required this.price,required this.unit,required this.salesType, this.staffName,this.staffId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'price': price,
        'unit': Unit.values.indexOf(this.unit),
    'salesType': SalesType.values.indexOf(this.salesType),
    'staffId': staffId,
    'staffName': staffName,

      };
  factory PriceRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PriceRecord(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      price: doc.data()?['price'],
      unit: Unit.values.elementAt(doc.data()?['unit'] ?? 0),
      salesType: SalesType.values.elementAt(doc.data()?['salesType'] ?? 0),
      staffId: doc.data()?['staffId']?? '',
      staffName: doc.data()?['staffName']?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
