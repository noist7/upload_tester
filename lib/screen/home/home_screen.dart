import 'package:flutter/material.dart';

import '../upload/upload_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                child: Text("Upload Screen"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadScreen()));
                }),
            RaisedButton(
                child: Text("Second Screen"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            appBar: AppBar(
                          title: Text("Second Screen"),
                        )),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
