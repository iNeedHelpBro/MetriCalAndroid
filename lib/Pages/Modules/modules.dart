// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Pages/Modules/ingredients_page.dart';
import 'package:metrical/Pages/Modules/log_food_page.dart';
import 'package:metrical/Pages/Modules/set_quota_page.dart';
import 'package:metrical/Pages/home_page.dart';
import 'package:metrical/Pages/profile_page.dart';

class Modules extends StatefulWidget {
  final String userId;
  const Modules({super.key, required this.userId});

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(userId: widget.userId),
      SetQuotaPage(userId: widget.userId),
      LogFoodPage(userId: widget.userId),
      IngredientsPage()
    ];

    return SafeArea(
      child: PopScope(
        canPop: false,
        //onPopInvoked: ,
        //onPopInvokedWithResult: (type, res) => false,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 251, 198),
          body: IndexedStack(
            index: currentPage,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: tapPages,
            backgroundColor: yellowScheme,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.set_meal), label: 'Set Quota'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.food_bank), label: 'Log Food'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search Ingredients')
            ],
          ),
        ),
      ),
    );
  }

  void tapPages(int index) {
    setState(() {
      currentPage = index;
    });
  }
}
