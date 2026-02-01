enum TransactionType {
  income,
  expense,
}

class TransactionEntity {
  final String id;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String? note;
  final String? incomeSourceId;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.incomeSourceId,
  });
}
