import 'package:cloud_firestore/cloud_firestore.dart';

class PDTCategory {
  DocumentReference? docRef;
  String shortName;
  String fullName;
  DateTime timestamp;




  PDTCategory({this.docRef,required this.shortName,required  this.fullName,required  this.timestamp});
  Map<String, dynamic> get toMap => {
        'shortName': shortName,
        'fullName': fullName,
        'timestamp': timestamp,


      };
  factory PDTCategory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PDTCategory(
      docRef: doc.reference,
      shortName: doc.data()!['shortName']?? '',
      fullName: doc.data()!['fullName']?? '',
      timestamp: doc.data()!['timestamp']?.toDate(),

    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}