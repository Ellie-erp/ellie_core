import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  DocumentReference? docRef;
  DateTime updateDate; 
  String plu;
List<StockMap>? stockMap;



  Stock({this.docRef,required this.updateDate,required this.plu, this.stockMap});
  Map<String, dynamic> get toMap => {
        'updateDate': updateDate,
        'plu': plu,
    'stockMap': (stockMap ?? []).map((e) => e.toMap).toList(),

      };
  factory Stock.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Stock(
      docRef: doc.reference,
      updateDate: doc.data()!['updateDate']?.toDate(),
      plu: doc.data()!['plu'],
      stockMap: List<StockMap>.from((doc.data()!['stockMap'] ?? []).map((e) => StockMap.fromMap(e)).toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}





class StockMap {
  String locationId;
  num qty;



  StockMap({ required this.locationId, required this.qty,});

  Map<String, dynamic> get toMap => {
    'locationId': locationId,
    'qty': qty,


  };

  factory StockMap.fromMap(Map<String, dynamic> map) {
    return StockMap(
      locationId: map['locationId'],
      qty: map['qty'],

    );
  }}