import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/transaction_entity.dart';
import 'providers.dart';

part 'transaction_controller.g.dart';

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<List<TransactionEntity>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactions();
  }

  Future<void> addTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
    String? incomeSourceId,
    String? allocationBudgetId,
    bool? planned,
    int? feeling,
  }) async {
    state = const AsyncValue.loading();
    
    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
      incomeSourceId: incomeSourceId,
      allocationBudgetId: allocationBudgetId,
      planned: planned,
      feeling: feeling,
    );

    final repository = ref.read(transactionRepositoryProvider);
    
    state = await AsyncValue.guard(() async {
      await repository.addTransaction(transaction);
      return repository.getTransactions();
    });
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(transactionRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.deleteTransaction(id);
      return repository.getTransactions();
    });
  }
}
