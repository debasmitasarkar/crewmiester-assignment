import 'package:crewmeister_absence_manager/features/absences/domain/entities/absence_details.dart';
import 'package:crewmeister_absence_manager/features/absences/domain/entities/enums.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/note.dart';
import 'package:crewmeister_absence_manager/features/absences/presentation/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


class AbsenceCard extends StatelessWidget {
  const AbsenceCard({
    super.key,
    required this.absence,
  });

  final AbsenceDetails absence;

  (Color colour, IconData icon) _statusMeta() {
    switch (absence.status) {
      case AbsenceStatus.requested:
        return (Colors.orange, Icons.hourglass_bottom_rounded);
      case AbsenceStatus.confirmed:
        return (Colors.green, Icons.check_rounded);
      case AbsenceStatus.rejected:
        return (Colors.red, Icons.close_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (colour, icon) = _statusMeta();
    final df = DateFormat.yMMMEd();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: colour.withAlpha(30),
                child: Text(
                  absence.employeeName.substring(0, 1).toUpperCase(),
                  style: TextStyle(color: colour, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                absence.employeeName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '# ${absence.employeeUserId.toString()}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          Text(
                            'Type: ${absence.type.label}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      StatusPill(
                        label: absence.status.label,
                        colour: colour,
                        icon: icon,
                      ),
                    ],
                  ),
                  Text(
                    '${df.format(DateTime.parse(absence.startDate))} → ${df.format(DateTime.parse(absence.endDate))}',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (absence.memberNote?.trim().isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Note(
                            label: 'Member note',
                            text: absence.memberNote!,
                          ),
                        ),
                      if (absence.admitterNote?.trim().isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Note(
                            label: 'Admitter note',
                            text: absence.admitterNote!,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AbsenceCardShimmer extends StatelessWidget {
  const AbsenceCardShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
