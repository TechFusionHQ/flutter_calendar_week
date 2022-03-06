import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/utils/compare_date.dart';

bool checkDateOfWeek(WeekItem week, DateTime date) {
  for (DateTime? _date in week.days) {
    if (compareDate(_date, date)) {
      return true;
    }
  }

  return false;
}
