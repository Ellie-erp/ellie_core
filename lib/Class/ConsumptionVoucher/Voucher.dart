import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  DocumentReference ?docRef;
  DateTime ?timestamp;
  num ?voucher;




  Voucher({this.docRef, this.timestamp, this.voucher});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'voucher': voucher,


      };
  factory Voucher.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Voucher(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      voucher: doc.data()!['voucher'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
