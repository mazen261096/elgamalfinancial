import 'dart:ui';

import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../assets_manager.dart';

class ConstWidgets {
  static Future messageDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Text(
              message,
              style: TextStyle(fontSize: 20.sp),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(AppStrings.close.tr(),
                          style: TextStyle(fontSize: 20.sp)),
                    )),
              )
            ],
          );
        });
  }

  static Future errorDialog(BuildContext context, String message) async {
    var errorMessage = message;
    if (message.toString().contains('email-already-in-use')) {
      errorMessage = AppStrings.emailExists.tr();
    } else if (message.toString().contains('user-not-found') ||
        message
            .toString()
            .contains('There is no account connected to this e-mail')) {
      errorMessage = AppStrings.userNotFound.tr();
    } else if (message.toString().contains('INVALID_PASSWORD') ||
        message.toString().contains('The password is invalid')) {
      errorMessage = AppStrings.invalidPassword.tr();
    } else if (message
        .toString()
        .contains('This credential is already associated')) {
      errorMessage = AppStrings.numberAlreadyConnected.tr();
    } else if (message.toString().contains('credential is invalid')) {
      errorMessage = AppStrings.verificationWrongCode.tr();
    }

    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.sp)),
                title: Text(
                  AppStrings.error.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                content: Center(
                  child: Text(errorMessage),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: ElevatedButton(
                      child: Text(AppStrings.close.tr(),
                          style: TextStyle(fontSize: 20.sp)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static void clickPhoto({required BuildContext ctx, required String url}) {
    showDialog(
        context: ctx,
        builder: (_) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 3.sp),
                  borderRadius: BorderRadius.all(Radius.circular(20.sp))),
              backgroundColor: Colors.transparent,
              child: Container(
                width: 360.w / 1.5,
                height: 736.h / 1.5,
                decoration: BoxDecoration(
                    image: url == ''
                        ? DecorationImage(image: AssetImage(ImageAssets.user))
                        : DecorationImage(
                            image: CachedNetworkImageProvider(url),
                          )),
              ),
            ),
          );
        });
  }

  static Widget emptyCircleImage({required double diameter}) {
    return CircleAvatar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      radius: diameter,
      backgroundImage: const AssetImage(ImageAssets.user),
    );
  }

  static Widget circleImage(
      {required String url,
      required double diameter,
      required BuildContext ctx}) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        clickPhoto(ctx: ctx, url: url);
      },
      child: url == ''
          ? emptyCircleImage(diameter: diameter)
          : CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: diameter,
                backgroundImage: imageProvider,
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircleAvatar(
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: diameter,
                backgroundImage: const AssetImage(ImageAssets.user),
                child: Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: diameter,
                backgroundImage: const AssetImage(ImageAssets.user),
              ),
            ),
    );
  }

  static final spinkit = SpinKitCircle(
    color: ColorsManager.lightprimary,
    size: 50.0.r,
  );

  static  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
    );
  }


  }

