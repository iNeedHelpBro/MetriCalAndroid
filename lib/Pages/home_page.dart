// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metrical/Pages/Modules/ingredients_page.dart';
import 'package:metrical/Pages/Modules/log_food_page.dart';
import 'package:metrical/Pages/Modules/set_quota_page.dart';
import 'package:metrical/Pages/profile_page.dart';
import 'package:metrical/auth/supabase_auth.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int quota = 0;
  int totalCalories = 0;
  List<Map<String, dynamic>> foodLogs = [];
  double get progress => quota == 0 ? 0 : totalCalories / quota;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: profilePage,
            icon: Icon(
              Icons.account_circle_sharp,
              size: 30,
            ),
          )
        ],
        title: Text('Metrical'),
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome! ${SupabaseAuth.instance.getCurrentUser()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Daily Quota: $quota kcal'),
            const SizedBox(
              height: 20,
            ),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade300,
              color: progressColor,
              minHeight: 12,
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Total Consumed: $totalCalories kcal'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Today\'s Food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ...foodLogs.map(
              (e) => ListTile(
                title: Text(e['food']),
                trailing: Text('${e['calories']} kcal'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetQuotaPage(
                          userId: widget.userId,
                        ),
                      ),
                    );
                    loadData();
                  },
                  label: Text('Set Quota'),
                  icon: Icon(Icons.input),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogFoodPage(
                          userId: widget.userId,
                        ),
                      ),
                    );
                    loadData();
                  },
                  label: Text('Log Food'),
                  icon: Icon(Icons.food_bank),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IngredientsPage()),
                    );
                    loadData();
                  },
                  label: Text('Lookup'),
                  icon: Icon(Icons.search),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final usersQuotas = await SupabaseAuth.client
        .from('Usersquotas')
        .select()
        .eq('userId', widget.userId)
        .eq('date', today)
        .maybeSingle();

    final logs = await SupabaseAuth.client
        .from('Foodlogs')
        .select()
        .eq('userId', widget.userId)
        .eq('date', today);

    setState(() {
      quota = usersQuotas != null ? usersQuotas['quota'] : 0;
      foodLogs = List<Map<String, dynamic>>.from(logs);
      totalCalories = foodLogs.fold(
          0, (sum, item) => sum + (item['calories'] as num).toInt());
    });
  }

  Color get progressColor {
    if (progress < 0.75) return Colors.green;
    if (progress < 1.0) return Colors.red;
    return Colors.red;
  }

  void profilePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
