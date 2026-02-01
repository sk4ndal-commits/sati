import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'moneyful'**
  String get appTitle;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get note;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionSaved;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryLeisure.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get categoryLeisure;

  /// No description provided for @categoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHousing;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @incomeSources.
  ///
  /// In en, this message translates to:
  /// **'Income Sources'**
  String get incomeSources;

  /// No description provided for @addIncomeSource.
  ///
  /// In en, this message translates to:
  /// **'Add Income Source'**
  String get addIncomeSource;

  /// No description provided for @sourceName.
  ///
  /// In en, this message translates to:
  /// **'Source Name'**
  String get sourceName;

  /// No description provided for @expectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Expected Amount'**
  String get expectedAmount;

  /// No description provided for @cadence.
  ///
  /// In en, this message translates to:
  /// **'Cadence'**
  String get cadence;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @noIncomeSources.
  ///
  /// In en, this message translates to:
  /// **'No income sources yet'**
  String get noIncomeSources;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// No description provided for @expected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// No description provided for @incomeSource.
  ///
  /// In en, this message translates to:
  /// **'Income Source'**
  String get incomeSource;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get selectSource;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @rollover.
  ///
  /// In en, this message translates to:
  /// **'Rollover'**
  String get rollover;

  /// No description provided for @noBudgets.
  ///
  /// In en, this message translates to:
  /// **'No budgets set yet'**
  String get noBudgets;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// No description provided for @budgetAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Warning'**
  String get budgetAlertTitle;

  /// No description provided for @budgetAlertBody.
  ///
  /// In en, this message translates to:
  /// **'You have used {percent}% of your {category} budget.'**
  String budgetAlertBody(String category, int percent);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @intentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Intent Prompt'**
  String get intentPrompt;

  /// No description provided for @intentPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask for reflection on expenses above a threshold'**
  String get intentPromptDescription;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// No description provided for @wasPlanned.
  ///
  /// In en, this message translates to:
  /// **'Was this planned?'**
  String get wasPlanned;

  /// No description provided for @howDoYouFeel.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get howDoYouFeel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @feeling1.
  ///
  /// In en, this message translates to:
  /// **'Awful'**
  String get feeling1;

  /// No description provided for @feeling2.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get feeling2;

  /// No description provided for @feeling3.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get feeling3;

  /// No description provided for @feeling4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get feeling4;

  /// No description provided for @feeling5.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get feeling5;

  /// No description provided for @reflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get reflection;

  /// No description provided for @weeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Review'**
  String get weeklyReview;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @unplannedSpend.
  ///
  /// In en, this message translates to:
  /// **'Unplanned Spend'**
  String get unplannedSpend;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestions;

  /// No description provided for @suggestionGeneric.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking your expenses to get better insights.'**
  String get suggestionGeneric;

  /// No description provided for @suggestionHighUnplanned.
  ///
  /// In en, this message translates to:
  /// **'Your unplanned spending is quite high this week. Try to plan more expenses in advance.'**
  String get suggestionHighUnplanned;

  /// No description provided for @suggestionReduceTop.
  ///
  /// In en, this message translates to:
  /// **'You spent the most on {category}. Can you find a way to reduce this next week?'**
  String suggestionReduceTop(String category);

  /// No description provided for @weeklyReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Your financial week at a glance.'**
  String get weeklyReviewDescription;

  /// No description provided for @feelingDistribution.
  ///
  /// In en, this message translates to:
  /// **'Feeling Distribution'**
  String get feelingDistribution;

  /// No description provided for @avgFeelingNegative.
  ///
  /// In en, this message translates to:
  /// **'Unplanned expenses felt rather negative on average.'**
  String get avgFeelingNegative;

  /// No description provided for @avgFeelingNeutral.
  ///
  /// In en, this message translates to:
  /// **'Unplanned expenses felt neutral on average.'**
  String get avgFeelingNeutral;

  /// No description provided for @avgFeelingPositive.
  ///
  /// In en, this message translates to:
  /// **'Unplanned expenses felt positive on average.'**
  String get avgFeelingPositive;

  /// No description provided for @noUnplannedData.
  ///
  /// In en, this message translates to:
  /// **'No unplanned expenses to reflect on.'**
  String get noUnplannedData;

  /// No description provided for @frequentlyUnplanned.
  ///
  /// In en, this message translates to:
  /// **'frequently unplanned'**
  String get frequentlyUnplanned;

  /// No description provided for @percentUnplanned.
  ///
  /// In en, this message translates to:
  /// **'{percent}% unplanned'**
  String percentUnplanned(int percent);

  /// No description provided for @remainingTotalBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining total budget'**
  String get remainingTotalBudget;

  /// No description provided for @moneyLeft.
  ///
  /// In en, this message translates to:
  /// **'Money left'**
  String get moneyLeft;

  /// No description provided for @viewAllBudgets.
  ///
  /// In en, this message translates to:
  /// **'View all budgets'**
  String get viewAllBudgets;

  /// No description provided for @forThisMonth.
  ///
  /// In en, this message translates to:
  /// **'for this month'**
  String get forThisMonth;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @noTransactionsToday.
  ///
  /// In en, this message translates to:
  /// **'No transactions today'**
  String get noTransactionsToday;

  /// No description provided for @planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get planned;

  /// No description provided for @unplanned.
  ///
  /// In en, this message translates to:
  /// **'Unplanned'**
  String get unplanned;

  /// No description provided for @highUnplannedWeekly.
  ///
  /// In en, this message translates to:
  /// **'High unplanned spending this week: {amount} €'**
  String highUnplannedWeekly(String amount);

  /// No description provided for @budgetNearLimitSignal.
  ///
  /// In en, this message translates to:
  /// **'{category} budget is almost exhausted'**
  String budgetNearLimitSignal(String category);

  /// No description provided for @remainingBudgetInfo.
  ///
  /// In en, this message translates to:
  /// **'{amount} remaining this month'**
  String remainingBudgetInfo(String amount);

  /// No description provided for @monthlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly Overview'**
  String get monthlyOverview;

  /// No description provided for @incomeVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expenses'**
  String get incomeVsExpenses;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @budgetStatus.
  ///
  /// In en, this message translates to:
  /// **'Budget Status'**
  String get budgetStatus;

  /// No description provided for @totalBudgeted.
  ///
  /// In en, this message translates to:
  /// **'Total Budgeted'**
  String get totalBudgeted;

  /// No description provided for @ofTotal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of total'**
  String ofTotal(Object percent);

  /// No description provided for @dataAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Data & Backup'**
  String get dataAndBackup;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV'**
  String get exportCsv;

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'Export to JSON'**
  String get exportJson;

  /// No description provided for @exportDescription.
  ///
  /// In en, this message translates to:
  /// **'Export all your transactions, budgets, and income sources to a human-readable format. You keep full control over your data.'**
  String get exportDescription;

  /// No description provided for @adjustBudget.
  ///
  /// In en, this message translates to:
  /// **'Adjust budget'**
  String get adjustBudget;

  /// No description provided for @nothingToChange.
  ///
  /// In en, this message translates to:
  /// **'Nothing to change this week'**
  String get nothingToChange;

  /// No description provided for @newMonthGreeting.
  ///
  /// In en, this message translates to:
  /// **'New month, fresh start.'**
  String get newMonthGreeting;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @dataAndExport.
  ///
  /// In en, this message translates to:
  /// **'Data & Export'**
  String get dataAndExport;

  /// No description provided for @reflect.
  ///
  /// In en, this message translates to:
  /// **'Reflect'**
  String get reflect;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @trendsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your spending patterns over time.'**
  String get trendsDescription;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrend;

  /// No description provided for @spendingTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Monthly total expenses for the last few months.'**
  String get spendingTrendDescription;

  /// No description provided for @categoryTrend.
  ///
  /// In en, this message translates to:
  /// **'Category Trend'**
  String get categoryTrend;

  /// No description provided for @categoryTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Spending distribution by category over time.'**
  String get categoryTrendDescription;

  /// No description provided for @noTrendData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data for trends yet.'**
  String get noTrendData;

  /// No description provided for @plannedVsUnplanned.
  ///
  /// In en, this message translates to:
  /// **'Planned vs Unplanned'**
  String get plannedVsUnplanned;

  /// No description provided for @plannedVsUnplannedDescription.
  ///
  /// In en, this message translates to:
  /// **'Weekly spending by intent (planned vs unplanned).'**
  String get plannedVsUnplannedDescription;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get weeks;

  /// No description provided for @incomeVsExpensesTrend.
  ///
  /// In en, this message translates to:
  /// **'Income vs. Expenses Trend'**
  String get incomeVsExpensesTrend;

  /// No description provided for @incomeVsExpensesTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Comparison of your monthly income and expenses.'**
  String get incomeVsExpensesTrendDescription;

  /// No description provided for @incomeTrend.
  ///
  /// In en, this message translates to:
  /// **'Income Trend'**
  String get incomeTrend;

  /// No description provided for @incomeTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Monthly total income for the last few months.'**
  String get incomeTrendDescription;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Awareness over Automation'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Sati is about mindful spending. We intentionally avoid bank sync to give you full control and awareness over every cent.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Friction by Design'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Large expenses trigger a moment of reflection. Was it planned? How do you feel? This \'Intent Prompt\' helps you make better decisions.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Reflective Insights'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Weekly reviews and clear trends help you understand your behavior patterns without being overwhelmed by data.'**
  String get onboardingBody3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @moneyAllocatedInfo.
  ///
  /// In en, this message translates to:
  /// **'{amount} of which budgeted'**
  String moneyAllocatedInfo(String amount);

  /// No description provided for @savingBudgets.
  ///
  /// In en, this message translates to:
  /// **'Saving & Investing'**
  String get savingBudgets;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @monthlyAllocation.
  ///
  /// In en, this message translates to:
  /// **'Monthly Allocation'**
  String get monthlyAllocation;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Budgeted'**
  String get allocated;

  /// No description provided for @noAllocations.
  ///
  /// In en, this message translates to:
  /// **'No saving budgets yet'**
  String get noAllocations;

  /// No description provided for @addAllocation.
  ///
  /// In en, this message translates to:
  /// **'Add Saving Budget'**
  String get addAllocation;

  /// No description provided for @editAllocation.
  ///
  /// In en, this message translates to:
  /// **'Edit Saving Budget'**
  String get editAllocation;

  /// No description provided for @allocate.
  ///
  /// In en, this message translates to:
  /// **'Add to Budget'**
  String get allocate;

  /// No description provided for @amountToAllocate.
  ///
  /// In en, this message translates to:
  /// **'Amount to add'**
  String get amountToAllocate;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
