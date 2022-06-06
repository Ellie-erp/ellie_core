import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LocationType {
  SHOP,
  STORAGE,
  WORKSHOP,
  ESHOP,
  OFFICE,
}

class Location {
  DocumentReference? docRef;
  DateTime createDate;

  String name;
  String? type;
  String? address;
  String? addressZH;
  String? tel;
  LocationType locationType;
  String get locationTypeName => describeEnum(locationType);
  bool isActive;
  bool allowWorkshop;
  bool allowRetail;
  bool allowStock;
  bool allowStockIn;
  List? webShopList;
  num credit;
  String? orgBrandId;
  List<OpenHour> openHours;

  Location({
    this.docRef,
    required this.name,
    this.type,
    this.address,
    this.addressZH,
    this.tel,
    required this.locationType,
    required this.isActive,
    this.allowWorkshop = false,
    this.allowRetail = false,
    this.allowStock = false,
    this.allowStockIn = false,
    this.webShopList,
    this.credit = 0,
    required this.createDate,
    this.orgBrandId,
    required this.openHours,
  });
  Map<String, dynamic> get toMap => {
        'name': name,
        'type': type,
        'address': address,
        'addressZH': addressZH,
        'tel': tel,
        'locationType': LocationType.values.indexOf(locationType),
        'isActive': isActive,
        'allowWorkshop': allowWorkshop,
        'allowRetail': allowRetail,
        'allowStock': allowStock,
        'allowStockIn': allowStockIn,
        'webShopList': webShopList,
        'credit': credit,
        'createDate': createDate,
        'orgBrandId': orgBrandId,
        'openHours': (openHours).map((e) => e.toMap).toList(),
      };
  factory Location.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Location(
        docRef: doc.reference,
        name: doc.data()!['name'],
        type: doc.data()!['type'],
        address: doc.data()!['address'] ?? '',
        addressZH: doc.data()!['addressZH'] ?? '',
        tel: doc.data()!['tel'] ?? '',
        locationType:
            LocationType.values.elementAt(doc.data()!['locationType'] ?? 0),
        isActive: doc.data()!['isActive'],
        allowWorkshop: doc.data()!['allowWorkshop'] ?? false,
        allowRetail: doc.data()!['allowRetail'] ?? false,
        allowStock: doc.data()!['allowStock'] ?? false,
        allowStockIn: doc.data()!['allowStockIn'] ?? false,
        webShopList: doc.data()?['webShopList'] ?? [],
        credit: doc.data()?['credit'] ?? 0,
        createDate: doc.data()?['createDate']?.toDate(),
        orgBrandId: doc.data()?['orgBrandId'],
        openHours: doc.data()!['openHours'] == null
            ? List.generate(
                7,
                (index) => OpenHour(
                    dayOfWeek: index,
                    enable: false,
                    startHour: const TimeOfDay(hour: 8, minute: 0),
                    endHour: const TimeOfDay(hour: 18, minute: 0)))
            : (doc.data()!['openHours'] as List)
                .map((e) => OpenHour.fromMap(e))
                .toList());
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class OpenHour {
  int dayOfWeek;
  bool enable;
  TimeOfDay startHour;
  TimeOfDay endHour;

  OpenHour(
      {required this.dayOfWeek,
      required this.enable,
      required this.startHour,
      required this.endHour});

  Map<String, dynamic> get toMap => {
        'dayOfWeek': dayOfWeek,
        'enable': enable,
        'startHour': startHour,
        'endHour': endHour
      };

  factory OpenHour.fromMap(Map<String, dynamic> data) {
    return OpenHour(
        dayOfWeek: data['dayOfWeek'],
        enable: data['enable'],
        startHour:
            TimeOfDay.fromDateTime((data['startHour'] as Timestamp).toDate()),
        endHour:
            TimeOfDay.fromDateTime((data['endHour'] as Timestamp).toDate()));
  }
}
