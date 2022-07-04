import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

///20220615 更新,用於配合promRule, 管理用家 優惠券數量
class Coupon {
  DocumentReference? docRef;
  DateTime updateDate;
  num? qty;
  bool isInfinite;


  Coupon({
    this.docRef,
    required this.updateDate,
    this.qty,
    this.isInfinite=false,
  });
  Map<String, dynamic> get toMap => {
        'updateDate': updateDate,
        'qty': qty,
    'isInfinite' : isInfinite,
      };
  factory Coupon.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Coupon(
      docRef: doc.reference,
      updateDate: doc.data()?['updateDate']?.toDate(),
      qty: doc.data()?['qty'],
      isInfinite: doc.data()?['isInfinite'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class CouponHistory {
  DocumentReference? docRef;
  DateTime timestamp;
  String promRuleid;
  String promRuleName;
  num? qty;
  String remark;

  ///紀錄每個用家的coupon動向
  CouponHistory(
      {this.docRef,
      required this.timestamp,
      required this.promRuleid,
      required this.promRuleName,
      this.qty,
      this.remark = ''});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'promRuleid': promRuleid,
        'promRuleName': promRuleName,
        'qty': qty,
        'remark': remark,
      };
  factory CouponHistory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CouponHistory(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp'],
      promRuleid: doc.data()!['promRuleid'],
      promRuleName: doc.data()!['promRuleName'],
      qty: doc.data()?['qty'],
      remark: doc.data()!['remark'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
