class AnimationConstants {
  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration semaforiAnimation = Duration(milliseconds: 1000);

  // Lottie Animation Paths
  static const String splashAnimation = 'assets/animations/splash.json';
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyStateAnimation =
      'assets/animations/empty_state.json';
  static const String celebrationAnimation =
      'assets/animations/celebration.json';

  // Transition Curves
  static const String defaultCurve = 'easeInOut';
  static const String bounceCurve = 'elasticOut';
  static const String slideInCurve = 'decelerate';

  // Animation Values
  static const double fadeOpacityStart = 0.0;
  static const double fadeOpacityEnd = 1.0;
  static const double scaleStart = 0.8;
  static const double scaleEnd = 1.0;
  static const double slideOffsetStart = 50.0;
  static const double slideOffsetEnd = 0.0;
}
