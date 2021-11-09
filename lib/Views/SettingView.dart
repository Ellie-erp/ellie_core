
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquidity_gallery/liquidity_gallery.dart';

import 'AboutOptionsView.dart';


class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

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
              onTap: (){

              },
              Radius: 18,
              padding: 8,
              child: ListTile(
                leading: Icon(Icons.account_circle_rounded,color: Colors.cyan[600],size: 30,),
                title: Text("Sam Siu",style: TextStyle(fontSize: 19),),
                subtitle: Text("System Manager"),
                trailing: Text("Account",style: TextStyle(fontSize: 15),),
              ),),
          ),
          ListTile(
            dense: true,
            title: Text("Setting".toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: MailboxContainer(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AboutOptionsView()));
              },
                Radius: 8,
                padding: 0,
                child: ListTile(title: Text("About"),)),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: ListTile(title: Text("Logout"),),
          ),
        ],
      ),
    );
  }
}
