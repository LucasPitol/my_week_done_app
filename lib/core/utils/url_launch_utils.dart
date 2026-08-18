import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/profile_constants.dart';

Future<bool> launchExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> requestAppReview() async {
  final review = InAppReview.instance;

  if (await review.isAvailable()) {
    await review.requestReview();
    return;
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    await launchExternalUrl(ProfileConstants.playStoreUrl);
  }
}
