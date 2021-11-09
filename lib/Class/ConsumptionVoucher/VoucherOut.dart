import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherOut {
  DocumentReference ?docRef;
  DateTime? createDate;
  num voucher;
  DateTime? completeDate;

  VoucherOut({this.docRef, this.createDate,required this.voucher, this.completeDate});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'voucher': voucher,
        'completeDate': completeDate,
      };
  factory VoucherOut.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return VoucherOut(
      docRef: doc.reference,
      createDate: data['createDate']?.toDate(),
      voucher: data['voucher'] ?? 0,
      completeDate: data['completeDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
