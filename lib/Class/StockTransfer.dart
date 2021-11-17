import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum STType{
  IN,
  OUT,
  TRANSFER,
  LOSS,

}

class StockTransfer {
  DocumentReference? docRef;
  DateTime timestamp;
  String plu;
  String? productName;
  String locationId;
  String? locationName;
  String? location2Id;
  String? location2Name;
 STType stType;
 String get stTypeName => describeEnum(stType);



  StockTransfer({this.docRef, required this.timestamp, required this.plu, this.productName , required this.locationId,  this.locationName, this.location2Id, this.location2Name, required this.stType });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'plu': plu,
        'productName': productName,
        'locationId': locationId,
        'locationName': locationName,
        'location2Id': location2Id,
        'location2Name': location2Name,
    'stType' : STType.values.indexOf(this.stType),


      };
  factory StockTransfer.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StockTransfer(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      plu: doc.data()?['plu'],
      productName: doc.data()?['productName'],
      locationId: doc.data()?['locationId'],
      locationName: doc.data()?['locationName'],
      location2Id: doc.data()?['location2Id'],
      location2Name: doc.data()?['location2Name'],
      stType: STType.values.elementAt(doc.data()?['stType'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
