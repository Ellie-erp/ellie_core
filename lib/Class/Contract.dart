import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

enum ContractItemType {
  Rent,               ///租金
  ManagementFee,      ///管理費
  Rate,               ///差餉
  AirConditioning,    /// 空調費
  PromotionFee,         ///推廣費
  Other,                ///雜項
  LicenseFee,           ///牌照費
}

String getContractItemTypeName(ContractItemType contractItemType){
  switch (contractItemType){
    case ContractItemType.Rent: {
      return '租金';
    }
    case ContractItemType.ManagementFee: {
      return '管理費';
    }
    case ContractItemType.Rate: {
      return '差餉';
    }
    case ContractItemType.AirConditioning: {
      return '空調費';
    }

    case ContractItemType.PromotionFee: {
      return '推廣費';
    }
    case ContractItemType.Other: {
      return '雜項';
    }
    case ContractItemType.LicenseFee: {
      return '牌照費';
    }
    default: {
     return '未定義' ;

    }
  }
  }




///店舖租金用 Class
class Contract {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  DateTime startDate;
  DateTime endDate;
  String locationId;
  String locationName;
  String remark;
  List<ContractItem>? contractItem;
  String contractor; ///合約制作人
  String refNo;



  Contract({this.docRef,required this.createDate,required  this.updateDate,required  this.startDate ,required this.endDate,required  this.locationId,required  this.locationName, this.remark='', this.contractItem , this.contractor='', this.refNo=''});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'startDate': startDate,
        'endDate': endDate,
        'locationId': locationId,
        'locationName': locationName,
        'remark': remark,
    'contractItem': (contractItem ?? []).map((e) => e.toMap).toList(),
    'contractor': contractor,
    'refNo': refNo,

      };
  factory Contract.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Contract(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      startDate: doc.data()!['startDate']?.toDate(),
      endDate: doc.data()!['endDate']?.toDate(),
      locationId: doc.data()!['locationId'],
      locationName: doc.data()!['locationName'],
      remark: doc.data()!['remark'],
      contractItem: List<ContractItem>.from((doc.data()!['contractItem'] ?? []).map((e) => ContractItem.fromMap(e)).toList()),
      contractor: doc.data()!['contractor'],
      refNo: doc.data()!['refNo'],

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}





class ContractItem {
  DateTime timestamp;
  ContractItemType contractItemType;
  DateTime? startDate;
  DateTime? endDate;
  num amount;
  bool isAdjust;



  ContractItem({ required this.timestamp, this.startDate, this.endDate,required  this.amount, required this.contractItemType, this.isAdjust=false});

  Map<String, dynamic> get toMap => {
    'timestamp': timestamp,
    'startDate': startDate,
    'endDate' : endDate,
    'amount' : amount,
    'contractItemType': ContractItemType.values.indexOf(contractItemType),
    'isAdjust': isAdjust,
  };

  factory ContractItem.fromMap(Map<String, dynamic> map) {
    return ContractItem(
      timestamp: map['timestamp']?.toDate(),
      startDate: map['startDate']?.toDate(),
      endDate: map['endDate']?.toDate(),
      amount: map['amount']?? 0,
      contractItemType: ContractItemType.values.elementAt(map['contractItemType'] ?? 0),
      isAdjust: map['isAdjust']?? false,
    );
  }}