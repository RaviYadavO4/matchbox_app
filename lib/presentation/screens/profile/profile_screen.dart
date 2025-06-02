import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matchbox_app/config.dart';
import 'package:matchbox_app/presentation/screens/auth/login_screen.dart';
import 'package:matchbox_app/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/assets/index.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body:Container(child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
              ? const Center(child: Text('No user signed in'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      Container(
                        width: 100.0, // Set the desired width
                        height: 100.0, // Set the desired height
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child:
                              user.photoURL != null
                                  ? Image.network(
                                    user.photoURL!,
                                    fit: BoxFit.fill,
                                  )
                                  : SvgPicture.asset(
                                    eSvgAssets.male,
                                    fit: BoxFit.fill,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.displayName ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.email ?? 'No Email',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_)=>SplashScreen())
                          ); // Adjust route as needed
                        },
                        child:  Text("Sign Out",style: TextStyle(color: appColors.white),),
                      ),
                    ],
                  ),
                ),
              ),)
    );
  }
}
