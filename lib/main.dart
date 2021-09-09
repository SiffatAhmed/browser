import 'package:flutter/material.dart';
import 'browser.dart';

void main() {
  runApp(
    MaterialApp(
      home: Browser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    ),
  );
}
