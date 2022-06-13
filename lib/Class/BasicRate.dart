import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellie_core/Class/Sales.dart';

class BasicRate {
  DocumentReference? docRef;
  DateTime timestamp;
  num rate;
  SalesType salesType;

  BasicRate(
      {this.docRef,
      required this.timestamp,
      required this.rate,
      required this.salesType});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'rate': rate,
        'salesType': SalesType.values.indexOf(salesType),
      };
  factory BasicRate.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BasicRate(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      rate: doc.data()?['rate'],
      salesType: SalesType.values.elementAt(doc.data()?['salesType'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
