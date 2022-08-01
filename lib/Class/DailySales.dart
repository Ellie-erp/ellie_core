import 'package:cloud_firestore/cloud_firestore.dart';

import 'Sales.dart';

///紀錄每日銷售紀錄,方便做分析,如locationId= '',全部店舖
class DailySales {
  DocumentReference? docRef;
  DateTime createDate; 
  DateTime updateDate;
  DateTime saleDate;
  int numOfCompletion;
  int numOfReserve;
  int numOfCancel;
  num totalSale;
  String locationId;
  String locationName;
  List<DailySalesMethod>? dailySalesMethod;
  List<DailySalesItem>?dailySalesItem;




  DailySales({this.docRef,required this.createDate,required this.updateDate,required this.saleDate ,this.numOfCompletion=0, this.numOfReserve=0, this.numOfCancel=0, this.totalSale=0, this.locationId='', this.locationName='',this.dailySalesMethod, this.dailySalesItem});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,      
        'saleDate': saleDate,  
        'NumOfCompletion': numOfCompletion,
        'NumOfReserve': numOfReserve,
        'NumOfCancel': numOfCancel,
        'totalSale': totalSale,  
        'locationId': locationId,
        'locationName': locationName,
    'dailySalesMethod': (dailySalesMethod ?? []).map((e) => e.toMap).toList(),
    'dailySalesItem': (dailySalesItem ?? []).map((e) => e.toMap).toList(),

      };
  factory DailySales.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DailySales(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      updateDate: doc.data()!['updateDate']?.toDate(),
      saleDate: doc.data()!['saleDate']?.toDate(),
      numOfCompletion: doc.data()!['numOfCompletion']?? 0,
      numOfReserve: doc.data()!['numOfReserve']?? 0,
      numOfCancel: doc.data()!['numOfCancel']?? 0,
      totalSale: doc.data()!['totalSale']?? 0,
      locationId: doc.data()!['locationId']?? '',
      locationName: doc.data()!['locationName']?? '',
      dailySalesMethod: List<DailySalesMethod>.from((doc.data()!['dailySalesMethod'] ?? []).map((e) => DailySalesMethod.fromMap(e)).toList()),
      dailySalesItem: List<DailySalesItem>.from((doc.data()!['dailySalesItem'] ?? []).map((e) => DailySalesItem.fromMap(e)).toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}







class DailySalesMethod {
  int numOfOrder;
  num total;
  PayMethod? payMethod;
  

  DailySalesMethod({this.numOfOrder=0, this.total=0,       this.payMethod,});

  Map<String, dynamic> get toMap => {
    'numOfOrder': numOfOrder,
    'total': total,
    'payMethod': PayMethod.values.indexOf(payMethod!),
    
  };

  factory DailySalesMethod.fromMap(Map<String, dynamic> map) {
    return DailySalesMethod(
      numOfOrder: map['numOfOrder']?? 0,
      total: map['total']?? 0,
      payMethod: PayMethod.values.elementAt(map['payMethod'] ?? 0),
    );
  }}







class DailySalesItem {
  String plu;
  String itemName;
  num total;
  int qty;
  num? weight;



  DailySalesItem({required this.plu, this.itemName='', this.total=0, this.qty=0, this.weight,});

  Map<String, dynamic> get toMap => {
    'plu': plu,
    'itemName': itemName,
    'total' : total,
    'qty' : qty,
    'weight' : weight,


  };

  factory DailySalesItem.fromMap(Map<String, dynamic> map) {
    return DailySalesItem(
      plu: map['plu'],
      itemName: map['itemName']??'',
      total: map['total']??0,
      qty: map['qty']??0,
      weight: map['weight']??0,

    );
  }}