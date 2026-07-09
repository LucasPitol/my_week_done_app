import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/routine_block.dart';

List<RoutineBlock> blocksInGroup(
  List<RoutineBlock> allBlocks,
  RoutineBlock block,
) {
  final groupId = block.groupId;
  if (groupId == null) return [block];

  return allBlocks.where((b) => b.groupId == groupId).toList()
    ..sort((a, b) => a.weekday.compareTo(b.weekday));
}

Set<int> weekdaysInGroup(List<RoutineBlock> groupBlocks) {
  return groupBlocks.map((b) => b.weekday).toSet();
}

bool hasGroupChanges({
  required RoutineBlock block,
  required List<RoutineBlock> groupBlocks,
  required String title,
  required DateTime startTime,
  required Set<int> weekdays,
  required String? category,
}) {
  final originalWeekdays = weekdaysInGroup(groupBlocks);
  if (weekdays.length != originalWeekdays.length ||
      !weekdays.containsAll(originalWeekdays)) {
    return true;
  }

  final reference = groupBlocks.first;
  if (reference.title != title.trim()) return true;
  if (reference.category != category) return true;

  final refMinutes =
      reference.startTime.hour * 60 + reference.startTime.minute;
  final newMinutes = startTime.hour * 60 + startTime.minute;
  return refMinutes != newMinutes;
}

String formatOtherWeekdaysLabel(
  Set<int> weekdays, {
  required int excludeWeekday,
}) {
  final others = weekdays.where((day) => day != excludeWeekday).toList()
    ..sort();
  if (others.isEmpty) return '';

  return others.map((day) => weekdayFullLabels[day]!).join(', ');
}

int resolveWeekdayForSingleEdit({
  required Set<int> selectedWeekdays,
  required int originalWeekday,
}) {
  if (selectedWeekdays.length == 1) return selectedWeekdays.first;
  if (selectedWeekdays.contains(originalWeekday)) return originalWeekday;
  return originalWeekday;
}
