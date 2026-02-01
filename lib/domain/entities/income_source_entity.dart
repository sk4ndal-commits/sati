class IncomeSourceEntity {
  final String id;
  final String name;
  final double? expectedAmount;
  final String? cadence; // e.g., 'monthly', 'weekly'

  IncomeSourceEntity({
    required this.id,
    required this.name,
    this.expectedAmount,
    this.cadence,
  });
}
