import 'package:cloud_firestore/cloud_firestore.dart';

///OrgBrand is the Brand name of individual Shop, such as P&J FOOD/ Alberts Finest Food, shown on a receipt
class OrgBrand {
  DocumentReference? docRef;
  String brandName;
  DateTime createDate;

  OrgBrand({
    this.docRef,
    required this.brandName,
    required this.createDate,
  });
  Map<String, dynamic> get toMap => {
        'brandName': brandName,
        'createDate': createDate,
      };
  factory OrgBrand.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return OrgBrand(
      docRef: doc.reference,
      brandName: doc.data()!['brandName'],
      createDate: doc.data()!['createDate']?.toDate(),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
