import 'package:cloud_firestore/cloud_firestore.dart';

class UserList {
  DocumentReference? docRef;
  DateTime createDate;
  String? displayName;
  String? email;




  UserList({this.docRef,required this.createDate, this.displayName, this.email});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'displayName': displayName,
        'email': email,


      };
  factory UserList.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserList(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.toDate(),
      displayName: doc.data()!['displayName']? 'Undefined',
      email: doc.data()!['email']?? '',


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}