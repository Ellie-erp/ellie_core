
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ItemAdjType {
  NEW,
  ADJ,  ///pricing adjustment

}


class ItemAdjRcd {
  DocumentReference? docRef;
  DateTime timestamp;
  String title;
  String? subtitle;
  String plu;
  ItemAdjType itemAdjType;
  String get itemAdjTypeName => describeEnum(itemAdjType);



  ItemAdjRcd({this.docRef, required this.timestamp,required this.title, this.subtitle,required this.itemAdjType, required this.plu});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'title': title,
    'plu' : plu,
        'subtitle': subtitle,
    'itemAdjType' : ItemAdjType.values.indexOf(this.itemAdjType),

      };
  factory ItemAdjRcd.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ItemAdjRcd(
      docRef: doc.reference,
      timestamp: doc.data()?['timestamp']?.toDate(),
      title: doc.data()?['title'],
      plu: doc.data()?['plu'],
      subtitle: doc.data()?['subtitle'],
      itemAdjType: ItemAdjType.values.elementAt(doc.data()?['itemAdjType'] ?? 0),

    );
  }

  Future<void> update() async {
    await docRef?.update(toMap);
  }
}
