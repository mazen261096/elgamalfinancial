import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../resources/const_widgets/const_widgets.dart';

class ViewPhoto extends StatelessWidget {
  ViewPhoto({super.key, required this.url});
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),


        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black87,
      body: Container(

          child: PhotoView(

              enablePanAlways: true,
              wantKeepAlive: true,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              errorBuilder: (context, tt, event) =>
                  Center(child: Text('No Image Found')),
              loadingBuilder: (context, event) =>
                  Center(child: Center(child: ConstWidgets.spinkit)),
              imageProvider: NetworkImage(url))),
    );
  }
}
