import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum LocationType{
  SHOP,
  STORAGE,
  WORKSHOP,
  ESHOP,
  OFFICE,
}

class Location {
  DocumentReference ?docRef;
  String name;
  String ?type;
  String? address;
  String? addressZH;
  String? tel;
  LocationType locationType;
  String get locationTypeName => describeEnum(locationType);
  bool isActive;
  bool? allowWorkshop;




  Location({  this.docRef, required this.name, this.type,this.address, this.addressZH, this.tel, required this.locationType, required this.isActive, this.allowWorkshop=false});
  Map<String, dynamic> get toMap => {
        'name': name,
        'type': type,
    'address' : address,
    'addressZH' : addressZH,
    'tel' : tel,
    'locationType' : LocationType.values.indexOf(this.locationType),
    'isActive' : isActive,
    'allowWorkshop': allowWorkshop,

      };
  factory Location.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Location(
      docRef: doc.reference,
      name: doc.data()!['name'],
      type: doc.data()!['type'],
      address: doc.data()!['address'] ?? '',
      addressZH: doc.data()!['addressZH'] ?? '',
      tel: doc.data()!['tel'] ?? '',
      locationType: LocationType.values.elementAt(doc.data()!['locationType'] ?? 0),
      isActive: doc.data()!['isActive'],
      allowWorkshop: doc.data()!['allowWorkshop']?? false,
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
