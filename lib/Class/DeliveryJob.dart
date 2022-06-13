import 'package:cloud_firestore/cloud_firestore.dart';

///訂單以外的運輸工作由這class處理
class DeliveryJob {
  DocumentReference? docRef;
  DateTime createDate;
  String jobTitle;
  String address;
  String? remark;
  DateTime deliveryDate;
  DateTime? arrivedDate;

  DeliveryJob(
      {this.docRef,
      required this.createDate,
      required this.jobTitle,
      required this.address,
      this.remark,
      this.arrivedDate,
      required this.deliveryDate});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'jobTitle': jobTitle,
        'address': address,
        'remark': remark,
        'arrivedDate': arrivedDate,
        'deliveryDate': deliveryDate,
      };
  factory DeliveryJob.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DeliveryJob(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      deliveryDate: doc.data()!['deliveryDate']?.toDate(),
      jobTitle: doc.data()!['jobTitle'],
      address: doc.data()!['address'],
      remark: doc.data()!['remark'] ?? '',
      arrivedDate: doc.data()!['arrivedDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
