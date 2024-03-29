import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:liquidity_gallery/Class.dart';

import 'PCMSuppiler.dart';

enum ShipmentMethod {
  SEA,
  AIR,
  LOCAL,
}

enum PCMItemStatus {
  Active,
  Inactive,
}

class PCMItem {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  PCMType pcmType;
  String get PCMTypeName => describeEnum(pcmType);
  String? nameZh;
  String name;
  String? spec;
  String? brand;
  Country origin;
  String get originName => describeEnum(origin);
  String pcmSuppilerId;
  String? pcmSuppilerName;
  List<PriceRange>? priceRange;
  String? plu;
  String? refNo;
  List<String> pdtKeywordIds;
  PCMItemStatus pcmItemStatus;

  PCMItem({
    this.docRef,
    required this.createDate,
    required this.name,
    this.spec,
    this.brand,
    required this.pcmSuppilerId,
    this.pcmSuppilerName,
    required this.origin,
    this.priceRange,
    this.plu,
    required this.pcmType,
    required this.updateDate,
    this.nameZh,
    this.refNo,
    this.pdtKeywordIds = const [],
    required this.pcmItemStatus,

  });
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'pcmType': PCMType.values.indexOf(pcmType),
        'nameZh': nameZh,
        'name': name,
        'spec': spec,
        'brand': brand,
        'origin': Country.values.indexOf(origin),
        'pcmSuppilerId': pcmSuppilerId,
        'pcmSuppilerName': pcmSuppilerName,
        'priceRange': (priceRange ?? []).map((e) => e.toMap).toList(),
        'plu': plu,
        'refNo': refNo,
        'pdtKeywordIds': pdtKeywordIds,
    'pcmItemStatus': PCMItemStatus.values.indexOf(pcmItemStatus),
      };
  factory PCMItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PCMItem(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      pcmType: PCMType.values.elementAt(doc.data()!['pcmType'] ?? 0),
      nameZh: doc.data()!['nameZh'],
      name: doc.data()!['name'],
      spec: doc.data()!['spec'] ?? '',
      brand: doc.data()!['brand'] ?? '',
      origin: Country.values.elementAt(doc.data()!['origin'] ?? 0),
      pcmSuppilerId: doc.data()!['pcmSuppilerId'] ?? '',
      pcmSuppilerName: doc.data()!['pcmSuppilerName'] ?? '',
      plu: doc.data()!['plu'] ?? '',
      refNo: doc.data()!['refNo'] ?? '',
      priceRange: List<PriceRange>.from((doc.data()!['priceRange'] ?? [])
          .map((e) => PriceRange.fromMap(e))
          .toList()),
      pdtKeywordIds:
          ((doc.data()?['pdtKeywordIds'] as List?) ?? []).cast<String>(),
      pcmItemStatus: PCMItemStatus.values.elementAt(doc.data()!['pcmItemStatus'] ?? 0),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class PriceRange {
  DateTime timestamp;
  num price;
  String? remark;
  Currency currency;
  String get currencyName => describeEnum(currency);
  Unit unit;
  String get unitName => describeEnum(unit);
  ShipmentMethod shipmentMethod;
  String get shipmentMethodName => describeEnum(shipmentMethod);
  num rate;

  PriceRange(
      {required this.timestamp,
      required this.price,
      this.remark,
      required this.currency,
      required this.unit,
      required this.shipmentMethod,
      required this.rate});

  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'price': price,
        'remark': remark,
        'currency': Currency.values.indexOf(currency),
        'unit': Unit.values.indexOf(unit),
        'shipmentMethod': ShipmentMethod.values.indexOf(shipmentMethod),
        'rate': rate,
      };

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      timestamp: map['timestamp']?.toDate(),
      price: map['price'],
      remark: map['remark'],
      rate: map['rate'],
      currency: Currency.values.elementAt(map['currency'] ?? 0),
      unit: Unit.values.elementAt(map['unit'] ?? 0),
      shipmentMethod:
          ShipmentMethod.values.elementAt(map['shipmentMethod'] ?? 0),
    );
  }
}
