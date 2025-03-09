import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // init database

  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp( 
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => HabitDatabase())
      ] ,
       child: const MyApp())

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}