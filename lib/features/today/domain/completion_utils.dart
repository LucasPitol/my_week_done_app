import '../../../domain/entities/daily_completion.dart';

String completionKey(String blockId, DateTime date) {
  return '$blockId-${date.year}-${date.month}-${date.day}';
}

Map<String, DailyCompletion> buildCompletionLookup(
  List<DailyCompletion> completions,
) {
  return {
    for (final completion in completions)
      completionKey(completion.routineBlockId, completion.date): completion,
  };
}
