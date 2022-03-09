import 'package:cloud_firestore/cloud_firestore.dart';


/// Marketing content for the website.
/// Under Firebase/Location(eShop)/Post
///
///
/// To do list : Adding a array for series of photos
/// Adding a list for storing product SKU. Needed to retreved in the product section.
class Post {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String title;
  String Content;




  Post({this.docRef, required this.createDate,required this.updateDate,required this.title , required this.Content,});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'title': title,
        'Content': Content,


      };
  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Post(
      docRef: doc.reference,
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      title: doc.data()?['title'],
      Content: doc.data()?['Content'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
