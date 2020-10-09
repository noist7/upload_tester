import 'dart:convert';

import 'package:flutter_uploader/flutter_uploader.dart';

enum MediaType { Image, Video, File, Doc }

class UploadItem {
  final String id;
  final String tag;
  final int progress;
  final UploadTaskStatus status;

  UploadItem({
    this.id,
    this.tag,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'progress': progress,
      'status': status.value,
    };
  }

  factory UploadItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UploadItem(
      id: map['id'],
      tag: map['tag'],
      progress: map['progress'],
      status: UploadTaskStatus.from(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadItem.fromJson(String source) =>
      UploadItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UploadItem(id: $id, tag: $tag, progress: $progress, status: $status)';
  }
}
