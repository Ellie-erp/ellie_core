import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePrice {
  DocumentReference? docRef;
  DateTime createDate; 
  String name;
  bool isComplete;
  DateTime? completeDate;
  DateTime? scheduleDate;
  String staffId;
  String staffName;
List<SchedulePriceList> schedulePriceList;



  SchedulePrice({this.docRef,required this.createDate, this.name='', this.isComplete=false ,this.completeDate, this.scheduleDate, this.staffId='', this.staffName='' , this.schedulePriceList=const []});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'name': name,      
        'isComplete': isComplete,
        'completeDate': completeDate,
    'scheduleDate': scheduleDate,
    'staffId': staffId,
        'staffName': staffName,
    'schedulePriceList': (schedulePriceList ?? []).map((e) => e.toMap).toList(),

      };
  factory SchedulePrice.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return SchedulePrice(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      name: doc.data()!['name']?? '',
      isComplete: doc.data()!['isComplete']??false,
      completeDate: doc.data()!['completeDate']?.toDate(),
      scheduleDate: doc.data()!['scheduleDate']?.toDate(),
      staffId: doc.data()!['staffId']?? '',
      staffName: doc.data()!['staffName']?? '',
      schedulePriceList: List<SchedulePriceList>.from((doc.data()!['schedulePriceList'] ?? []).map((e) => SchedulePriceList.fromMap(e)).toList()),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}





class SchedulePriceList {
  String itemId;
  num? salePrice;
  num? wholesalePrice;
  num? shopPrice;
  num? onlinePrice;
  DateTime timestamp;

  SchedulePriceList({required this.itemId, this.salePrice, this.wholesalePrice, this.shopPrice, this.onlinePrice,required this.timestamp});

  Map<String, dynamic> get toMap => {
    'itemId': itemId,
    'salePrice': salePrice,
    'wholesalePrice' : wholesalePrice,
    'shopPrice' : shopPrice,
    'onlinePrice' : onlinePrice,
    'timestamp': timestamp,


  };

  factory SchedulePriceList.fromMap(Map<String, dynamic> map) {
    return SchedulePriceList(
      itemId: map['itemId'],
      salePrice: map['salePrice'],
      wholesalePrice: map['wholesalePrice'],
      shopPrice: map['shopPrice'],
      onlinePrice: map['onlinePrice'],
     timestamp: map['timestamp']?.toDate(),
    );
  }}