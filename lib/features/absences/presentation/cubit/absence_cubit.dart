import 'package:crewmeister_absence_manager/core/error/failures.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_response.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/usecases/get_absences.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/models/absence_filter_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  AbsenceCubit(this.userCase) : super(AbsenceLoading()) {
    _load();
  }
  final GetAbsences userCase;
  static const _pageSize = 10;
  int _page = 0;

  Future<void> _load({bool reset = true}) async {
    if (reset) {
      emit(AbsenceLoading());
      _page = 0;
    }

    final Either<Failure, AbsenceResponse> res = await userCase.call(
      page: _page,
      size: _pageSize,
    );

    res.fold(
      (f) => emit(AbsenceError(f.message)),
      (resp) {
        if (reset) {
          emit(
            AbsenceLoaded(
              loadedItems: resp.items,
              filteredItems: resp.items,
              total: resp.total,
              hasReachedMax: resp.items.length >= resp.total,
              filters: const AbsenceFilters(),
              isLoading: false,
            ),
          );
        } else {
          final prevItems = state is AbsenceLoaded
              ? (state as AbsenceLoaded).loadedItems
              : <AbsenceDetails>[];
          final filters = state is AbsenceLoaded
              ? (state as AbsenceLoaded).filters
              : const AbsenceFilters();

          final combined = [...prevItems, ...resp.items];
          final filtered =
              combined.where((item) => _applyFilters(item, filters)).toList();

          emit(AbsenceLoaded(
            loadedItems: combined,
            filteredItems: filtered,
            total: resp.total,
            hasReachedMax: combined.length >= resp.total,
            filters: filters,
            isLoading: false
          ));
        }
      },
    );
  }

  bool _applyFilters(AbsenceDetails a, AbsenceFilters f) {
    if (f.type == null && f.range == null) return true;
    final byType = f.type == null || a.type == f.type;
    final byRange = f.range == null ||
        (DateTime.parse(a.startDate)
                .isAfter(f.range!.start.subtract(const Duration(days: 1))) &&
            DateTime.parse(a.startDate)
                .isBefore(f.range!.end.add(const Duration(days: 1))));
    return byType && byRange;
  }

  Future<void> loadNext() async {
    if (state is! AbsenceLoaded || (state as AbsenceLoaded).isLoading) return;
    final loaded = state as AbsenceLoaded;
    if (loaded.hasReachedMax) return;
    _page += 1;
    emit(loaded.copyWith(isLoading: true));
    await _load(reset: false);
  }

  Future<void> applyType(AbsenceType? t) async {
    if (state is! AbsenceLoaded) return;
    final loaded = state as AbsenceLoaded;
    AbsenceFilters filter =
        loaded.filters.copyWith(type: t, resetType: t == null);
    _updateFilteredItems(filter);
  }

  Future<void> applyRange(DateTimeRange? r) async {
    if (state is! AbsenceLoaded) return;
    final loaded = state as AbsenceLoaded;
    AbsenceFilters filter =
        loaded.filters.copyWith(range: r, resetRange: r == null);
    _updateFilteredItems(filter);
  }

  void _updateFilteredItems(AbsenceFilters f) {
    if (state is AbsenceLoaded) {
      final loaded = state as AbsenceLoaded;
      final filtered =
          loaded.loadedItems.where((item) => _applyFilters(item, f)).toList();

      emit(loaded.copyWith(
        filteredItems: filtered,
        filters: f,
      ));
    }
  }

  Future<void> refresh() async {
    await _load(reset: true);
  }
}
