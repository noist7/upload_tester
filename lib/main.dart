import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/home/home_screen.dart';
import 'upload_manager.dart';

import 'life_cycle_watcher.dart';

const String title = "FileUpload Sample app";
const String uploadURL = "http://fe55f29181f6.ngrok.io/upload";

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => UploadManager(), child: App()));
}

class App extends StatefulWidget {
  final Widget child;

  App({Key key, this.child}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return LifecycleWatcher(
        child: MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    ));
  }
}
