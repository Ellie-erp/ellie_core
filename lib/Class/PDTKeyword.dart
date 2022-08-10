import 'package:cloud_firestore/cloud_firestore.dart';

class PDTKeyword {
  DocumentReference? docRef;
  String chineseName;
  String engName;
  DateTime timestamp;
  List<String> keywords;
String pdtCategoryId;


  PDTKeyword({this.docRef,required this.chineseName,required this.engName,required this.timestamp , this.keywords = const [], this.pdtCategoryId=''});
  Map<String, dynamic> get toMap => {
        'chineseName': chineseName,
        'engName': engName,
        'timestamp': timestamp,
    'keywords': keywords,
    'pdtCategoryId': pdtCategoryId,

      };
  factory PDTKeyword.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PDTKeyword(
      docRef: doc.reference,
      chineseName: doc.data()!['chineseName']?? '',
      engName: doc.data()!['engName']?? '',
      timestamp: doc.data()!['timestamp']?.toDate(),
      keywords: ((doc.data()?['keywords'] as List?) ?? []).cast<String>(),
      pdtCategoryId: doc.data()!['pdtCategoryId']?? '',
    );
  }


  Future<void> update() async {
    await docRef!.update(toMap);
  }
}