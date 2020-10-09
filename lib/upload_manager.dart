import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'model/upload_item.dart';

// const _Upload_Key = "upload_file";

class UploadManager extends ChangeNotifier {
  // Completer<SharedPreferences> _sharedPreferencesCompleter;

  // Future<SharedPreferences> get _sharedPreferences {
  //   if (_sharedPreferencesCompleter == null) {
  //     _sharedPreferencesCompleter = Completer<SharedPreferences>();
  //     SharedPreferences.getInstance()
  //         .then((s) => _sharedPreferencesCompleter.complete(s));
  //   }
  //   return _sharedPreferencesCompleter.future;
  // }

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

    print("AddFileEvent:  $tag, $filename,");

    tasks.putIfAbsent(
        tag,
        () => UploadItem(
              id: taskId,
              tag: tag,
              filename: filename,
              status: UploadTaskStatus.enqueued,
            ));
    // final taskStr = tasks.values.map((e) => e.toJson()).toList();
    // _sharedPreferences.then((s) => s.setStringList(_Upload_Key, taskStr));
    notifyListeners();
  }

  Future cancelUpload(String id) async {
    await _uploader.cancel(taskId: id);
  }

  void _init() async {
    // final isExists = (await _sharedPreferences).containsKey(_Upload_Key);

    // if (isExists) {
    //   final taskStr = (await _sharedPreferences).getStringList(_Upload_Key);

    //   final taskList = taskStr.map((e) => UploadItem.fromJson(e)).toList();

    //   _tasks.addEntries(taskList.map((e) => MapEntry(e.tag, e)));
    //   notifyListeners();
    // }

    _progressSubscription = _uploader.progress.listen((progress) {
      final task = _tasks[progress.tag];
      print("TaskListener: Tasks: $tasks");
      print("TaskListener: Task: $task, ${progress.tag}");
      print(
          "TaskListener: progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      _tasks[progress.tag] =
          task.copyWith(progress: progress.progress, status: progress.status);
      notifyListeners();
    });
    _resultSubscription = _uploader.result.listen((result) {
      print("TaskOnResult: $result");
      // print(
      //     "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = _tasks[result.tag];
      if (task == null) return;

      _tasks[result.tag] = task.copyWith(status: result.status);
      // final taskStr = tasks.values.map((e) => e.toJson()).toList();
      // _sharedPreferences.then((s) => s.setStringList(_Upload_Key, taskStr));
      notifyListeners();
    }, onError: (ex, stacktrace) {
      // print("exception: $ex");
      // print("stacktrace: $stacktrace" ?? "no stacktrace");
      print("TaskOnError: $ex");
      print("TaskOnError: $stacktrace");
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];
      // _uploader.cancel(taskId: exp.taskId);
      if (task == null) return;

      _tasks[exp.tag] = task.copyWith(status: exp.status);
      // final taskStr = tasks.values.map((e) => e.toJson()).toList();
      // _sharedPreferences.then((s) => s.setStringList(_Upload_Key, taskStr));
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
