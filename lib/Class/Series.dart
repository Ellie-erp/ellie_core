import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String description;
 List<SeriesItem> seriesItem;




  Series({this.docRef,required this.createDate,required this.title, this.description='', required this.seriesItem});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'description': description,
    'seriesItem': (seriesItem ?? []).map((e) => e.toMap).toList(),

      };
  factory Series.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Series(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      title: doc.data()!['title'],
      description: doc.data()!['description']?? '',
      seriesItem: List<SeriesItem>.from((doc.data()!['seriesItem'] ?? []).map((e) => SeriesItem.fromMap(e)).toList()),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}






class SeriesItem {
  String id;
  int position;



  SeriesItem({ required this.id,required this.position, });

  Map<String, dynamic> get toMap => {
    'id': id,
    'position': position,


  };

  factory SeriesItem.fromMap(Map<String, dynamic> map) {
    return SeriesItem(
      id: map['id'],
      position: map['position'],

    );
  }}