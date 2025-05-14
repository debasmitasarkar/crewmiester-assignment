import 'package:absence_api/src/models/absence_details_data.dart';

class AbsenceResponseData {
  final int total;
  final List<AbsenceDetailsData> items;

  const AbsenceResponseData({required this.total, required this.items});
}