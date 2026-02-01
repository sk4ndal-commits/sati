class BudgetEntity {
  final String id;
  final String categoryId;
  final double amount;
  final bool rollover;
  final int month;
  final int year;

  BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.amount,
    this.rollover = false,
    required this.month,
    required this.year,
  });

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    double? amount,
    bool? rollover,
    int? month,
    int? year,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      rollover: rollover ?? this.rollover,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
