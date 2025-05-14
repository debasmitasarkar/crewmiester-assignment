import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AbsenceFilters extends Equatable {
  final AbsenceType? type;
  final DateTimeRange? range;
  const AbsenceFilters({this.type, this.range});

  AbsenceFilters copyWith({
    AbsenceType? type,
    DateTimeRange? range,
    bool resetType = false,
    bool resetRange = false,
  }) {
    return AbsenceFilters(
      type: resetType == true ? null : type ?? this.type,
      range: resetRange == true ? null : range ?? this.range,
    );
  }

  @override
  List<Object?> get props => [type, range];
}
