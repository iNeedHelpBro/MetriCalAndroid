import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/auth/supabase_auth.dart';

class LogFoodPage extends StatefulWidget {
  final String userId;
  const LogFoodPage({super.key, required this.userId});

  @override
  State<LogFoodPage> createState() => _LogFoodPageState();
}

class _LogFoodPageState extends State<LogFoodPage> {
  final foodController = TextEditingController();
  final calorieController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    foodController.dispose();
    calorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: foodController,
            decoration: InputDecoration(
              labelText: 'What Food',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: calorieController,
            decoration: InputDecoration(
              labelText: 'Input Calories',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isLoading ? null : logFood,
              child: isLoading
                  ? SpinKitDualRing(color: yellowScheme)
                  : Text('Log Entry')),
        ],
      ),
    );
  }

  Future<void> logFood() async {
    final food = foodController.text.trim();
    final calories = int.tryParse(calorieController.text.trim());

    if (food.isEmpty || calories == null || calories <= 0) {
      print('debug');
      return;
    }

    setState(() {
      isLoading = true;
    });
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await SupabaseAuth.client.from('Foodlogs').insert({
      'userId': widget.userId,
      'food': food,
      'calories': calories,
      'date': today
    });

    setState(() {
      isLoading = false;
    });
    States.instance.showtheSnackbar(title: 'Food Log Saved!');
  }
}
