import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

class LifecycleWatcher extends StatefulWidget {
  final Widget child;

  const LifecycleWatcher({Key key, this.child}) : super(key: key);

  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      FlutterUploader uploader = FlutterUploader();
      uploader.cancelAll();
      print("App Exited");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
