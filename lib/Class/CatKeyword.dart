import 'package:cloud_firestore/cloud_firestore.dart';

class CatKeyword {
  DocumentReference? docRef;
  String keyword;
  String name;




  CatKeyword({this.docRef, required this.keyword,required this.name});
  Map<String, dynamic> get toMap => {
        'keyword': keyword,
        'name': name,


      };
  factory CatKeyword.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CatKeyword(
      docRef: doc.reference,
      keyword: doc.data()?['keyword'],
      name: doc.data()?['name'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
