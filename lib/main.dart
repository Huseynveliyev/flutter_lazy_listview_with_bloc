import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lazy_listview_with_bloc/core/observer/bloc.dart';

import 'views/home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );

  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Lazy listview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
