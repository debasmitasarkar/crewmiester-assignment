import 'package:equatable/equatable.dart';
import 'absence_details.dart';

class AbsenceResponse extends Equatable {
  final int total;
  final List<AbsenceDetails> items;

  const AbsenceResponse({
    required this.total,
    required this.items,
  });

  @override
  List<Object?> get props => [total, items];
}
