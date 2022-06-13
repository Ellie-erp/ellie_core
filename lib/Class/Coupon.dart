import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Discount {
  MULTIPLY,
}

class Coupon {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String? description;
  num? slot1;
  num? slot2;
  num? slot3;
  Discount discount;
  String get discountName => describeEnum(discount);
  bool isActive;

  Coupon(
      {this.docRef,
      required this.createDate,
      required this.title,
      this.description,
      this.slot1,
      this.slot2,
      this.slot3,
      required this.discount,
      required this.isActive});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'description': description,
        'slot1': slot1,
        'slot2': slot2,
        'slot3': slot3,
        'discount': Discount.values.indexOf(discount),
        'isActive': isActive,
      };
  factory Coupon.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Coupon(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      title: doc.data()?['title'],
      description: doc.data()?['description'],
      slot1: doc.data()?['slot1'],
      slot2: doc.data()?['slot2'],
      slot3: doc.data()?['slot3'],
      discount: Discount.values.elementAt(doc.data()?['discount'] ?? 0),
      isActive: doc.data()?['isActive'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
