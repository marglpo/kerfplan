import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/export/cut_report_data.dart';
import '../services/export/cut_report_pdf.dart';
import '../services/export/share_service.dart';

final reportShareServiceProvider = Provider<ReportShareService>(
  (ref) => ReportShareService(),
);
final reportPdfBuilderProvider =
    Provider<Future<Uint8List> Function(CutReportData)>(
      (ref) => CutReportPdf().build,
    );
