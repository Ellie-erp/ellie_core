import 'package:cloud_firestore/cloud_firestore.dart';

class AssocCompany {
  DocumentReference? docRef;
  DateTime timestamp;
  String nameZh;
  String nameEng;




  AssocCompany({this.docRef,required this.timestamp,required this.nameZh,required this.nameEng});
  Map<String, dynamic> get toMap => {
        'timestamp': timestamp,
        'nameZh': nameZh,
        'nameEng': nameEng,


      };
  factory AssocCompany.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AssocCompany(
      docRef: doc.reference,
      timestamp: doc.data()!['timestamp']?.toDate(),
      nameZh: doc.data()!['nameZh'],
      nameEng: doc.data()!['nameEng'],

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}