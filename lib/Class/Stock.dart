import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'StockRecord.dart';

class Stock {
  DocumentReference? docRef;
  DateTime updateDate;
  String plu;
  List<StockLevel>? stockLevel;

  Stock(
      {this.docRef,
      required this.updateDate,
      required this.plu,
      this.stockLevel});
  Map<String, dynamic> get toMap => {
        'updateDate': updateDate,
        'plu': plu,
        'stockLevel': (stockLevel ?? []).map((e) => e.toMap).toList(),
      };
  factory Stock.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Stock(
        docRef: doc.reference,
        updateDate: doc.data()!['updateDate']?.toDate(),
        plu: doc.data()!['plu'],
        stockLevel: (doc.data()!['stockLevel'] as Map<String, dynamic>)
            .entries
            .map((e) =>
                StockLevel.fromMap(e.key, e.value as Map<String, dynamic>))
            .toList());
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class StockLevel {
  String locationId;
  int qty;
  num weight;

  StockLevel({required this.locationId, this.qty = 0, this.weight = 0});

  Map<String, dynamic> get toMap => {
        'locationId': locationId,
        'qty': qty,
        'weight': weight,
      };

  factory StockLevel.fromMap(String locationId, Map<String, dynamic> map) {
    return StockLevel(
      locationId: locationId,
      qty: map['qty'] ?? 0,
      weight: map['weight'] ?? 0,
    );
  }
}

class StockHistory {
  DocumentReference? docRef;
  DateTime timestamp;
  int qty;
  num weight;
  String recordId;
  bool isReverse;
  StockRecordType stockRecordType;

  StockHistory({
    this.docRef,
    required this.timestamp,
    this.qty = 0,
    this.weight = 0,
    this.recordId = '',
    this.isReverse = false,
    required this.stockRecordType,
  });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'qty': qty,
        'weight': weight,
        'recordId': recordId,
        'isReverse': isReverse,
        'stockRecordType': StockRecordType.values.indexOf(stockRecordType),
      };
  factory StockHistory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StockHistory(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      qty: doc.data()!['qty'] ?? 0,
      weight: doc.data()!['weight'] ?? 0,
      recordId: doc.data()!['recordId'],
      isReverse: doc.data()!['isReverse'] ?? false,
      stockRecordType:
          StockRecordType.values.elementAt(doc.data()?['stockRecordType'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
