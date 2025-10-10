import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension AuthStateManagement on State {
  User? get currentAuthUser => FirebaseAuth.instance.currentUser;

  void checkAndUpdateAuthState(void Function(User?) updateCallback) {
    final user = FirebaseAuth.instance.currentUser;
    updateCallback(user);
  }
}

mixin AuthStateMixin<T extends StatefulWidget> on State<T> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }
}
