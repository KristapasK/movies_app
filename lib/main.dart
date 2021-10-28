import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/movies_overview_screen.dart';
import 'providers/movies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Movies(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white10,
        ),
        home: MoviesOverviewScreen(),
      ),
    );
  }
}
