import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';


///物流用車輛管理
enum VehicleType{
  ///私家車
  Car,
  ///輕型貨車
  LGV,
  ///中型貨車
  MGV,
  ///重型貨車
  HGV,
  ///雪車
  RefrigeratorTruck,

}

extension VehicleTypeExtension on VehicleType {
  String get longName {
    switch (this) {
      case VehicleType.Car:
        return '私家車';
      case VehicleType.LGV:
        return '輕型貨車';
      case VehicleType.MGV:
        return '中型貨車';
      case VehicleType.HGV:
        return '重型貨車';
      case VehicleType.RefrigeratorTruck:
        return '冷藏貨車';
    }
  }
}

enum VehicleStatus{
  ///運作中
  Normal,
  ///維修中
  Repairing,
  ///保養中
  Maintainance,
  ///已中止
  Cancelled,

}

extension VehicleStatusExtension on VehicleStatus {
  String get longName {
    switch (this) {
      case VehicleStatus.Normal:
        return '運作中';
      case VehicleStatus.Repairing:
        return '維修中';
      case VehicleStatus.Maintainance:
        return '保養中';
      case VehicleStatus.Cancelled:
        return '已中止';

    }
  }
}


class Vehicle {
  DocumentReference? docRef;
  DateTime createDate; 
  DateTime updateDate;
  String registrationMark;
String staffId;
String  staffName;
VehicleType vehicleType;
String color;



  Vehicle({this.docRef,required this.createDate,required this.updateDate,required this.registrationMark ,required this.staffId,this.staffName='Unnamed',required this.vehicleType ,this.color='0xFF9E9E9E'});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,      
        'registrationMark': registrationMark,
    'staffId' : staffId,
    'staffName' : staffName,
    'vehicleType': VehicleType.values.indexOf(vehicleType),
    'color': color,


      };
  factory Vehicle.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Vehicle(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      registrationMark: doc.data()!['registrationMark']?? '',
staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
      vehicleType: VehicleType.values.elementAt(doc.data()!['vehicleType']?? 0,),
      color: doc.data()!['color'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}



class VehicleRecord {
  DocumentReference? docRef;
  DateTime timestamp;
  String remark;
  String staffId;
  String staffName;
VehicleStatus vehicleStatus;


  VehicleRecord({this.docRef,required this.timestamp, this.remark='',required this.staffId ,this.staffName='Unnamed', required this.vehicleStatus});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'remark': remark,
        'staffId': staffId,
        'staffName': staffName,
  'vehicleStatus': VehicleStatus.values.indexOf(vehicleStatus),
      };
  factory VehicleRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return VehicleRecord(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']!.toDate(),
      remark: doc.data()!['remark'],
      staffId: doc.data()!['staffId'],
      staffName: doc.data()!['staffName'],
      vehicleStatus: VehicleStatus.values.elementAt( doc.data()!['vehicleStatus']?? 0),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}