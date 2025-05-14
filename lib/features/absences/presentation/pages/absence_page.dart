import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/cubit/absence_cubit.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/models/absence_filter_model.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/absence_card.dart';
import 'package:intl/intl.dart';

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({super.key});
  @override
  State<AbsencesPage> createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  late final AbsenceCubit _cubit = context.read<AbsenceCubit>();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 100) {
        _cubit.loadNext();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _cubit.refresh(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Absences')),
        body: BlocBuilder<AbsenceCubit, AbsenceState>(
          bloc: _cubit,
          builder: (context, state) {
            return switch (state) {
              AbsenceLoading() =>  _ShimmerList(),
              AbsenceError(:final message) => Center(child: Text(message)),
              AbsenceLoaded() => _LoadedList(state, _controller, _cubit),
            };
          },
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => const AbsenceCardShimmer(),
    );
  }
}

class _LoadedList extends StatelessWidget {
  const _LoadedList(this.loaded, this.controller, this.cubit);
  final AbsenceLoaded loaded;
  final ScrollController controller;
  final AbsenceCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FiltersBar(
          filters: loaded.filters,
          onType: cubit.applyType,
          onRange: cubit.applyRange,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('Total absences: ', style: TextStyle(fontSize: 16)),
              Text(
                '${loaded.total}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        if (loaded.filteredItems.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No absences found'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              addAutomaticKeepAlives: true,
              controller: controller,
              itemCount: loaded.hasReachedMax
                  ? loaded.filteredItems.length
                  : loaded.filteredItems.length + 1,
              itemBuilder: (context, i) {
                if (i >= loaded.filteredItems.length) {
                  if (loaded.isLoading) {
                    return const AbsenceCardShimmer();
                  }

                  return const SizedBox.shrink();
                }
                final item = loaded.filteredItems[i];
                return AbsenceCard(
                  absence: item,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.filters,
    required this.onType,
    required this.onRange,
  });
  final AbsenceFilters filters;
  final ValueChanged<AbsenceType?> onType;
  final ValueChanged<DateTimeRange?> onRange;

  String _rangeLabel() {
    if (filters.range == null) return 'Any date';
    final df = DateFormat('dd MMM');
    return '${df.format(filters.range!.start)} – ${df.format(filters.range!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 1,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Absence Type'),
                DropdownButtonHideUnderline(
                  child: DropdownButton<AbsenceType?>(
                    value: filters.type,
                    icon: const Icon(Icons.arrow_drop_down),
                    hint: const Text('Absence Type'),
                    borderRadius: BorderRadius.circular(12),
                    onChanged: onType,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...AbsenceType.values.map((t) =>
                          DropdownMenuItem(value: t, child: Text(t.label))),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Absence Date'),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _rangeLabel(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDateRangePicker(
                      currentDate: now,
                      barrierColor: Colors.black54,
                      context: context,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 5),
                      initialDateRange: filters.range,
                    );
                    onRange(picked);
                  },
                ),
              ],
            ),
            if (filters.range != null)
              IconButton(
                splashRadius: 10,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.clear, size: 18),
                tooltip: 'Clear date filter',
                onPressed: () => onRange(null),
              ),
          ],
        ),
      ),
    );
  }
}
