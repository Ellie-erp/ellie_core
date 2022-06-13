import 'package:flutter/material.dart';
import 'package:liquidity_gallery/liquidity_gallery.dart';

import 'AboutOptionsView.dart';

class SettingView extends StatelessWidget {
  const SettingView(
      {Key? key,
      required this.name,
      required this.title,
      required this.onLogOut})
      : super(key: key);

  final String name;
  final String title;
  final Function() onLogOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white24,
        title: Text("Setting".toUpperCase()),
      ),
      body: ListView(
        children: [
          ListTile(
            dense: true,
            title: Text("Personal".toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: MailboxContainer(
              onTap: () {},
              Radius: 18,
              padding: 8,
              child: ListTile(
                leading: Icon(
                  Icons.account_circle_rounded,
                  color: Colors.cyan[600],
                  size: 30,
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontSize: 19),
                ),
                subtitle: Text(title),
                trailing: const Text(
                  "Account",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text("Setting".toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: MailboxContainer(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AboutOptionsView()));
                },
                Radius: 8,
                padding: 0,
                child: const ListTile(
                  title: Text("About"),
                )),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: ListTile(
              title: const Text("Logout"),
              onTap: () async {
                await showYesNoModal(context, () async {
                  await onLogOut();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
