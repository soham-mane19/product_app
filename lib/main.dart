import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:global_infotech/HomeScreen.dart';
import 'package:global_infotech/Login.dart';
import 'package:global_infotech/firebase_options.dart';
import 'package:global_infotech/signupScreen.dart';
import 'package:global_infotech/userprovider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    ChangeNotifierProvider(create:(context) {
      return UserProvider();
    },
  child:   const MainApp()
  )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
       theme: ThemeData(
          primaryColor: const Color.fromRGBO(255, 255, 255, 1),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color.fromRGBO(255, 122, 0, 1),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color.fromRGBO(3, 13, 14, 1),
            tertiary: const Color.fromRGBO(121, 119, 128, 1),
          )),
          routes: {
            '/home':(context){
              return const HomeScreen();
            },
            '/login':(context){
return const Login();
            }
          },
      home: const RegistrationScreen(),
    );
  }
}
