import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidity_gallery/Class.dart';

class POItem {
  DocumentReference? docRef;
  DateTime timestamp;
  String name;
  num? ctn;
  num qty;
  Unit unit;
  num unitPrice;
  String? remark;
  String poId;
  Currency currency;




  POItem({this.docRef,required this.timestamp,required this.name, this.ctn ,required this.qty, required this.unit,required this.unitPrice, this.remark,required this.poId, this.currency=Currency.HKD});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'name': name,
        'ctn': ctn,
        'qty': qty,
    'unit' : Unit.values.indexOf(this.unit),
        'unitPrice': unitPrice,
        'remark': remark,
        'poId': poId,
    'currency' : Currency.values.indexOf(this.currency),


      };
  factory POItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return POItem(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      name: doc.data()?['name'],
      ctn: doc.data()?['ctn'],
      qty: doc.data()?['qty'],
      unit: Unit.values.elementAt(doc.data()!['unit'] ?? 0),
      unitPrice: doc.data()?['unitPrice'],
      remark: doc.data()?['remark'],
      poId: doc.data()?['poId'],
currency:  Currency.values.elementAt(doc.data()!['currency'] ?? 0),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
