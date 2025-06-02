import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matchbox_app/config.dart';
import 'package:provider/provider.dart';
import '../../common/assets/index.dart';
import '../providers/event_provider.dart';
import 'onboarding_screen.dart'; // Your existing onboarding screen

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Events')),
      body: provider.isLoading
      ? Center(child: CircularProgressIndicator()) 
      : provider.events.isEmpty
          ? Center(
              child: SvgPicture.asset(eSvgAssets.noEvent, fit: BoxFit.fill),
            )
          : ListView.builder(
              itemCount: provider.events.length,
              itemBuilder: (context, index) {
                final event = provider.events[index];
                return Card(
                  color: appColors.crimson,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(event.title,style: TextStyle(color: appColors.white),),
                    subtitle: Text('${event.location} • ${event.date}',style: TextStyle(color: appColors.subtitleGray),),
                    trailing:  Icon(Icons.arrow_forward,color: appColors.white,),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OnboardingScreen(eventId: event.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
