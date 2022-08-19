import 'package:cloud_firestore/cloud_firestore.dart';

class StockRecordItem {
  DocumentReference? docRef;
  String plu;
  String name;
  int qty;
  num weight;
  DateTime timestamp;
  String connectId;

  StockRecordItem(
      {this.docRef,
      required this.plu,
      this.name = '',
      this.qty = 0,
      this.weight = 0,
      required this.timestamp,
      this.connectId = ''});
  Map<String, dynamic> get toMap => {
        'plu': plu,
        'name': name,
        'qty': qty,
        'weight': weight,
        'timestamp': timestamp,
        'connectId': connectId,
      };
  factory StockRecordItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StockRecordItem(
      docRef: doc.reference,
      plu: data['plu'],
      name: data['name'] ?? '',
      qty: data['qty'] ?? 0,
      weight: data['weight'] ?? 0,
      timestamp: data['timestamp']?.toDate(),
      connectId: data['connectId'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
