import 'package:cloud_firestore/cloud_firestore.dart';

class StockRecordItem {
  DocumentReference? docRef;
  String plu;
  String? productName;
  num qty;

  StockRecordItem(
      {this.docRef, required this.plu, this.productName, required this.qty});
  Map<String, dynamic> get toMap => {
        'plu': plu,
        'productName': productName,
        'qty': qty,
      };
  factory StockRecordItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StockRecordItem(
      docRef: doc.reference,
      plu: doc.data()?['plu'],
      productName: doc.data()?['productName'],
      qty: doc.data()?['qty'],
    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
