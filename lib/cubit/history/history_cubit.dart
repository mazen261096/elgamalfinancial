import 'dart:async';
import 'package:moneytrack/cubit/history/history_states.dart';
import 'package:moneytrack/presentation/resources/assets_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/remote/dio_service_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HistoryCubit extends Cubit<HistoryStates>{

  HistoryCubit():super(HistoryInitiateState());
  List<String> categories =[];
  List<String> membersName =[];
  List<String> walletsName =[];
  List<String> filterCategory=[] ;
  List<String> filterName=[] ;
  List<String> filterWallets=[] ;
  DateTime? filterAfter ;
  DateTime? filterBefore ;
  Transactions? currentTrans ;
  List<Transactions> allTrans =[];
  List<Transactions> visibleTrans =[];
  int? total  ;
  bool filtered = false ;
  final navigatorKey = GlobalKey<NavigatorState>();

 // StreamSubscription<DocumentSnapshot<Object?>>? docStream ;
  @override
  Future<void> close() {
  //  docStream?.cancel();
    // TODO: implement close
    return super.close();
  }

Future<void> initiateFilters() async{
    List<String> categories = [];
    List<String> membersName = [];
    List<String> walletsName = [];
    for (var element in allTrans) {
      categories.add(element.category);
      membersName.add(element.name);
      walletsName.add(element.walletName);
      this.categories=categories.toSet().toList();
      this.membersName=membersName.toSet().toList();
      this.walletsName=walletsName.toSet().toList();
    }
    print('fffffffffffffffffffff${this.walletsName}');
}

Future<void> calculateTotal()async {
    total = 0 ;
    for (var element in visibleTrans) {
      total = total! + element.amount;
    }
    emit(HistoryCalculateTotalState());
  }

  clearFilters(){
    filterBefore=null;
    filterAfter=null;
    filterName=[];
    filterCategory=[];
    filtered = false ;
    filterWallets=[];
    filterTrans();
  }

  Future<void> filterTrans() async {
    emit(HistoryFilterLoadingState());
List<Transactions> filterTrans = [];
if(filterCategory.isNotEmpty || filterName.isNotEmpty||filterAfter !=null||filterBefore!=null||filterWallets.isNotEmpty){
  filterTrans = allTrans.where((element) {
    return
      (filterWallets.isEmpty||walletsName.length==1? true : filterWallets.contains(element.walletName))
          && (filterCategory.isEmpty? true : filterCategory.contains(element.category))
        && (filterName.isEmpty? true : filterName.contains(element.name))
        && (filterAfter==null?true:(element.createdAt.isAfter(filterAfter!)||element.createdAt.isAtSameMomentAs(filterAfter!)))
        && (filterBefore==null?true:(element.createdAt.isBefore(filterBefore!)||element.createdAt.isAtSameMomentAs(filterBefore!)));
  }).toList();
  visibleTrans = filterTrans ;
  await calculateTotal();
  filtered = true ;
}else{
  visibleTrans = allTrans ;
  filtered = false ;
}
 visibleTrans.sort((a,b) => b.createdAt.compareTo(a.createdAt));
emit(HistoryFilterSuccessState());
  }


  fetchTran(List<Transactions> transactions) async {
    emit(HistoryLoadingState());
    allTrans=transactions;
    await initiateFilters();
    await filterTrans();
    emit(HistorySuccessState());

/*
docStream = FirebaseServiceFireStore().listenDocument(collection: 'wallets', document: walletId).listen((document) async {

      allTrans=[];
      for (var element in (document['transactions'] as List)) {

        allTrans.add(Transactions.fromJson({
          'amount':element['amount'] ,
          'name':element['name'] ,
          'uId':element['uId'] ,
          'description':element['description'] ,
          'bill':element['bill'] ,
          'type':element['type'] ,
          'category':element['category'] ,
          'createdAt':DateTime.fromMicrosecondsSinceEpoch(element['createdAt'].microsecondsSinceEpoch) ,

        }));
      }
      await initiateFilters();
      await filterTrans();

      emit(HistorySuccessState());
    });

 */

  }
Future deletePhoto() async{
  final storageRef =FirebaseStorage.instance.refFromURL(currentTrans!.bill);
  await storageRef.delete();
}
  Future<void> deleteTran({required String walletId,required String walletName})async {
    emit(HistoryDeleteLoadingState());
    try{
print('testtt1');
DocumentReference<Map<String, dynamic>> transRef = FirebaseFirestore.instance.collection('wallets').doc(walletId);
      await transRef.update( {'transactions':FieldValue.arrayRemove([{
        'walletName':currentTrans!.walletName,
        'createdAt':Timestamp.fromDate(currentTrans!.createdAt),
        'type':currentTrans!.type,
        'amount':currentTrans!.amount,
        'name':currentTrans!.name,
        'description':currentTrans!.description,
        'category':currentTrans!.category,
        'bill':currentTrans!.bill,
        'uId':currentTrans!.uId
      }])}).then((value)  async {
        print('test2');
        if(currentTrans?.type=="pay") {
           deletePhoto();
        }
        allTrans.remove(currentTrans);
        await filterTrans();

        Map data = {
          'notificationType': 'deleteTrans',
          'walletName': currentTrans!.walletName,
          'createdAt': currentTrans!.createdAt.toString(),
          'type': currentTrans!.type,
          'amount': currentTrans!.amount,
          'name': currentTrans!.name,
          'uId': FirebaseAuth.instance.currentUser!.uid,
          'description': currentTrans!.description,
          'category': currentTrans!.category,
          'bill': currentTrans!.type == 'pay' ? currentTrans!.bill : ''
        };
          final String fcmServerKey =
              'AAAAvryTNvE:APA91bGKSadCy-6c1hovrQbmaR4tV4TM80vRitUpibn-SyQCx5NDuapTuR4zX8LirPgmoApFOnIYPfe5QZV9Vx2rkZ8cibfTiUeKnBgyD9vGYQDDjPkV1asviUli-2OtNetNY4NuSGzy';
          DioServiceHelper.init(url: 'https://fcm.googleapis.com/fcm/');
           DioServiceHelper.postData(
            url: 'send',
            data: {
              "to": '/topics/$walletId',
              "priority": "high",
              "data": data,
              "notification": {
                "title": currentTrans!.walletName,
                "body": 'Transaction deleted By ${currentTrans!.name} ${currentTrans!.amount}EGP',
              },
            },
            headers: {
              'Authorization': 'key=$fcmServerKey',
              'Content-Type': 'application/json'
            },
          );


        emit(HistoryDeleteSuccessState());


      });
    }catch (error){
      print('test3');
      emit(HistoryDeleteFailedState());
      rethrow;
    }

  }

  ImageProvider transImage(){
    switch(currentTrans!.type){
      case 'pay' :
        return NetworkImage(currentTrans!.bill ) ;

      case 'withdraw' :
        return const AssetImage(ImageAssets.withdraw);

      case 'deposit' :
        return const AssetImage(ImageAssets.deposit);
    }
    return NetworkImage(currentTrans!.bill ) ;
  }


  addToFilterCategory(String? val) async {
    filterCategory.add(val!);
    await filterTrans();
    emit(HistoryFilterSuccessState());
  }

  changeFilterName(String? val) async {
    filterName.add(val!);
    await filterTrans();
    emit(HistoryFilterSuccessState());
  }
  changeFilterAfter(DateTime? val) async {
    filterAfter=val;
    await filterTrans();
    emit(HistoryFilterSuccessState());
  }
  changeFilterBefore(DateTime? val) async {
    filterBefore=val;
    await filterTrans();
    emit(HistoryFilterSuccessState());
  }


}