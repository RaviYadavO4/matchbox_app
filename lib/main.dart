import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matchbox_app/config.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/auth_providers.dart';
import 'presentation/providers/chat_provider.dart' show ChatProvider;
import 'presentation/providers/event_provider.dart';
import 'presentation/providers/match_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MatchboxApp());
}

class MatchboxApp extends StatelessWidget {
  const MatchboxApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: appColors.red,
        scaffoldBackgroundColor: Colors.white, 
        
        appBarTheme: AppBarTheme(
          backgroundColor: appColors.red, 
          foregroundColor: Colors.white, 
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black), 
          bodyMedium: TextStyle(color: appColors.red, fontWeight: FontWeight.bold),
        ),
        
        inputDecorationTheme:  InputDecorationTheme(
      labelStyle: TextStyle(color: appColors.red),
      hintStyle: TextStyle(color: appColors.redAccent),
        enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: appColors.red),
    
      
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: appColors.red, width: 2.0),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: appColors.red),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: appColors.red, width: 2.0),
    ),
    
    ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.red, 
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: appColors.red, 
        ),
        iconTheme: IconThemeData(
          color: appColors.red, 
        ),
      ),
        home: const SplashScreen(),
      ),
    );
  }
}

