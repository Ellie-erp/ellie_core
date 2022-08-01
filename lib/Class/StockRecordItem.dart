import 'package:cloud_firestore/cloud_firestore.dart';

class StockRecordItem {
  DocumentReference? docRef;
  String plu;
  String name;
  int qty;
  num weight;

  StockRecordItem(
      {this.docRef, required this.plu, this.name='',  this.qty=0,this.weight=0 });
  Map<String, dynamic> get toMap => {
        'plu': plu,
        'name': name,
        'qty': qty,
    'weight': weight,
      };
  factory StockRecordItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StockRecordItem(
      docRef: doc.reference,
      plu: doc.data()?['plu'],
      name: doc.data()?['name']?? '',
      qty: doc.data()?['qty']?? 0,
      weight: doc.data()?['weight']?? 0,
    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
