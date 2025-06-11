// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:metrical/Components/progress_pie_chart.dart';
import 'package:metrical/Dumps/dumps.dart';
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
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: profilePage,
            icon: Icon(
              Icons.account_circle_sharp,
              size: 40,
            ),
          )
        ],
        title: Text(
          'MetriCal',
          style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
              letterSpacing: 1.2),
        ),
      ),
      body: RefreshIndicator(
        displacement: 12,
        color: Colors.amberAccent,
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome! ${SupabaseAuth.instance.getCurrentUser()}',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: const Color.fromARGB(255, 123, 44, 191),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Daily Quota: $quota kcal',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 249, 132, 74),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 100,
                          child: ProgressPieChart(
                            progress: progress.clamp(0.0, 1.0),
                            color: progressColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Total Consumed: $totalCalories kcal',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
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
              foodLogs.isEmpty
                  ? Center(
                      child: Text(
                        'Food Logs Empty',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : Column(
                      children: foodLogs
                          .map(
                            (e) => ListTile(
                              title: Text(e['food']),
                              trailing: Text('${e['calories']} kcal'),
                            ),
                          )
                          .toList(),
                    ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void profilePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  Future<void> loadData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    loadingDialog().then((v) async {
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
      if (!mounted) return;
      setState(() {
        quota = usersQuotas != null ? usersQuotas['quota'] : 0;
        foodLogs = List<Map<String, dynamic>>.from(logs);
        totalCalories = foodLogs.fold(
            0, (sum, item) => sum + (item['calories'] as num).toInt());
      });
      EasyLoading.dismiss();
    });
  }

  Color get progressColor {
    if (progress < 0.75) return Colors.green;
    if (progress < 1.0) return Colors.red;
    return Colors.red;
  }
}
