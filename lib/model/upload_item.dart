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
}
