import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'providers.dart';

part 'export_service.g.dart';

@riverpod
class ExportService extends _$ExportService {
  @override
  void build() {}

  Future<void> exportToCsv() async {
    debugPrint('[DEBUG_LOG] Starting CSV export');
    final transactionRepo = ref.read(transactionRepositoryProvider);
    final incomeSourceRepo = ref.read(incomeSourceRepositoryProvider);
    final budgetRepo = ref.read(budgetRepositoryProvider);

    final transactions = await transactionRepo.getTransactions();
    final incomeSources = await incomeSourceRepo.getAllIncomeSources();
    final budgets = await budgetRepo.getAllBudgets();

    debugPrint('[DEBUG_LOG] Data retrieved: ${transactions.length} transactions, ${incomeSources.length} sources, ${budgets.length} budgets');

    if (!ref.mounted) {
      debugPrint('[DEBUG_LOG] Provider unmounted, aborting export');
      return;
    }

    final StringBuffer csv = StringBuffer();
    
    // Transactions
    csv.writeln('--- TRANSACTIONS ---');
    csv.writeln('ID,Amount,Type,Category,Date,Note,IncomeSourceID,Planned,Feeling');
    for (final t in transactions) {
      csv.writeln(
        '${t.id},${t.amount},${t.type.name},${t.categoryId},${DateFormat('yyyy-MM-dd HH:mm:ss').format(t.date)},"${t.note ?? ''}",${t.incomeSourceId ?? ''},${t.planned ?? ''},${t.feeling ?? ''}',
      );
    }
    csv.writeln();

    // Income Sources
    csv.writeln('--- INCOME SOURCES ---');
    csv.writeln('ID,Name,ExpectedAmount,Cadence');
    for (final s in incomeSources) {
      csv.writeln('${s.id},"${s.name}",${s.expectedAmount ?? ''},${s.cadence ?? ''}');
    }
    csv.writeln();

    // Budgets
    csv.writeln('--- BUDGETS ---');
    csv.writeln('ID,CategoryID,Amount,Rollover,Month,Year');
    for (final b in budgets) {
      csv.writeln('${b.id},${b.categoryId},${b.amount},${b.rollover},${b.month},${b.year}');
    }

    await _shareFile(csv.toString(), 'moneyful_export.csv');
  }

  Future<void> exportToJson() async {
    debugPrint('[DEBUG_LOG] Starting JSON export');
    final transactionRepo = ref.read(transactionRepositoryProvider);
    final incomeSourceRepo = ref.read(incomeSourceRepositoryProvider);
    final budgetRepo = ref.read(budgetRepositoryProvider);

    final transactions = await transactionRepo.getTransactions();
    final incomeSources = await incomeSourceRepo.getAllIncomeSources();
    final budgets = await budgetRepo.getAllBudgets();

    debugPrint('[DEBUG_LOG] Data retrieved: ${transactions.length} transactions, ${incomeSources.length} sources, ${budgets.length} budgets');

    if (!ref.mounted) {
      debugPrint('[DEBUG_LOG] Provider unmounted, aborting export');
      return;
    }

    final Map<String, dynamic> data = {
      'transactions': transactions.map((t) => {
        'id': t.id,
        'amount': t.amount,
        'type': t.type.name,
        'categoryId': t.categoryId,
        'date': t.date.toIso8601String(),
        'note': t.note,
        'incomeSourceId': t.incomeSourceId,
        'planned': t.planned,
        'feeling': t.feeling,
      }).toList(),
      'incomeSources': incomeSources.map((s) => {
        'id': s.id,
        'name': s.name,
        'expectedAmount': s.expectedAmount,
        'cadence': s.cadence,
      }).toList(),
      'budgets': budgets.map((b) => {
        'id': b.id,
        'categoryId': b.categoryId,
        'amount': b.amount,
        'rollover': b.rollover,
        'month': b.month,
        'year': b.year,
      }).toList(),
    };

    final String jsonString = const JsonEncoder.withIndent('  ').convert(data);
    await _shareFile(jsonString, 'moneyful_export.json');
  }

  Future<void> _shareFile(String content, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);
      debugPrint('[DEBUG_LOG] File written to: ${file.path}');

      final result = await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: 'moneyful Data Export'));
      debugPrint('[DEBUG_LOG] Share result status: ${result.status}');
    } catch (e, stack) {
      debugPrint('[DEBUG_LOG] Export failed: $e');
      debugPrint('[DEBUG_LOG] $stack');
    }
  }
}
