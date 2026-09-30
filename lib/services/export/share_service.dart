import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'cut_report_data.dart';
import 'cut_report_text.dart';

/// One platform boundary. Share cancellation/unavailable feedback is normal;
/// only thrown errors reach the UI's localized failure handling.
class ReportShareService {
  ReportShareService({
    Future<ShareResult> Function(ShareParams)? share,
    Future<void> Function(ClipboardData)? copy,
  }) : _share = share ?? SharePlus.instance.share,
       _copy = copy ?? Clipboard.setData;
  final Future<ShareResult> Function(ShareParams) _share;
  final Future<void> Function(ClipboardData) _copy;

  Future<void> shareText(CutReportData report, {Rect? origin}) async {
    await _share(
      ShareParams(
        text: cutReportText(report),
        title: report.project.name,
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> sharePdf(
    CutReportData report,
    Uint8List bytes, {
    Rect? origin,
  }) async {
    await _share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'application/pdf')],
        fileNameOverrides: [report.fileName],
        title: report.project.name,
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> copyBuyList(CutReportData report) {
    final text = report.purchaseLine;
    if (text == null) throw StateError('Fixed inventory has no purchase list');
    return _copy(ClipboardData(text: text));
  }
}
