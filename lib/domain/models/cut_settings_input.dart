import '../units/display_unit.dart';
import '../units/length.dart';

/// Project-level settings. Length already enforces nonnegative, exact ticks;
/// unlike stock and parts, all three setting lengths may be zero.
final class CutSettingsInput {
  const CutSettingsInput({
    required this.displayUnit,
    required this.kerf,
    required this.endTrim,
    required this.minReusable,
  });

  final DisplayUnit displayUnit;
  final Length kerf;
  final Length endTrim;
  final Length minReusable;
}
