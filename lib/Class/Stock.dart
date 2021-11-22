import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  DocumentReference? docRef;
  DateTime updateDate; 
  String plu;
  Map<String, num>? stockMap;



  Stock({this.docRef,required this.updateDate,required this.plu,  this.stockMap});
  Map<String, dynamic> get toMap => {
        'updateDate': updateDate,
        'plu': plu,
    'stockMap': stockMap,

      };
  factory Stock.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Stock(
      docRef: doc.reference,
      updateDate: doc.data()!['updateDate']?.toDate(),
      plu: doc.data()!['plu'],
      stockMap: Map<String, num>.from(doc.data()!['stockMap']),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}




