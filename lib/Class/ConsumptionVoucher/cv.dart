import 'package:cloud_firestore/cloud_firestore.dart';

class ConsumptionVoucher {
  DocumentReference? docRef;
  num? value;

  ConsumptionVoucher({this.docRef, this.value});
  Map<String, dynamic> get toMap => {
        'value': value,
      };
  factory ConsumptionVoucher.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return ConsumptionVoucher(
      docRef: doc.reference,
      value: doc.data()?['value'] ?? 0,
    );
  }

  Future<void> update() async {
    await docRef!.set(toMap, SetOptions(merge: true));
  }
}
