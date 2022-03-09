import 'package:cloud_firestore/cloud_firestore.dart';

import 'Info.dart';


/// Marketing content for the website.
/// Under Firebase/Location(eShop)/Post
///
///
/// To do list : Adding a array for series of photos
/// To do list: add a list for storing product SKU. Needed to retreved in the product section.
/// To do list: dd a tag function for categories.
class Post {
  DocumentReference? docRef;
  DateTime createDate;
  DateTime updateDate;
  String title;
  String content;
  InfoStatus infoStatus;




  Post({this.docRef, required this.createDate,required this.updateDate,required this.title , required this.content, required this.infoStatus});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,
        'title': title,
        'content': content,
    'infoStatus' : InfoStatus.values.indexOf(this.infoStatus),


      };
  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Post(
      docRef: doc.reference,
      infoStatus: InfoStatus.values.elementAt(doc.data()?['infoStatus'] ?? 0),
      createDate: doc.data()?['createDate']?.toDate(),
      updateDate: doc.data()?['updateDate']?.toDate(),
      title: doc.data()?['title'],
      content: doc.data()?['content'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
