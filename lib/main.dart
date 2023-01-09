import 'package:flutter/material.dart';
import 'package:permission_flutter/HomePage.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    title: "Flutter Permission - Mabanta",
    home: const HomePage(),
  )
  );
}