import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../upload_manager.dart';
import 'widgets/upload_item_view.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 20.0),
            Text(
              'multipart/form-data uploads',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => getImage(context),
                  child: Text("upload image"),
                ),
                Container(width: 20.0),
                RaisedButton(
                  onPressed: () => getVideo(context),
                  child: Text("upload video"),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => getDoc(context),
                  child: Text("upload doc"),
                ),
                Container(width: 20.0),
                RaisedButton(
                  onPressed: () => getFile(context),
                  child: Text("upload custom"),
                )
              ],
            ),
            Container(height: 20.0),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(20.0),
                itemCount: Provider.of<UploadManager>(context).tasks.length,
                itemBuilder: (context, index) {
                  final item = Provider.of<UploadManager>(context)
                      .tasks
                      .values
                      .toList()
                      .reversed
                      .elementAt(index);
                  return UploadItemView(
                    item: item,
                    onCancel: Provider.of<UploadManager>(context, listen: false)
                        .cancelUpload,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getDoc(context) async {
    final file = await FilePicker.getFilePath(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (file != null) {
      final model = Provider.of<UploadManager>(context, listen: false);
      model.addEnqueue(uploadURL, file);
    }
  }

  Future getFile(BuildContext context) async {
    final file = await FilePicker.getFilePath();
    if (file != null) {
      final model = Provider.of<UploadManager>(context, listen: false);
      model.addEnqueue(uploadURL, file);
    }
  }

  Future getImage(BuildContext context) async {
    final file = await FilePicker.getFilePath(
      type: FileType.image,
    );
    if (file != null) {
      final model = Provider.of<UploadManager>(context, listen: false);
      model.addEnqueue(uploadURL, file);
    }
  }

  Future getVideo(BuildContext context) async {
    final file = await FilePicker.getFilePath(
      type: FileType.video,
    );
    if (file != null) {
      final model = Provider.of<UploadManager>(context, listen: false);
      model.addEnqueue(uploadURL, file);
    }
  }
}
