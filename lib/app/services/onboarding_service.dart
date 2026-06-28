import 'package:get_storage/get_storage.dart';

/// Tracks whether the first-launch onboarding (permission pages) has been seen.
class OnboardingService {
  OnboardingService._();

  static final GetStorage _box = GetStorage();
  static const String _key = 'onboarding_done';

  static bool get isDone => _box.read(_key) == true;

  static void markDone() => _box.write(_key, true);
}
