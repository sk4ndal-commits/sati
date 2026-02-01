class AllocationBudgetEntity {
  final String id;
  final String name;
  final double? targetAmount;
  final double? monthlyAllocation;
  final double totalAllocated;
  final DateTime createdAt;
  final DateTime updatedAt;

  AllocationBudgetEntity({
    required this.id,
    required this.name,
    this.targetAmount,
    this.monthlyAllocation,
    this.totalAllocated = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  AllocationBudgetEntity copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? monthlyAllocation,
    double? totalAllocated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AllocationBudgetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      monthlyAllocation: monthlyAllocation ?? this.monthlyAllocation,
      totalAllocated: totalAllocated ?? this.totalAllocated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get progress {
    if (targetAmount == null || targetAmount == 0) return 0.0;
    return totalAllocated / targetAmount!;
  }
}
