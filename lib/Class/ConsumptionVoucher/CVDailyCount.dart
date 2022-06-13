import 'package:cloud_firestore/cloud_firestore.dart';

class VCDailyCount {
  DocumentReference? docRef;
  DateTime timestamp;
  int systemValue;
  int? manuelValue;
  int? manuelValue2;
  String? note;

  VCDailyCount(
      {this.docRef,
      required this.timestamp,
      required this.systemValue,
      this.manuelValue,
      this.manuelValue2,
      this.note});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'systemValue': systemValue,
        'manuelValue': manuelValue,
        'manuelValue2': manuelValue2,
        'note': note,
      };
  factory VCDailyCount.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return VCDailyCount(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      systemValue: doc.data()!['systemValue'],
      manuelValue: doc.data()!['manuelValue'],
      manuelValue2: doc.data()!['manuelValue2'],
      note: doc.data()!['note'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
