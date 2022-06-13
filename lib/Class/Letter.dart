import 'package:cloud_firestore/cloud_firestore.dart';

///信件Template, for quick/Auto letter generation
class Letter {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime letterDate;
  String? letterTitle;
  String recipient;
  String content;
  String complimentaryClose;

  Letter({
    this.docRef,
    required this.createDate,
    required this.letterDate,
    this.letterTitle = '',
    this.recipient = '',
    required this.content,
    required this.complimentaryClose,
  });
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'letterDate': letterDate,
        'letterTitle': letterTitle,
        'recipient': recipient,
        'content': content,
        'complimentaryClose': complimentaryClose,
      };
  factory Letter.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Letter(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      letterDate: doc.data()!['letterDate']?.toDate(),
      letterTitle: doc.data()!['letterTitle'] ?? '',
      recipient: doc.data()!['recipient'] ?? '',
      content: doc.data()!['content'] ?? '',
      complimentaryClose: doc.data()!['complimentaryClose'] ?? '',
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
