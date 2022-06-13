import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Receipts {
  DocumentReference? docRef;
  DateTime? timestamp;
  num? amount;
  String? receiptId;

  String formattedreceiptDate() {
    if (timestamp == null) {
      return 'N/A';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp!);
    }
  }

  Receipts({this.docRef, this.timestamp, this.amount, this.receiptId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'amount': amount,
        'receiptId': receiptId,
      };
  factory Receipts.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Receipts(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      amount: doc.data()!['amount'],
      receiptId: doc.data()!['receiptId'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
