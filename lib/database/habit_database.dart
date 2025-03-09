
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;

  /*
  
  Setup 

  Initialize database

  save first date of app startup(heatmap)

  get first date of app startup (for heatmap)

  */

  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitSchema,AppSettingsSchema], directory: dir.path);
  }

  Future<void> saveFirstLaunchDate() async{
    final existingSettings = await isar.appSettings.where().findFirst();

    if(existingSettings == null){
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async{
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // C R U D 

  // List of habits

  final List<Habit> currentHabits = [];

  // Create - add a habit

  Future<void> addHabit(String habitName) async{
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // read from db

    readHabits();

  }

  // Read - read habits

  Future<void> readHabits() async{

    // fetch all habits from db

    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habits

    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();

  }

  // Update habit name

  Future<void> updateHabitName(int id , String newName) async{

      final habit = await isar.habits.get(id);

      if(habit != null){
        await isar.writeTxn(() async{
          habit.name = newName;
          await isar.habits.put(habit);
        });
      }
    readHabits();
  }

  // Update habit on or off
  Future<void> updateHabitCompletion(int id , bool isCompleted) async{

    // find that habit of id

    final habit  = await isar.habits.get(id);

    // update completion status

    if(habit != null){
        await isar.writeTxn(() async{
          // if habit completed then add to current date to the completed days

          if(isCompleted && !habit.completedDays.contains(DateTime.now())){
            
            // today

            final today = DateTime.now();

            // add to current data if it is not in list

            habit.completedDays.add(
              DateTime(
                today.year,
                today.month,
                today.day
              )
            );


          }else{
            // remove the date if habit is marked as not complete

            habit.completedDays.removeWhere(
              (date) => 
            date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day,
            );

          }

          // save the updates habits to db

          await isar.habits.put(habit);

        });
    }
    readHabits();

  }

  // Delete Habit

  Future<void> deleteHabit (int id) async{
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }

}
