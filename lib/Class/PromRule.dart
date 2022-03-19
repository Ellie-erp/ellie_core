import 'package:cloud_firestore/cloud_firestore.dart';

enum PromRuleStatus{
  Active,
  Inactive,
}

enum RuleType{
  R1Discount,   ///A款貨品獲得折扣/減價/促銷價
  R2Staired    ///A階梯式貨品獲得折扣/減價/促銷價
}




class PromRule {
  DocumentReference? docRef;
  DateTime createDate; 
  DateTime updateDate;
  String ruleName;
  bool isDateRequired;
  DateTime? startDate;
  DateTime? EndDate;
PromRuleStatus promRuleStatus;
bool allowRetail;
bool allowWholsale;
bool allowOnline;
bool allowStockIn;
String promListId;





  PromRule({this.docRef, required this.createDate, required this.updateDate,required this.ruleName ,this.isDateRequired=false, this.startDate, this.EndDate, required this.promRuleStatus, this.allowRetail=false,  this.allowWholsale=false, this.allowOnline=false, this.allowStockIn=false, allowWholesale, required this.promListId});
  Map<String, dynamic> get toMap => {
        'createDate': createDate,
        'updateDate': updateDate,      
        'ruleName': ruleName,  
        'isDateRequired': isDateRequired,
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
      isDateRequired: doc.data()!['isDateRequired']?? false,
      startDate: doc.data()!['startDate']?.date() ?? DateTime.now(),
      EndDate: doc.data()!['EndDate']?.date() ?? DateTime.now(),
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




class PromRuleItem {
  DocumentReference? docRef;
  String plu; 
  String name;



  PromRuleItem({this.docRef,required this.plu,required this.name});
  Map<String, dynamic> get toMap => {
        'plu': plu,
        'name': name,      

      };
  factory PromRuleItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromRuleItem(
      docRef: doc.reference,
      plu: doc.data()!['plu'],
      name: doc.data()!['name'],


    );
  }

  Future<void> update() async {
    await docRef!.update(toMap);
  }
}
