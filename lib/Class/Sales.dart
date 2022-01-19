
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

enum PayMethod{
  NONE,
  CASH,
  VISA,
  MASTER,
  OCTOPUS,
  PAYME,
  ALIPAY,
  WECHATPAY,
  AE,
}

enum SalesType{
  RETAIL,
  WHOLESALE,
  ONLINE,
  STOCKIN,

}

enum SalesStatus {
  OPEN,
  COMPLETE,
  CANCEL,
  SENT,
}


class Sales {
  DocumentReference? docRef;
  DateTime createDate;
  num? amount;
  num? total;
  SalesStatus salesStatus;
  String get salesStatusName => describeEnum(salesStatus);
  SalesType salesType;
  String get salesTypeName => describeEnum(SalesType);
  String? clientId;
  String? clientName;

  String locationId;
  String? locationName;
  num? deduction;
  num? discount;
  num? paidAmount; ///Show how much customer paid in reality
  PayMethod? payMethod;
  String get payMethodName => describeEnum(PayMethod);





  Sales({this.docRef, required this.createDate, this.amount, this.total, required this.salesStatus, this.clientName, this.clientId, required this.salesType, required this.locationId, this.locationName, this.deduction, this.discount, this.paidAmount, this.payMethod});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'amount': amount,
        'total': total,
        'salesStatus': SalesStatus.values.indexOf(this.salesStatus),
    'salesType': SalesType.values.indexOf(this.salesType),
    'clientId' : clientId,
    'clientName' : clientName,

    'locationId' : locationId,
    'locationName' : locationName,
    'deduction' : deduction,
    'discount' : discount,
    'paidAmount' : paidAmount,
    'payMethod' : PayMethod.values.indexOf(this.payMethod!),



      }..removeWhere((key, value) => value==null);
  factory Sales.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Sales(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate() ?? DateTime(0),
      amount: doc.data()?['amount'],
      total: doc.data()?['total'],
      salesStatus: SalesStatus.values.elementAt(doc.data()?['salesStatus'] ?? 0),
      salesType: SalesType.values.elementAt(doc.data()?['salesType'] ?? 0),
      clientName: doc.data()?['clientName'],
     locationId: doc.data()?['locationId'],
      locationName: doc.data()?['locationName'] ?? '',
      deduction: doc.data()?['deduction'],
      discount: doc.data()?['discount'],
      paidAmount: doc.data()?['paidAmount'],
      payMethod: PayMethod.values.elementAt(doc.data()?['payMethod'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}


//
// enum Unit{
//   PC,
//   KG
//
// }




class OrderItem {
  DocumentReference? docRef;
  DateTime timestamp;
  String title;
  String? code;
  num unitPrice;
  num? amount;
  Unit unit;
  String get unitName => describeEnum(unit);
  num? weight;
  num? preQTY;
  List? array;
  String? remark;
  

  OrderItem({this.docRef, required this.timestamp,  required this.title, this.code, required this.unitPrice, this.amount, required this.unit, this.weight, this.preQTY, this.array, this.remark});

  Map<String, dynamic> get toMap => {
    'timestamp': timestamp,
    'title': title,
    'code' : code,
    'unitPrice' : unitPrice,
    'amount' : amount,
    'unit': Unit.values.indexOf(this.unit),
    'weight' : weight,
    'preQTY' : preQTY,
    'array': array,
    'remark' : remark,
  };


  factory OrderItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return OrderItem(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      title: doc.data()?['title'],
      code: doc.data()?['code'],
      unitPrice: doc.data()?['unitPrice'],
      amount: doc.data()?['amount'],
      weight: doc.data()?['weight'],
      unit: Unit.values.elementAt(doc.data()?['unit'] ?? 0),
      preQTY: doc.data()?['preQTY'],
      array: doc.data()?['array'],
      remark: doc.data()?['remark'] ?? '',
    );
  }

  Future<void> update() async => await docRef!.update(toMap);

}