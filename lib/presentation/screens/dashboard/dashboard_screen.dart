import 'package:flutter/material.dart';
import 'package:matchbox_app/config.dart';

class DashboardScreen extends StatelessWidget {
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children:
              appArray.dashBoardItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return GestureDetector(
                  onTap: () =>  Navigator.push(context,MaterialPageRoute(builder: (context) => appArray.pages[index]),),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(item.icon,width: 50,height: 50,),
                        SizedBox(height: 10),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
