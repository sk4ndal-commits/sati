// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sati';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get note => 'Note (optional)';

  @override
  String get save => 'Save';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get transactionSaved => 'Transaction saved';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryOther => 'Other';

  @override
  String get incomeSources => 'Income Sources';

  @override
  String get addIncomeSource => 'Add Income Source';

  @override
  String get sourceName => 'Source Name';

  @override
  String get expectedAmount => 'Expected Amount';

  @override
  String get cadence => 'Cadence';

  @override
  String get monthly => 'Monthly';

  @override
  String get weekly => 'Weekly';

  @override
  String get noIncomeSources => 'No income sources yet';

  @override
  String get actual => 'Actual';

  @override
  String get expected => 'Expected';

  @override
  String get missing => 'Missing';

  @override
  String get incomeSource => 'Income Source';

  @override
  String get selectSource => 'Select Source';

  @override
  String get budgets => 'Budgets';

  @override
  String get addBudget => 'Add Budget';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get rollover => 'Rollover';

  @override
  String get noBudgets => 'No budgets set yet';

  @override
  String get editBudget => 'Edit Budget';

  @override
  String get budgetAlertTitle => 'Budget Warning';

  @override
  String budgetAlertBody(String category, int percent) {
    return 'You have used $percent% of your $category budget.';
  }
}
