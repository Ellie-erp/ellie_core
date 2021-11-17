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
  String? plu;
  String? pluDocRefId;





  POItem({this.docRef,required this.timestamp,required this.name, this.ctn ,required this.qty, required this.unit,required this.unitPrice, this.remark,required this.poId, this.plu, this.pluDocRefId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'name': name,
        'ctn': ctn,
        'qty': qty,
    'unit' : Unit.values.indexOf(this.unit),
        'unitPrice': unitPrice,
        'remark': remark,
        'poId': poId,
    'plu' : plu,
    'pluDocRefId' : pluDocRefId,


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
      plu: doc.data()?['plu'],
      pluDocRefId: doc.data()?['pluDocRefId'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
