import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/income_source_entity.dart';
import 'providers.dart';

part 'income_source_controller.g.dart';

@riverpod
class IncomeSourceController extends _$IncomeSourceController {
  @override
  FutureOr<List<IncomeSourceEntity>> build() async {
    return ref.watch(incomeSourceRepositoryProvider).getAllIncomeSources();
  }

  Future<void> addIncomeSource({
    required String name,
    double? expectedAmount,
    String? cadence,
  }) async {
    final repository = ref.read(incomeSourceRepositoryProvider);
    final source = IncomeSourceEntity(
      id: const Uuid().v4(),
      name: name,
      expectedAmount: expectedAmount,
      cadence: cadence,
    );
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveIncomeSource(source);
      return repository.getAllIncomeSources();
    });
  }

  Future<void> updateIncomeSource(IncomeSourceEntity source) async {
    final repository = ref.read(incomeSourceRepositoryProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveIncomeSource(source);
      return repository.getAllIncomeSources();
    });
  }

  Future<void> deleteIncomeSource(String id) async {
    final repository = ref.read(incomeSourceRepositoryProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.deleteIncomeSource(id);
      return repository.getAllIncomeSources();
    });
  }
}
