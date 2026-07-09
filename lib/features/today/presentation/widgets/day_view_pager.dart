import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/day_index.dart';
import '../../providers/today_view_providers.dart';
import 'day_page.dart';

class DayViewPager extends ConsumerStatefulWidget {
  const DayViewPager({
    super.key,
    required this.today,
  });

  final DateTime today;

  @override
  ConsumerState<DayViewPager> createState() => _DayViewPagerState();
}

class _DayViewPagerState extends ConsumerState<DayViewPager> {
  late final PageController _pageController;
  bool _isPageChanging = false;

  @override
  void initState() {
    super.initState();
    final selectedDay = ref.read(selectedDayProvider);
    _pageController = PageController(initialPage: dayToIndex(selectedDay));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DayViewPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPageToSelectedDay();
  }

  void _syncPageToSelectedDay() {
    if (_isPageChanging || !_pageController.hasClients) return;

    final selectedDay = ref.read(selectedDayProvider);
    final targetPage = dayToIndex(selectedDay);
    final currentPage = _pageController.page?.round() ?? targetPage;

    if (currentPage != targetPage) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onPageChanged(int index) {
    _isPageChanging = true;
    ref.read(selectedDayProvider.notifier).state = indexToDay(index);
    _isPageChanging = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DateTime>(selectedDayProvider, (previous, next) {
      if (previous == null || isSameCalendarDay(previous, next)) return;
      _syncPageToSelectedDay();
    });

    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final date = indexToDay(index);
        return DayPage(
          key: ValueKey('day-${date.year}-${date.month}-${date.day}'),
          date: date,
          today: widget.today,
        );
      },
    );
  }
}

bool isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
