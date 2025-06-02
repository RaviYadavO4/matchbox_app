import 'package:flutter/material.dart';
import 'package:matchbox_app/common/assets/index.dart';

import '../data/models/dashboard_item_model.dart';
import '../presentation/screens/matched/all_matched_screen.dart';
import '../presentation/screens/event_list_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

class AppArray {

  final List<DashboardItemModel> dashBoardItems = [
    DashboardItemModel('Events', eImageAssets.dashboardEvent),
    DashboardItemModel('My Match', eImageAssets.dashboardMatch),
    DashboardItemModel('Profile', eImageAssets.dashboardProfile),
  ];

  final List<Widget> pages = [
  EventListScreen(),
  AllMatchedScreen(),
  ProfileScreen(),
];
}