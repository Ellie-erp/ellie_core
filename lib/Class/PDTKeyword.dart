import 'package:cloud_firestore/cloud_firestore.dart';

class PDTKeyword {
  DocumentReference? docRef;
  String chineseName;
  String engName;
  DateTime timestamp;
  List<String> keywords;
String pdtCategoryId;
String pdtCategoryName;

  PDTKeyword({this.docRef,required this.chineseName,required this.engName,required this.timestamp , this.keywords = const [], this.pdtCategoryId='', this.pdtCategoryName=''});
  Map<String, dynamic> get toMap => {
        'chineseName': chineseName,
        'engName': engName,
        'timestamp': timestamp,
    'keywords': keywords,
    'pdtCategoryId': pdtCategoryId,
    'pdtCategoryName': pdtCategoryName,
      };
  factory PDTKeyword.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PDTKeyword(
      docRef: doc.reference,
      chineseName: doc.data()!['chineseName']?? '',
      engName: doc.data()!['engName']?? '',
      timestamp: doc.data()!['timestamp']?.toDate(),
      keywords: ((doc.data()?['keywords'] as List?) ?? []).cast<String>(),
      pdtCategoryId: doc.data()!['pdtCategoryId']?? '',
      pdtCategoryName: doc.data()!['pdtCategoryName']?? '',
    );
  }


  Future<void> update() async {
    await docRef!.update(toMap);
  }
}