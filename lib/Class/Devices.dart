import 'package:cloud_firestore/cloud_firestore.dart';

class Devices {
  DocumentReference? docRef;
  DateTime createDate;
  String? locationId;
  String? locationName;

  Devices(
      {this.docRef,
      required this.createDate,
      this.locationId,
      this.locationName});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'locationId': locationId,
        'locationName': locationName,
      };
  factory Devices.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Devices(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      locationId: doc.data()?['locationId'] ?? "",
      locationName: doc.data()?['locationName'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
