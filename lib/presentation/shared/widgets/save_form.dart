import 'package:flutter/material.dart';

/// Shared validation, retry and repeated-submit protection for persisted forms.
class SaveForm extends StatefulWidget {
  const SaveForm({
    super.key,
    required this.submitLabel,
    required this.errorMessage,
    required this.fields,
    required this.onSubmit,
    this.onSubmitAnother,
    this.submitAnotherLabel,
    this.stayOpenAfterSubmit = false,
    this.submitEnabled = true,
    this.footer,
  });
  final String submitLabel;
  final String errorMessage;
  final List<Widget> Function(bool enabled) fields;
  final Future<void> Function() onSubmit;
  final Future<void> Function()? onSubmitAnother;
  final String? submitAnotherLabel;
  final bool stayOpenAfterSubmit;
  final bool submitEnabled;
  final Widget? footer;

  @override
  State<SaveForm> createState() => _SaveFormState();
}

class _SaveFormState extends State<SaveForm> {
  var _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool _submitted = false;
  bool _failed = false;

  Future<void> _submit({bool another = false}) async {
    if (_saving ||
        _submitted ||
        !widget.submitEnabled ||
        !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await (another ? widget.onSubmitAnother! : widget.onSubmit)();
      if (mounted) {
        setState(() {
          // A fresh form clears validation without restoring old field values.
          if (another) _formKey = GlobalKey<FormState>();
          _submitted = !another && !widget.stayOpenAfterSubmit;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24),
        // Keep every field mounted so validation includes offscreen inputs.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...widget.fields(!_saving && !_submitted),
            const SizedBox(height: 24),
            if (_failed) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  widget.errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: _saving || _submitted || !widget.submitEnabled
                  ? null
                  : _submit,
              child: Text(widget.submitLabel),
            ),
            if (widget.onSubmitAnother != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(64, 48),
                ),
                onPressed: _saving || _submitted || !widget.submitEnabled
                    ? null
                    : () => _submit(another: true),
                child: Text(widget.submitAnotherLabel!),
              ),
            ],
            if (_saving)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (widget.footer != null) widget.footer!,
          ],
        ),
      ),
    ),
  );
}
