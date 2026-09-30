import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/services/export/share_service.dart';
import 'package:kerfplan/services/export/cut_report_text.dart';

import '../domain/optimizer/optimizer_test_support.dart';
import '../support/report_fixture.dart';

void main() async {
  await initializeDateFormatting('en');
  test('Share text passes the current formatted snapshot', () async {
    final report = reportFor(fixed([stock(1000)], [part(400, quantity: 2)]));
    ShareParams? sent;
    final service = ReportShareService(
      share: (params) async {
        sent = params;
        return const ShareResult('', ShareResultStatus.success);
      },
    );
    await service.shareText(report);
    expect(sent!.text, cutReportText(report));
    expect(sent!.files, isNull);
  });
  test(
    'PDF uses memory bytes, MIME type and guaranteed filename override',
    () async {
      final report = reportFor(fixed([stock(1000)], [part(400)]));
      final bytes = Uint8List.fromList([37, 80, 68, 70]);
      ShareParams? sent;
      final service = ReportShareService(
        share: (params) async {
          sent = params;
          return const ShareResult('', ShareResultStatus.success);
        },
      );
      await service.sharePdf(report, bytes);
      expect(sent!.files!.single.mimeType, 'application/pdf');
      expect(await sent!.files!.single.readAsBytes(), bytes);
      expect(sent!.fileNameOverrides, ['KerfPlan_Garage_Frame_2026-09-26.pdf']);
    },
  );
  for (final status in [
    ShareResultStatus.dismissed,
    ShareResultStatus.unavailable,
  ]) {
    test('$status is normal completion', () async {
      final service = ReportShareService(
        share: (_) async => ShareResult('', status),
      );
      await service.shareText(reportFor(fixed([stock(1000)], [part(400)])));
    });
  }
  test(
    'platform exception remains catchable at the localized UI boundary',
    () async {
      final service = ReportShareService(
        share: (_) async => throw PlatformException(code: 'test'),
      );
      await expectLater(
        service.shareText(reportFor(fixed([stock(1000)], [part(400)]))),
        throwsA(isA<PlatformException>()),
      );
    },
  );
  for (final unit in [DisplayUnit.mm, DisplayUnit.ftIn]) {
    test('clipboard uses only the concise Buy line in $unit', () async {
      final report = reportFor(
        buy(6000, [part(1800, quantity: 10)]),
        unit: unit,
      );
      ClipboardData? copied;
      final service = ReportShareService(
        copy: (data) async {
          copied = data;
        },
      );
      await service.copyBuyList(report);
      expect(copied!.text, report.purchaseLine);
      if (unit == DisplayUnit.mm) expect(copied!.text, '6000 mm \u00d7 4');
      if (unit == DisplayUnit.ftIn) {
        expect(copied!.text, contains("19' 8-1/4\""));
      }
    });
  }
}
