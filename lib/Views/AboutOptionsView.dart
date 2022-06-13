import 'package:flutter/material.dart';

import 'AboutEllieERPView.dart';

class AboutOptionsView extends StatelessWidget {
  const AboutOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('About this app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AboutEllieERPView())),
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
