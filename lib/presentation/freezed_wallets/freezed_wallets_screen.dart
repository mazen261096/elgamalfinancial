import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:moneytrack/presentation/freezed_wallets/freezed_wallet_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';

class FreezedWalletsScreen extends StatefulWidget {
  const FreezedWalletsScreen({super.key});

  @override
  State<FreezedWalletsScreen> createState() => _FreezedWalletsScreenState();
}

class _FreezedWalletsScreenState extends State<FreezedWalletsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),

        title: Text('Freezed Wallets',style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.sp),),
        elevation: 0,

      ),
      body: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.primary, ColorsManager.white],
            begin: const Alignment(0, -1),
            end: const Alignment(0, 1),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseServiceFireStore.listenToFreezedWallets(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ConstWidgets.spinkit,
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                print(data);
                return FreezedWalletItem(
                    id: document.id,
                    title: data['name'],
                    description: data['description']);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
