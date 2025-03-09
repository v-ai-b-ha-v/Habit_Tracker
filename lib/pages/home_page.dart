import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heatmap.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    // read existing habits on app startup

    Provider.of<HabitDatabase>(context,listen: false).readHabits();

    super.initState();
  }


  final TextEditingController textController = TextEditingController();

  // check habit on or off

  void checkHabitOnOff(bool? value , Habit habit){

    // Update the habit completion status

    if(value != null){
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }

  }

  void createNewHabit(){

    showDialog(context: context
    , builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: "Create a new habit !",
        ),
      ),

      actions: [
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // save button
        MaterialButton(onPressed : () {
          String newHabitName = textController.text;

          // save to db
          if(newHabitName.isNotEmpty)
         { context.read<HabitDatabase>().addHabit(newHabitName);}

          textController.clear();
          Navigator.pop(context);
          
         

        },
        child: Text("Save",style: TextStyle(
        fontWeight: FontWeight.bold
      )),),


        // cancel button
        MaterialButton(
          onPressed: ()  {Navigator.pop(context);
           textController.clear();
          },
        child: Text("Cancel",style: TextStyle(
        fontWeight: FontWeight.bold
      )),)
          ],
        )
      ],

    ));
  }

  
  void editHabitBox(Habit habit){
    // set the controller's text to habit's current name

    textController.text = habit.name;

    showDialog(
      context: context
    , builder: (context) => AlertDialog(
      content: TextField(controller: textController,),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // save button
        MaterialButton(onPressed : () {
          String newHabitName = textController.text;

          // save to db
          context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);

          textController.clear();
          Navigator.pop(context);

          

        },
        child: Text("Save",style: TextStyle(
        fontWeight: FontWeight.bold
      )),),


        // cancel button
        MaterialButton(
          onPressed: ()  {Navigator.pop(context);
          textController.clear();
          },
        child: Text("Cancel",style: TextStyle(
        fontWeight: FontWeight.bold
      )),)
          ],
        )
      ],
    ));

  }

  void deleteHabitBox(Habit habit){
       showDialog(context: context
    , builder: (context) => AlertDialog(
      content: Text("Are you sure want to delete the habit ?",style: TextStyle(
        fontWeight: FontWeight.bold
      ),),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // delete button
        MaterialButton(onPressed : () {
        
          // save to db
          context.read<HabitDatabase>().deleteHabit(habit.id);

          Navigator.pop(context);

        },
        child: Text("Delete",style: TextStyle(
        fontWeight: FontWeight.bold
      )),),


        // cancel button
        MaterialButton(
          onPressed: ()  {
          Navigator.pop(context);
          textController.clear();
          },
        child: Text("Cancel",style: TextStyle(
        fontWeight: FontWeight.bold
      )),
        
        )
          ],
        )
      ],

    ));
  }

  Widget _buildHabitList(){

    // habit db

    final habitDataBase = context.watch<HabitDatabase>();

    // current habit
    List<Habit> currentHabits = habitDataBase.currentHabits;

    // return list of habits for the habits UI

    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
      
          // get each individual habit
      
          final habit = currentHabits[index];
      
          // check if the habit is completed today
      
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
      
          // return habit tile UI
          return MyHabitTile(
            isCompleted: isCompletedToday, 
            text: habit.name,
             onChanged:(value) => checkHabitOnOff(value,habit),
             editHabit : (context) => editHabitBox(habit),
             deleteHabit: (context) => deleteHabitBox(habit),
             );
      
      
      }),
    );

  }

  Widget _buildHeatMap(){
    
    // habit database
    final habitDataBase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDataBase.currentHabits;

    // heatmap

    return FutureBuilder<DateTime?>(
      future: habitDataBase.getFirstLaunchDate(),
       builder: (context,snapshot){
        // once the data is availabe -> build

        if(snapshot.hasData){
          return MyHeatmap(startDate: snapshot.data!,
           datasets: prepareMapDataSet(currentHabits));
        }


        // handle when no data exist
        else{
          return Container();
        }
       }
      );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add,
        color: Theme.of(context).colorScheme.inversePrimary,),
      ),
      body: ListView(
        children: [
          
          // heatmap
          _buildHeatMap(),

          // habit list 
          _buildHabitList()
        ],
      ),
    );
  }
}