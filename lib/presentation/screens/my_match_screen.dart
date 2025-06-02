import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matchbox_app/common/assets/index.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';

class MyMatchScreen extends StatefulWidget {
  final String eventId;

  const MyMatchScreen({super.key, required this.eventId});

  @override
  State<MyMatchScreen> createState() => _MyMatchScreenState();
}

class _MyMatchScreenState extends State<MyMatchScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MatchProvider>(context, listen: false)
        .fetchMatchResult(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final match = matchProvider.currentMatch;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Match')),
      body: Center(
        child: matchProvider.isLoading
            ? const CircularProgressIndicator()
            : match == null
                ? const Text('No match found yet.')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Container(
                        width: 100.0, // Set the desired width
                        height: 100.0, // Set the desired height
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
                                    fit: BoxFit.fill,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        match.matchedUserName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Matched in Event: ${match.eventId}'),
                    ],
                  ),
      ),
    );
  }
}
