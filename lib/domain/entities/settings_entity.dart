class SettingsEntity {
  final bool intentPromptEnabled;
  final double intentPromptThreshold;
  final int? lastSeenMonth;
  final int? lastSeenYear;
  final bool hasSeenOnboarding;

  SettingsEntity({
    required this.intentPromptEnabled,
    required this.intentPromptThreshold,
    this.lastSeenMonth,
    this.lastSeenYear,
    this.hasSeenOnboarding = false,
  });

  SettingsEntity copyWith({
    bool? intentPromptEnabled,
    double? intentPromptThreshold,
    int? lastSeenMonth,
    int? lastSeenYear,
    bool? hasSeenOnboarding,
  }) {
    return SettingsEntity(
      intentPromptEnabled: intentPromptEnabled ?? this.intentPromptEnabled,
      intentPromptThreshold: intentPromptThreshold ?? this.intentPromptThreshold,
      lastSeenMonth: lastSeenMonth ?? this.lastSeenMonth,
      lastSeenYear: lastSeenYear ?? this.lastSeenYear,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}
