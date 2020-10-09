import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'model/upload_item.dart';

class UploadManager extends ChangeNotifier {
  FlutterUploader _uploader = FlutterUploader();
  UploadManager() {
    _init();
  }

  Map<String, UploadItem> _tasks = {};

  Map<String, UploadItem> get tasks => _tasks;

  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;

  Future<void> addEnqueue(
    String url,
    String path, {
    fieldName = "file",
  }) async {
    var uuid = Uuid();
    final String filename = basename(path);
    final String savedDir = dirname(path);
    final tag = uuid.v4();
    var fileItem = FileItem(
      filename: filename,
      savedDir: savedDir,
      fieldname: fieldName,
    );

    var taskId = await _uploader.enqueue(
      url: url,
      files: [fileItem],
      method: UploadMethod.POST,
      tag: tag,
      showNotification: true,
    );

    tasks.putIfAbsent(
        tag,
        () => UploadItem(
              id: taskId,
              tag: tag,
              filename: filename,
              status: UploadTaskStatus.enqueued,
            ));
    notifyListeners();
  }

  Future cancelUpload(String id) async {
    await _uploader.cancel(taskId: id);
  }

  void _init() async {
    _progressSubscription = _uploader.progress.listen((progress) {
      final task = _tasks[progress.tag];
      if (task == null) return;
      if (task.isCompleted()) return;

      _tasks[progress.tag] =
          task.copyWith(progress: progress.progress, status: progress.status);
      notifyListeners();
    });
    _resultSubscription = _uploader.result.listen((result) {
      final task = _tasks[result.tag];
      if (task == null) return;

      _tasks[result.tag] = task.copyWith(status: result.status);
      notifyListeners();
    }, onError: (ex, stacktrace) {
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];

      if (task == null) return;

      _tasks[exp.tag] = task.copyWith(status: exp.status);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
    super.dispose();
  }
}
