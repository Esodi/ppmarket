// This file is not strictly necessary with current setup,
// but if you want to split MaterialApp config, this is a placeholder

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saleor App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(body: Center(child: Text('App Root'))),
    );
  }
}
