import 'package:cloud_firestore/cloud_firestore.dart';

enum StockRecordStatus {
  AWAIT,
  SENT,

  /// if process the stock record to ther Stock Collection

}

enum StockRecordType {
  NEWSTOCK,

  ///New buying from suppiler, can attach to PO potentially
  TRANSFER,

  /// transfer to other facuilties , not include stock in
  DISMANTLE,
  ASSMBLE,
  LOSS,

  /// waste and accepted loss of qty

}

class StockRecord {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime? sentDate;
  String locationId;
  String? locationName;
  String? location2Id;
  String? location2Name;
  StockRecordType stockRecordType;
  StockRecordStatus stockRecordStatus;
  String? poId;

  /// If this is New stock, it record PO
  String? poSeller;
  DateTime? poETA;

  StockRecord(
      {this.docRef,
      required this.createDate,
      this.sentDate,
      required this.locationId,
      this.locationName,
      this.location2Id,
      this.location2Name,
      required this.stockRecordType,
      this.poId,
      this.poSeller,
      this.poETA,
      required this.stockRecordStatus});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'sentDate': sentDate,
        'locationId': locationId,
        'locationName': locationName,
        'location2Id': location2Id,
        'location2Name': location2Name,
        'stockRecordType': StockRecordType.values.indexOf(stockRecordType),
        'stockRecordStatus':
            StockRecordStatus.values.indexOf(stockRecordStatus),
        'poId': poId,
        'poSeller': poSeller,
        'poETA': poETA,
      };
  factory StockRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return StockRecord(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      sentDate: doc.data()?['sentDate']?.toDate(),
      locationId: doc.data()?['locationId'],
      locationName: doc.data()?['locationName'],
      location2Id: doc.data()?['location2Id'],
      location2Name: doc.data()?['location2Name'],
      stockRecordType:
          StockRecordType.values.elementAt(doc.data()?['stockRecordType'] ?? 0),
      stockRecordStatus: StockRecordStatus.values
          .elementAt(doc.data()?['stockRecordStatus'] ?? 0),
      poId: doc.data()?['poId'],
      poSeller: doc.data()?['poSeller'],
      poETA: doc.data()?['poETA']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
