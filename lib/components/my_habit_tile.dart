import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? editHabit;
  final Function(BuildContext)? deleteHabit;
  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
           children: [
            // edit
      
            SlidableAction(onPressed: editHabit,
            backgroundColor: Colors.green.shade800,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(10),
            ),
      
            // delete
            SlidableAction(onPressed: deleteHabit,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
            ),
      
      
      
           ]),
        child: GestureDetector(
          onTap: (){
            if(onChanged != null){
              // toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF4CAF50) : Theme.of(context).colorScheme.secondary, 
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
           
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.black87, // Improved contrast
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: const Color(0xFF66BB6A), // Softer green for checkbox
                checkColor: Colors.white, // White checkmark for contrast
              ),
            ),
          ),
        ),
      ),
    );
  }
}
