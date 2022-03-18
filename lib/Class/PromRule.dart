import 'package:cloud_firestore/cloud_firestore.dart';

enum PromRuleStatus{
  Active,
  Inactive,
}

class PromRule {
  DocumentReference? docRef;
  DateTime createDate; 
  DateTime updateDate;
  String ruleName;
  bool allowDate;
  DateTime? startDate;
  DateTime? EndDate;
PromRuleStatus promRuleStatus;
bool allowRetail;
bool allowWholsale;
bool allowOnline;
bool allowStockIn;
String promListId;



  PromRule({this.docRef, required this.createDate, required this.updateDate,required this.ruleName ,this.allowDate=false, this.startDate, this.EndDate, required this.promRuleStatus, this.allowRetail=false,  this.allowWholsale=false, this.allowOnline=false, this.allowStockIn=false, allowWholesale, required this.promListId});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,      
        'ruleName': ruleName,  
        'allowDate': allowDate,
        'startDate': startDate,
        'EndDate': EndDate,
    'promRuleStatus' : PromRuleStatus.values.indexOf(this.promRuleStatus),
    'allowRetail' : allowRetail,
    'allowWholesale' : allowWholsale,
    'allowOnline' : allowOnline,
    'allowStockIn' : allowStockIn,
    'promListId' : promListId,
      };


  factory PromRule.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromRule(
      docRef: doc.reference,
      createDate: doc.data()!['createDate']?.date(),
      updateDate: doc.data()!['updateDate']?.date(),
      ruleName: doc.data()!['ruleName'],
      allowDate: doc.data()!['allowDate']?? false,
      startDate: doc.data()!['startDate']?.date(),
      EndDate: doc.data()!['EndDate']?.date(),
      promRuleStatus: PromRuleStatus.values.elementAt(doc.data()?['promRuleStatus'] ?? 0),
      allowRetail: doc.data()!['allowRetail']?? false,
      allowWholesale: doc.data()!['allowWholesale']?? false,
      allowOnline: doc.data()!['allowOnline']?? false,
      allowStockIn: doc.data()!['allowStockIn']?? false,
      promListId: doc.data()!['promListId'],
    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}