import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matchbox_app/config.dart';
import 'package:matchbox_app/presentation/providers/match_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/assets/index.dart';
import '../chat/chat_screen.dart';

class AllMatchedScreen extends StatefulWidget {
  const AllMatchedScreen({super.key});

  @override
  State<AllMatchedScreen> createState() => _AllMatchedScreenState();
}

class _AllMatchedScreenState extends State<AllMatchedScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    await Provider.of<MatchProvider>(context, listen: false).fetchMatches();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matches = Provider.of<MatchProvider>(context).matches;

    return Scaffold(
      appBar: AppBar(title: const Text('My Matches')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : matches.isEmpty
              ? const Center(child: Text('No matches yet!'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return Card(
                    elevation: 4,
                    color: appColors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 80.0, 
                          height: 80.0, 
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child:
                                match.matchedPhotoUrl.isNotEmpty
                                    ? Image.network(
                                      match.matchedPhotoUrl,
                                      fit: BoxFit.fill,
                                    )
                                    : SvgPicture.asset(
                                      eSvgAssets.male,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                          ),
                        ),
                        title: Text(
                          match.matchedUserName,
                          style: TextStyle(fontWeight: FontWeight.bold,color: appColors.black),
                        ),
                        subtitle: Text("Event: ${match.eventId}"),
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatScreen(
                                    otherUserId: match.matchedUserId,
                                    otherUserName: match.matchedUserName,
                                  ),
                            ),
                          ),
                    ),
                  );
                },
              ),
    );
  }
}
