import 'package:cloud_firestore/cloud_firestore.dart';

class Dictionary {
  DocumentReference? docRef;
  DateTime timestamp;
  String nameZh;
  String nameEng;
  String? description;

  Dictionary({
    this.docRef,
    required this.timestamp,
    required this.nameZh,
    required this.nameEng,
    this.description,
  });
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'nameZh': nameZh,
        'nameEng': nameEng,
        'description': description,
      };
  factory Dictionary.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Dictionary(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      nameZh: doc.data()!['nameZh'],
      nameEng: doc.data()!['nameEng'],
      description: doc.data()!['description'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}

class DictionaryItem {
  DocumentReference? docRef;
  DateTime timestamp;
  String nameZh;
  String nameEng;
  String? description;
  String dictionaryId;

  DictionaryItem(
      {this.docRef,
      required this.timestamp,
      required this.nameZh,
      required this.nameEng,
      this.description,
      required this.dictionaryId});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'nameZh': nameZh,
        'nameEng': nameEng,
        'description': description,
        'dictionaryId': dictionaryId,
      };
  factory DictionaryItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return DictionaryItem(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      nameZh: doc.data()!['nameZh'],
      nameEng: doc.data()!['nameEng'],
      description: doc.data()!['description'] ?? '',
      dictionaryId: doc.data()!['dictionaryId'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
