import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:book3/Screen/pdfScreen.dart';
void main() async{

 await GetStorage.init();
  runApp(GetMaterialApp(

    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

