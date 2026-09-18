import 'package:esp32/application/view/setup_page.dart';
import 'package:esp32/application/view_model/scratch_program_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esp32/application/view_model/setup_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SetupViewModel()),
        ChangeNotifierProvider(
          create: (_) => ScratchProgramViewModel(selectedClass: 3),
        ), // Default class
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knowli Bot',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SetupPage(),
      // home: const ActivityListPage(selectedClass: 3,),
    );
  }
}
