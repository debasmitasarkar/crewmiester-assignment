part of 'absence_cubit.dart';

sealed class AbsenceState extends Equatable {
  const AbsenceState();
  @override
  List<Object?> get props => [];
}

class AbsenceLoading extends AbsenceState {}

class AbsenceError extends AbsenceState {
  final String message;
  const AbsenceError(this.message);
  @override
  List<Object?> get props => [message];
}

class AbsenceLoaded extends AbsenceState {
  final List<AbsenceDetails> loadedItems;
  final List<AbsenceDetails> filteredItems;
  final int total;
  final bool isLoading;
  final bool hasReachedMax;
  final AbsenceFilters filters;
  const AbsenceLoaded({
    required this.loadedItems,
    required this.isLoading,
    this.filteredItems = const [],
    required this.total,
    required this.hasReachedMax,
    required this.filters,
  });
  AbsenceLoaded copyWith({
    List<AbsenceDetails>? loadedItems,
    List<AbsenceDetails>? filteredItems,
    int? total,
    bool? hasReachedMax,
    AbsenceFilters? filters,
    bool isLoading = false,
  }) =>
      AbsenceLoaded(
        filteredItems: filteredItems ?? this.filteredItems,
        loadedItems: loadedItems ?? this.loadedItems,
        total: total ?? this.total,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        filters: filters ?? this.filters,
        isLoading: isLoading,
      );
  @override
  List<Object?> get props =>
      [loadedItems, filteredItems, total, hasReachedMax, filters, isLoading];
}
