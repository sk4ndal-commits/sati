import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/budget_threshold_service.dart';
import '../../application/income_source_controller.dart';
import '../../application/transaction_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../l10n/app_localizations.dart';

class TransactionEntryScreen extends ConsumerStatefulWidget {
  const TransactionEntryScreen({super.key});

  @override
  ConsumerState<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends ConsumerState<TransactionEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String _categoryId = 'food';
  DateTime _date = DateTime.now();
  String? _incomeSourceId;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      final l10n = AppLocalizations.of(context)!;
      
      await ref.read(transactionControllerProvider.notifier).addTransaction(
        amount: amount,
        type: _type,
        categoryId: _categoryId,
        date: _date,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        incomeSourceId: _type == TransactionType.income ? _incomeSourceId : null,
      );

      if (_type == TransactionType.expense) {
        // Use a short delay or await specifically if needed, 
        // but checking thresholds after transaction is added.
        await ref.read(budgetThresholdServiceProvider.notifier).checkThresholds(l10n);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.transactionSaved)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addTransaction),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SegmentedButton<TransactionType>(
              segments: [
                ButtonSegment(value: TransactionType.expense, label: Text(l10n.expense)),
                ButtonSegment(value: TransactionType.income, label: Text(l10n.income)),
              ],
              selected: {_type},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _type = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixIcon: const Icon(Icons.attach_money),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.requiredField;
                }
                if (double.tryParse(value.replaceAll(',', '.')) == null) {
                  return l10n.invalidAmount;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: InputDecoration(
                labelText: l10n.category,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'food', child: Text(l10n.categoryFood)),
                DropdownMenuItem(value: 'transport', child: Text(l10n.categoryTransport)),
                DropdownMenuItem(value: 'leisure', child: Text(l10n.categoryLeisure)),
                DropdownMenuItem(value: 'housing', child: Text(l10n.categoryHousing)),
                DropdownMenuItem(value: 'salary', child: Text(l10n.categorySalary)),
                DropdownMenuItem(value: 'other', child: Text(l10n.categoryOther)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _categoryId = value;
                  });
                }
              },
            ),
            if (_type == TransactionType.income) ...[
              const SizedBox(height: 16),
              ref.watch(incomeSourceControllerProvider).when(
                    data: (sources) => DropdownButtonFormField<String>(
                      initialValue: _incomeSourceId,
                      decoration: InputDecoration(
                        labelText: l10n.incomeSource,
                        border: const OutlineInputBorder(),
                      ),
                      items: sources
                          .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                          .toList(),
                      onChanged: (value) => setState(() => _incomeSourceId = value),
                      validator: (value) => _type == TransactionType.income && value == null
                          ? l10n.requiredField
                          : null,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, stack) => const SizedBox.shrink(),
                  ),
            ],
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.date),
              subtitle: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: l10n.note,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
