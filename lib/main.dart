import 'package:flutter/material.dart';

import 'src/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Where Is My Cheese?',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: HomePage(),
    ),
  );
}
