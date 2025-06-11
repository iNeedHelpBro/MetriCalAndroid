// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/profile_page.dart';
import 'package:metrical/auth/supabase_auth.dart';

class SetQuotaPage extends StatefulWidget {
  final String userId;
  const SetQuotaPage({super.key, required this.userId});

  @override
  State<SetQuotaPage> createState() => _SetQuotaPageState();
}

class _SetQuotaPageState extends State<SetQuotaPage> {
  final quotaController = TextEditingController();
  bool isLoading = false;
  final con = ['userId', 'date'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Enter your daily calorie goal (e.g 100 kcal): ',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: quotaController,
            decoration: InputDecoration(
              labelText: 'Daily Quota (kcal)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: isLoading ? null : saveQuota,
            child: isLoading
                ? SpinKitFadingCircle(
                    color: yellowScheme,
                  )
                : Text('Save Quota'),
          ),
        ],
      ),
    );
  }

  Future<void> saveQuota() async {
    final quota = int.tryParse(quotaController.text.trim());

    if (quota == null || quota <= 0) {
      return;
    }

    loadingDialog().then((v) async {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      final supabase = SupabaseAuth.client;
      final quotaToday = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await supabase.from('Usersquotas').upsert({
        'userId': widget.userId,
        'date': quotaToday,
        'quota': quota,
      }, onConflict: con.join(','));

      EasyLoading.dismiss();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      States.instance.showtheSnackbar(
          title: 'Quota save successfully!', color: yellowScheme, duration: 5);
      //Navigator.pop(context);
    });
  }
}
