import 'package:flutter/material.dart';

import 'add_task_view.dart';
import 'home/home_view.dart';
import 'home_view.dart';
import 'test.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int currentIndex=0;
  final children = [HomeView(),AddTaskView(),TodoHomePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: children[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex=value;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "add"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings",
          ),
        ],
      ),
    );
  }
}
