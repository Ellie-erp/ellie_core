import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  DocumentReference? docRef;
  DateTime createDate;
  String title;
  String description;
  List<SeriesItem> seriesItem;

  List<SeriesGroup> seriesGroup;

  Series(
      {this.docRef,
      required this.createDate,
      required this.title,
      this.description = '',
      required this.seriesItem,
      required this.seriesGroup});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'title': title,
        'description': description,
        'seriesItem': (seriesItem ?? []).map((e) => e.toMap).toList(),
        'seriesGroup': (seriesGroup ?? []).map((e) => e.toMap).toList(),
      };
  factory Series.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Series(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      title: doc.data()!['title'],
      description: doc.data()!['description'] ?? '',
      seriesItem: List<SeriesItem>.from((doc.data()!['seriesItem'] ?? [])
          .map((e) => SeriesItem.fromMap(e))
          .toList()),
      seriesGroup: List<SeriesGroup>.from((doc.data()!['seriesGroup'] ?? [])
          .map((e) => SeriesGroup.fromMap(e))
          .toList()),
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class SeriesItem {
  String id;
  int position;
  int group;
  int? primaryPhoto;

  SeriesItem(
      {required this.id,
      required this.position,
      this.group = 0,
      this.primaryPhoto});

  Map<String, dynamic> get toMap => {
        'id': id,
        'position': position,
        'group': group,
        'primaryPhoto': primaryPhoto
      };

  factory SeriesItem.fromMap(Map<String, dynamic> map) {
    return SeriesItem(
        id: map['id'],
        position: map['position'],
        group: map['group'] ?? 0,
        primaryPhoto: map['primaryPhoto']);
  }
}

class SeriesGroup {
  String name;
  String description;
  bool showTitle;

  SeriesGroup(
      {required this.name, required this.description, this.showTitle = true});

  Map<String, dynamic> get toMap => {
        'name': name,
        'description': description,
        'showTitle': showTitle,
      };

  factory SeriesGroup.fromMap(Map<String, dynamic> map) {
    return SeriesGroup(
      name: map['name'],
      description: map['description'],
      showTitle: map['showTitle'] ?? true,
    );
  }
}
