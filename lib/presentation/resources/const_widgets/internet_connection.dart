import 'dart:io';

import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool> checkNetwork() async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    }
  } on SocketException catch (_) {
    isConnected = false;
  }
  return isConnected;
}

class NotConnectedScreen extends StatelessWidget {
  const NotConnectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.primary, ColorsManager.white],
            begin: const Alignment(0, -1),
            end: const Alignment(0, 1),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                color: Colors.redAccent,
                size: 150.sp,
              ),
              SizedBox(
                height: 20.h,
                width: 360.h,
              ),
              Text(
                'No Internet Connection',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
