import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

import 'PCMItem.dart';
import 'PCMSuppiler.dart';

enum POStatus {
  DRAFT,
  ACTIVE,
  DISABLE,
}

class PO {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String seller;
  num? transportCost;
  Term term;
  String get termName => describeEnum(term);
  POStatus poStatus;
  String get poStatusName => describeEnum(poStatus);
  Currency currency;
  num rate;
  ShipmentMethod shipmentMethod;
  String get shipmentMethodName => describeEnum(shipmentMethod);
  DateTime? ETD;
  DateTime? ETA;
  String? pcmSuppilerId;
  String? pcmSuppilerName;
  num? adjAmount;
  String? refNo;
  String? remark;
  bool showChineseonReport;
  String? staffAddressbookId;
  String? recipientAddressbookId;
  num depositRate;

  PO(
      {this.docRef,
      required this.createDate,
      required this.updateDate,
      required this.seller,
      this.transportCost,
      required this.term,
      required this.poStatus,
      this.currency = Currency.HKD,
      this.rate = 1,
      this.shipmentMethod = ShipmentMethod.LOCAL,
      this.ETA,
      this.ETD,
      this.pcmSuppilerId,
      this.pcmSuppilerName,
      this.adjAmount,
      this.refNo,
      this.remark,
      this.showChineseonReport = true,
      this.recipientAddressbookId = '',
      this.staffAddressbookId = '',
      this.depositRate = 1});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'seller': seller,
        'transportCost': transportCost,
        'term': Term.values.indexOf(term),
        'poStatus': POStatus.values.indexOf(poStatus),
        'currency': Currency.values.indexOf(currency),
        'shipmentMethod': ShipmentMethod.values.indexOf(shipmentMethod),
        'rate': rate,
        'ETD': ETD,
        'ETA': ETA,
        'pcmSuppilerId': pcmSuppilerId,
        'pcmSuppilerName': pcmSuppilerName,
        'adjAmount': adjAmount,
        'refNo': refNo,
        'remark': remark,
        'showChineseonReport': showChineseonReport,
        'staffAddressbookId': staffAddressbookId,
        'recipientAddressbookId': recipientAddressbookId,
        'depositRate': depositRate,
      };

  factory PO.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PO(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      seller: doc.data()?['seller'],
      transportCost: doc.data()?['transportCost'] ?? 0,
      term: Term.values.elementAt(doc.data()!['term'] ?? 0),
      poStatus: POStatus.values.elementAt(doc.data()!['poStatus'] ?? 0),
      currency: Currency.values.elementAt(doc.data()!['currency'] ?? 0),
      rate: doc.data()?['rate'] ?? 1,
      shipmentMethod:
          ShipmentMethod.values.elementAt(doc.data()!['shipmentMethod'] ?? 0),
      ETD: doc.data()?['ETD']?.toDate(),
      ETA: doc.data()?['ETA']?.toDate(),
      pcmSuppilerId: doc.data()?['pcmSuppilerId'],
      pcmSuppilerName: doc.data()?['pcmSuppilerName'],
      adjAmount: doc.data()?['adjAmount'],
      refNo: doc.data()?['refNo'] ?? '',
      remark: doc.data()?['remark'] ?? '',
      showChineseonReport: doc.data()?['showChineseonReport'] ?? true,
      staffAddressbookId: doc.data()?['staffAddressbookId'] ?? '',
      recipientAddressbookId: doc.data()?['recipientAddressbookId'] ?? '',
      depositRate: doc.data()?['depositRate'] ?? 1,
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
