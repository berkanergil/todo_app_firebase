import 'package:flutter/material.dart';


class CustomAppBar{
  String title;
  CustomAppBar({required this.title});

  AppBar appBar (){
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }
}