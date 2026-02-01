// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'moneyful';

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

  @override
  String get settings => 'Settings';

  @override
  String get intentPrompt => 'Intent Prompt';

  @override
  String get intentPromptDescription =>
      'Ask for reflection on expenses above a threshold';

  @override
  String get threshold => 'Threshold';

  @override
  String get wasPlanned => 'Was this planned?';

  @override
  String get howDoYouFeel => 'How do you feel?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get feeling1 => 'Awful';

  @override
  String get feeling2 => 'Bad';

  @override
  String get feeling3 => 'Neutral';

  @override
  String get feeling4 => 'Good';

  @override
  String get feeling5 => 'Great';

  @override
  String get reflection => 'Reflection';

  @override
  String get weeklyReview => 'Weekly Review';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get unplannedSpend => 'Unplanned Spend';

  @override
  String get suggestions => 'Suggestion';

  @override
  String get suggestionGeneric =>
      'Keep tracking your expenses to get better insights.';

  @override
  String get suggestionHighUnplanned =>
      'Your unplanned spending is quite high this week. Try to plan more expenses in advance.';

  @override
  String suggestionReduceTop(String category) {
    return 'You spent the most on $category. Can you find a way to reduce this next week?';
  }

  @override
  String get weeklyReviewDescription => 'Your financial week at a glance.';

  @override
  String get feelingDistribution => 'Feeling Distribution';

  @override
  String get avgFeelingNegative =>
      'Unplanned expenses felt rather negative on average.';

  @override
  String get avgFeelingNeutral => 'Unplanned expenses felt neutral on average.';

  @override
  String get avgFeelingPositive =>
      'Unplanned expenses felt positive on average.';

  @override
  String get noUnplannedData => 'No unplanned expenses to reflect on.';

  @override
  String get frequentlyUnplanned => 'frequently unplanned';

  @override
  String percentUnplanned(int percent) {
    return '$percent% unplanned';
  }

  @override
  String get remainingTotalBudget => 'Remaining total budget';

  @override
  String get moneyLeft => 'Money left';

  @override
  String get viewAllBudgets => 'View all budgets';

  @override
  String get forThisMonth => 'for this month';

  @override
  String get today => 'Today';

  @override
  String get noTransactionsToday => 'No transactions today';

  @override
  String get planned => 'Planned';

  @override
  String get unplanned => 'Unplanned';

  @override
  String highUnplannedWeekly(String amount) {
    return 'High unplanned spending this week: $amount €';
  }

  @override
  String budgetNearLimitSignal(String category) {
    return '$category budget is almost exhausted';
  }

  @override
  String remainingBudgetInfo(String amount) {
    return '$amount remaining this month';
  }

  @override
  String get monthlyOverview => 'Monthly Overview';

  @override
  String get incomeVsExpenses => 'Income vs Expenses';

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get savings => 'Savings';

  @override
  String get budgetStatus => 'Budget Status';

  @override
  String get totalBudgeted => 'Total Budgeted';

  @override
  String ofTotal(Object percent) {
    return '$percent% of total';
  }

  @override
  String get dataAndBackup => 'Data & Backup';

  @override
  String get exportCsv => 'Export to CSV';

  @override
  String get exportJson => 'Export to JSON';

  @override
  String get exportDescription =>
      'Export all your transactions, budgets, and income sources to a human-readable format. You keep full control over your data.';

  @override
  String get adjustBudget => 'Adjust budget';

  @override
  String get nothingToChange => 'Nothing to change this week';

  @override
  String get newMonthGreeting => 'New month, fresh start.';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get dataAndExport => 'Data & Export';

  @override
  String get reflect => 'Reflect';

  @override
  String get trends => 'Trends';

  @override
  String get trendsDescription => 'Your spending patterns over time.';

  @override
  String get home => 'Home';

  @override
  String get spendingTrend => 'Spending Trend';

  @override
  String get spendingTrendDescription =>
      'Monthly total expenses for the last few months.';

  @override
  String get categoryTrend => 'Category Trend';

  @override
  String get categoryTrendDescription =>
      'Spending distribution by category over time.';

  @override
  String get noTrendData => 'Not enough data for trends yet.';

  @override
  String get plannedVsUnplanned => 'Planned vs Unplanned';

  @override
  String get plannedVsUnplannedDescription =>
      'Weekly spending by intent (planned vs unplanned).';

  @override
  String get weeks => 'Weeks';

  @override
  String get incomeVsExpensesTrend => 'Income vs. Expenses Trend';

  @override
  String get incomeVsExpensesTrendDescription =>
      'Comparison of your monthly income and expenses.';

  @override
  String get incomeTrend => 'Income Trend';

  @override
  String get incomeTrendDescription =>
      'Monthly total income for the last few months.';
}
