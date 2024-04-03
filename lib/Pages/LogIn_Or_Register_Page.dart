import 'package:click_n_collect/Pages/Login_Page.dart';
import 'package:flutter/material.dart';

import 'Register_Page.dart';

class LogInOrRegisterPage extends StatefulWidget {
  const LogInOrRegisterPage({super.key});

  @override
  State<LogInOrRegisterPage> createState() => _LogInOrRegisterPageState();
}

class _LogInOrRegisterPageState extends State<LogInOrRegisterPage> {

  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage; // Toggle the value
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LogInPage(onTap: togglePages);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
