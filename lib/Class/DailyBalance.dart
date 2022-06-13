import 'package:cloud_firestore/cloud_firestore.dart';

///零售每日結數用
class DailyBalance {
  DocumentReference? docRef;
  DateTime timestamp;
  num pettyCash;

  ///銀頭
  num pcValue;

  ///機數
  num checkValue;

  ///手數

  DailyBalance({
    this.docRef,
    required this.timestamp,
    this.pettyCash = 0,
    this.pcValue = 0,
    this.checkValue = 0,
  });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'pettyCash': pettyCash,
        'pcValue': pcValue,
        'checkValue': checkValue,
      };
  factory DailyBalance.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DailyBalance(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      pettyCash: doc.data()!['pettyCash'],
      pcValue: doc.data()!['pcValue'],
      checkValue: doc.data()!['checkValue'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
