import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/models/absence_filter_model.dart';

void main() {
  group('AbsenceFilters', () {
    var jan = DateTime(2021, 1, 1);
    var feb = DateTime(2021, 2, 1);
    var rangeA = DateTimeRange(start: jan, end: feb);

    test('equality / props', () {
      var a = AbsenceFilters(type: AbsenceType.vacation, range: rangeA);
      var b = AbsenceFilters(type: AbsenceType.vacation, range: rangeA);

      expect(a, equals(b));
      expect(a.props, [AbsenceType.vacation, rangeA]);
    });

    test('copyWith replaces individual fields', () {
      var base = AbsenceFilters(type: AbsenceType.vacation, range: rangeA);
      var copy = base.copyWith(type: AbsenceType.sickness);

      expect(copy.type, AbsenceType.sickness);
      expect(copy.range, rangeA);
    });

    test('resetType true clears type', () {
      var base = AbsenceFilters(type: AbsenceType.vacation, range: rangeA);
      var cleared = base.copyWith(resetType: true);

      expect(cleared.type, isNull);
      expect(cleared.range, rangeA);
    });

    test('resetRange true clears range', () {
      var base = AbsenceFilters(type: AbsenceType.vacation, range: rangeA);
      var cleared = base.copyWith(resetRange: true);

      expect(cleared.range, isNull);
      expect(cleared.type, AbsenceType.vacation);
    });

    test('copyWith with no params returns identical object', () {
      var base = const AbsenceFilters();
      var same = base.copyWith();

      expect(same, equals(base));
    });
  });
}
