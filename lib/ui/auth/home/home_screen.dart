import 'package:flutter/material.dart';
import 'package:myapp/ui/auth/home/widgets/activity_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: ActivityWidget(),
    );
  }
}
