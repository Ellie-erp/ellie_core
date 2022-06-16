import 'package:cloud_firestore/cloud_firestore.dart';


///物流用,用來回報有問題的訂單,有UI support
class DelReportLog {
  DocumentReference? docRef;
  DateTime timestamp;
  String orderId;
  String remark;
  DateTime? fixDate;




  DelReportLog({this.docRef,required this.timestamp,required this.orderId, this.remark='' ,this.fixDate,});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'orderId': orderId,
        'remark': remark,
        'fixDate': fixDate,


      };
  factory DelReportLog.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DelReportLog(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      orderId: doc.data()!['orderId'],
      remark: doc.data()!['remark'],
      fixDate: doc.data()?['fixDate'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}