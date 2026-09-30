import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/export_providers.dart';
import '../../app/optimization_coordinator.dart';
import '../../domain/models/inventory_mode.dart';
import '../../l10n/app_localizations.dart';
import '../../services/export/cut_report_builder.dart';

enum _ReportAction { text, pdf, copy }

class ShareReportAction extends ConsumerStatefulWidget {
  const ShareReportAction({super.key, required this.calculation});
  final CalculatedProject calculation;
  @override
  ConsumerState<ShareReportAction> createState() => _ShareReportActionState();
}

class _ShareReportActionState extends ConsumerState<ShareReportAction> {
  bool _busy = false;
  bool _creatingPdf = false;

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _open() async {
    if (_busy) return;
    final labels = AppLocalizations.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    setState(() => _busy = true);
    try {
      final action = await showModalBottomSheet<_ReportAction>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labels.shareCutPlan,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.notes),
                title: Text(labels.shareText),
                minVerticalPadding: 16,
                onTap: () => Navigator.pop(context, _ReportAction.text),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(labels.sharePdf),
                minVerticalPadding: 16,
                onTap: () => Navigator.pop(context, _ReportAction.pdf),
              ),
              if (widget.calculation.project.inventoryMode == InventoryMode.buy)
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: Text(labels.copyBuyList),
                  minVerticalPadding: 16,
                  onTap: () => Navigator.pop(context, _ReportAction.copy),
                ),
            ],
          ),
        ),
      );
      if (action == null || !mounted) return;
      // Freeze the current result once for this export. No database writes or
      // separate optimization run can make text and PDF disagree mid-export.
      final report = CutReportBuilder.build(
        project: widget.calculation.project,
        result: widget.calculation.result,
        generatedAt: DateTime.now(),
        labels: labels,
      );
      final service = ref.read(reportShareServiceProvider);
      if (action == _ReportAction.pdf) {
        setState(() => _creatingPdf = true);
        final buildPdf = ref.read(reportPdfBuilderProvider);
        // Generation and platform errors have distinct user-facing messages.
        try {
          final bytes = await buildPdf(report);
          if (!mounted) return;
          setState(() => _creatingPdf = false);
          try {
            await service.sharePdf(report, bytes, origin: origin);
          } catch (_) {
            _message(labels.shareError);
          }
        } catch (_) {
          _message(labels.pdfCreateError);
        }
      } else if (action == _ReportAction.text) {
        try {
          await service.shareText(report, origin: origin);
        } catch (_) {
          _message(labels.shareError);
        }
      } else {
        try {
          await service.copyBuyList(report);
          _message(labels.buyListCopied);
        } catch (_) {
          _message(labels.buyListCopyError);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _creatingPdf = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return TextButton.icon(
      onPressed: _busy ? null : _open,
      icon: _creatingPdf
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.share_outlined),
      label: Text(_creatingPdf ? labels.creatingPdf : labels.share),
    );
  }
}
