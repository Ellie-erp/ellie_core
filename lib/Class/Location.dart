import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  List<OpenHour>? openHour;

  Location(
      {this.docRef,
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
      this.openHour,
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
    'openHour': (openHour ?? []).map((e) => e.toMap).toList(),
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
        openHour: List<OpenHour>.from((doc.data()!['openHour'] ?? []).map((e) => OpenHour.fromMap(e)).toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






class OpenHour {
  bool isMon;
  bool isTue;
  bool isWed;
  bool isThu;
  bool isFri;
  bool isSat;
  bool isSun;


  OpenHour({this.isMon=true, this.isTue=true, this.isWed=true, this.isThu=true, this.isFri=true, this.isSat=true, this.isSun=true});

  Map<String, dynamic> get toMap => {
    'isMon': isMon,
    'isTue': isTue,
    'isWed' : isWed,
    'isThu' : isThu,
    'isFri' : isFri,
    'isSat' : isSat,
    'isSun' : isSun,
  };

  factory OpenHour.fromMap(Map<String, dynamic> map) {
    return OpenHour(
      isMon: map['isMon']?? true,
      isTue: map['isTue']?? true,
      isWed: map['isWed']?? true,
      isThu: map['isThu']?? true,
      isFri: map['isFri']?? true,
      isSat: map['isSat']?? true,
      isSun: map['isSun']?? true,
    );
  }}