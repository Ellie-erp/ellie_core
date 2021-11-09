import 'package:cloud_firestore/cloud_firestore.dart';

class ExchRate {
  DocumentReference? docRef;
  String ?title;
  String ?subtitle;
 List<RateMap>? rateMap;



  ExchRate({this.docRef, this.title, this.subtitle, this.rateMap});
  Map<String, dynamic> get toMap => {
        'title': title,
        'subtitle': subtitle,
    'rateMap': (rateMap ?? []).map((e) => e.toMap).toList(),

      };
  factory ExchRate.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ExchRate(
      docRef: doc.reference,
      title: doc.data()!['title'],
      subtitle: doc.data()!['subtitle'],
      rateMap: List<RateMap>.from((doc.data()!['rateMap'] ?? []).map((e) => RateMap.fromMap(e)).toList()),


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}




class RateMap {
  num? rate;
  DateTime updateDate;


  RateMap({this.rate,required this.updateDate});

  Map<String, dynamic> get toMap => {
    'rate': rate,
    'updateDate': updateDate,


  };

  factory RateMap.fromMap(Map<String, dynamic> map) {
    return RateMap(
      rate: map['rate'],
      updateDate: map['updateDate']?.toDate(),

    );
  }}