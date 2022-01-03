import 'package:flutter/material.dart';

import 'AboutEllieERPView.dart';
import 'AboutPlatformView.dart';

class AboutOptionsView extends StatelessWidget {
  const AboutOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('About this app'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutEllieERPView())),
          ),
          // ListTile(
          //   title: Text('About this platform'),
          //   trailing: Icon(Icons.chevron_right),
          //   onTap: () => Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => AboutPlatformView())),
          // )
        ],
      ),
    );
  }
}
