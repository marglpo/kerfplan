import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_copy_name.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/units/display_unit.dart';

void main() {
  test('metadata trims fields and converts blank optional values to null', () {
    final metadata = ProjectMetadata(
      name: '  Garage frame  ',
      material: ' \n ',
      note: '\t',
    );
    expect(metadata.name, 'Garage frame');
    expect(metadata.material, isNull);
    expect(metadata.note, isNull);
    final supplied = ProjectMetadata(
      name: 'Job',
      material: ' Steel ',
      note: ' Wall ',
    );
    expect(supplied.material, 'Steel');
    expect(supplied.note, 'Wall');
  });

  test('blank project names are rejected', () {
    expect(
      () => ProjectMetadata(name: ' \n '),
      throwsA(
        isA<ProjectValidationException>().having(
          (e) => e.error,
          'error',
          ProjectValidationError.nameRequired,
        ),
      ),
    );
  });

  test('all metadata limits reject rather than truncate', () {
    expect(
      ProjectMetadata(
        name: 'A' * 80,
        material: 'M' * 120,
        note: 'N' * 500,
      ).name.length,
      80,
    );
    expect(
      () => ProjectMetadata(name: 'A' * 81),
      throwsA(isA<ProjectValidationException>()),
    );
    expect(
      () => ProjectMetadata(name: 'Job', material: 'M' * 121),
      throwsA(isA<ProjectValidationException>()),
    );
    expect(
      () => ProjectMetadata(name: 'Job', note: 'N' * 501),
      throwsA(isA<ProjectValidationException>()),
    );
    expect(ProjectMetadata(name: '🔧' * 80).name.runes.length, 80);
  });

  test('enums have explicit stable mappings and reject unknown values', () {
    expect(InventoryMode.values.map((value) => value.storageValue), [
      'fixed',
      'buy',
    ]);
    expect(DisplayUnit.values.map((value) => value.storageValue), [
      'mm',
      'cm',
      'm',
      'inch',
      'ftIn',
    ]);
    for (final value in InventoryMode.values) {
      expect(InventoryMode.fromStorage(value.storageValue), value);
    }
    for (final value in DisplayUnit.values) {
      expect(DisplayUnit.fromStorage(value.storageValue), value);
    }
    expect(() => InventoryMode.fromStorage('unknown'), throwsFormatException);
    expect(() => DisplayUnit.fromStorage('unknown'), throwsFormatException);
  });

  test(
    'generated copy names resolve collisions and visibly shorten long bases',
    () {
      expect(
        projectCopyName('Frame', 'Copy', {'Frame Copy', 'Frame Copy 2'}),
        'Frame Copy 3',
      );
      final name = projectCopyName('A' * 80, 'Copy', {});
      expect(name.runes.length, 80);
      expect(name, endsWith('… Copy'));
      expect(ProjectMetadata.validateName(name), isNull);
      expect(
        ProjectMetadata.validateName(projectCopyName('A' * 80, 'Copy', {name})),
        isNull,
      );
    },
  );
}
