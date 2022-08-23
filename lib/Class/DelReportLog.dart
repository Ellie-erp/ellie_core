import 'package:cloud_firestore/cloud_firestore.dart';

///物流用,用來回報有問題的訂單,有UI support
class DelReportLog {
  DocumentReference? docRef;
  DateTime timestamp;
  String orderId;
  String remark;
  DateTime? fixDate;
  String staffId;
  String staffName;

  DelReportLog(
      {this.docRef,
      required this.timestamp,
      required this.orderId,
      this.remark = '',
      this.fixDate,
      required this.staffName,
      required this.staffId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'orderId': orderId,
        'remark': remark,
        'fixDate': fixDate,
        'staffId': staffId,
        'staffName': staffName,
      };
  factory DelReportLog.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DelReportLog(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      orderId: doc.data()!['orderId'],
      remark: doc.data()!['remark'],
      fixDate: doc.data()?['fixDate']?.toDate(),
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
