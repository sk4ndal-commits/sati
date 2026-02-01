// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'moneyful';

  @override
  String get addTransaction => 'Eintrag hinzufügen';

  @override
  String get expense => 'Ausgabe';

  @override
  String get income => 'Einnahme';

  @override
  String get amount => 'Betrag';

  @override
  String get category => 'Kategorie';

  @override
  String get date => 'Datum';

  @override
  String get note => 'Notiz (optional)';

  @override
  String get save => 'Speichern';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get invalidAmount => 'Ungültiger Betrag';

  @override
  String get transactionSaved => 'Transaktion gespeichert';

  @override
  String get noTransactions => 'Noch keine Transaktionen';

  @override
  String get categoryFood => 'Essen';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryLeisure => 'Freizeit';

  @override
  String get categoryHousing => 'Wohnen';

  @override
  String get categorySalary => 'Gehalt';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get incomeSources => 'Einkommensquellen';

  @override
  String get addIncomeSource => 'Einkommensquelle hinzufügen';

  @override
  String get sourceName => 'Name der Quelle';

  @override
  String get expectedAmount => 'Erwarteter Betrag';

  @override
  String get cadence => 'Rhythmus';

  @override
  String get monthly => 'Monatlich';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get noIncomeSources => 'Noch keine Einkommensquellen';

  @override
  String get actual => 'Ist';

  @override
  String get expected => 'Soll';

  @override
  String get missing => 'Fehlend';

  @override
  String get incomeSource => 'Einkommensquelle';

  @override
  String get selectSource => 'Quelle wählen';

  @override
  String get budgets => 'Budgets';

  @override
  String get addBudget => 'Budget hinzufügen';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get remaining => 'Verbleibend';

  @override
  String get rollover => 'Rollover';

  @override
  String get noBudgets => 'Noch keine Budgets festgelegt';

  @override
  String get editBudget => 'Budget bearbeiten';

  @override
  String get budgetAlertTitle => 'Budget-Warnung';

  @override
  String budgetAlertBody(String category, int percent) {
    return 'Du hast $percent% deines Budgets für $category verbraucht.';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get intentPrompt => 'Intent Prompt';

  @override
  String get intentPromptDescription =>
      'Reflektion bei Ausgaben über einem Schwellenwert anfordern';

  @override
  String get threshold => 'Schwellenwert';

  @override
  String get wasPlanned => 'War das geplant?';

  @override
  String get howDoYouFeel => 'Wie fühlst du dich?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get feeling1 => 'Unangenehm';

  @override
  String get feeling2 => 'Eher unangenehm';

  @override
  String get feeling3 => 'Neutral';

  @override
  String get feeling4 => 'Eher angenehm';

  @override
  String get feeling5 => 'Angenehm';

  @override
  String get reflection => 'Reflektion';

  @override
  String get weeklyReview => 'Wochenrückblick';

  @override
  String get topCategories => 'Top Kategorien';

  @override
  String get unplannedSpend => 'Ungeplante Ausgaben';

  @override
  String get suggestions => 'Vorschlag';

  @override
  String get suggestionGeneric =>
      'Erfasse weiterhin deine Ausgaben, um bessere Einblicke zu erhalten.';

  @override
  String get suggestionHighUnplanned =>
      'Du hast diese Woche einige ungeplante Ausgaben getätigt. Ein Budget könnte helfen, diese besser einzuplanen.';

  @override
  String suggestionReduceTop(String category) {
    return 'Für $category wurde diese Woche am meisten ausgegeben. Möchtest du dir das für nächste Woche genauer ansehen?';
  }

  @override
  String get weeklyReviewDescription => 'Deine Finanzwoche im Überblick.';

  @override
  String get feelingDistribution => 'Gefühlsverteilung';

  @override
  String get avgFeelingNegative =>
      'Die ungeplanten Ausgaben waren eher mit unangenehmen Gefühlen verbunden.';

  @override
  String get avgFeelingNeutral =>
      'Die ungeplanten Ausgaben fühlten sich neutral an.';

  @override
  String get avgFeelingPositive =>
      'Die ungeplanten Ausgaben fühlten sich überwiegend angenehm an.';

  @override
  String get noUnplannedData => 'Keine ungeplanten Ausgaben zur Reflexion.';

  @override
  String get frequentlyUnplanned => 'häufig ungeplant';

  @override
  String percentUnplanned(int percent) {
    return '$percent% ungeplant';
  }

  @override
  String get remainingTotalBudget => 'Verbleibendes Gesamtbudget';

  @override
  String get moneyLeft => 'Geld übrig';

  @override
  String get viewAllBudgets => 'Alle Budgets anzeigen';

  @override
  String get forThisMonth => 'für diesen Monat';

  @override
  String get today => 'Heute';

  @override
  String get noTransactionsToday => 'Heute noch keine Einträge';

  @override
  String get planned => 'Geplant';

  @override
  String get unplanned => 'Ungeplant';

  @override
  String highUnplannedWeekly(String amount) {
    return 'Hohe ungeplante Ausgaben diese Woche: $amount €';
  }

  @override
  String budgetNearLimitSignal(String category) {
    return 'Budget für $category fast aufgebraucht';
  }

  @override
  String remainingBudgetInfo(String amount) {
    return 'Noch $amount € übrig diesen Monat';
  }

  @override
  String get monthlyOverview => 'Monatsübersicht';

  @override
  String get incomeVsExpenses => 'Einnahmen vs. Ausgaben';

  @override
  String get categoryBreakdown => 'Kategorien';

  @override
  String get savings => 'Ersparnisse';

  @override
  String get budgetStatus => 'Budget-Status';

  @override
  String get totalBudgeted => 'Gesamt budgetiert';

  @override
  String ofTotal(Object percent) {
    return '$percent% der Gesamtausgaben';
  }

  @override
  String get dataAndBackup => 'Daten & Backup';

  @override
  String get exportCsv => 'Als CSV exportieren';

  @override
  String get exportJson => 'Als JSON exportieren';

  @override
  String get exportDescription =>
      'Exportiere alle deine Transaktionen, Budgets und Einkommensquellen in ein menschenlesbares Format. Du behältst die volle Kontrolle über deine Daten.';

  @override
  String get adjustBudget => 'Budget anpassen';

  @override
  String get nothingToChange => 'Nichts ändern diese Woche';

  @override
  String get newMonthGreeting => 'Neuer Monat, frischer Start.';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get dataAndExport => 'Daten & Export';

  @override
  String get reflect => 'Reflektieren';

  @override
  String get trends => 'Trends';

  @override
  String get trendsDescription => 'Dein Ausgabeverhalten über die Zeit.';

  @override
  String get home => 'Home';

  @override
  String get spendingTrend => 'Ausgabentrend';

  @override
  String get spendingTrendDescription =>
      'Monatliche Gesamtausgaben der letzten Monate.';

  @override
  String get categoryTrend => 'Kategorietrend';

  @override
  String get categoryTrendDescription =>
      'Verteilung der Ausgaben nach Kategorien über die Zeit.';

  @override
  String get noTrendData => 'Nicht genügend Daten für Trends verfügbar.';

  @override
  String get plannedVsUnplanned => 'Geplant vs. Ungeplant';

  @override
  String get plannedVsUnplannedDescription =>
      'Wöchentliche Ausgaben nach Absicht (geplant vs. ungeplant).';

  @override
  String get weeks => 'Wochen';

  @override
  String get incomeVsExpensesTrend => 'Einnahmen vs. Ausgaben Trend';

  @override
  String get incomeVsExpensesTrendDescription =>
      'Vergleich deiner monatlichen Einnahmen und Ausgaben.';

  @override
  String get incomeTrend => 'Einnahmentrend';

  @override
  String get incomeTrendDescription =>
      'Monatliche Gesamteinnahmen der letzten Monate.';

  @override
  String get onboardingTitle1 => 'Bewusstsein vor Automatisierung';

  @override
  String get onboardingBody1 =>
      'Bei Sati geht es um achtsame Ausgaben. Wir verzichten bewusst auf Bank-Sync, um dir die volle Kontrolle und Aufmerksamkeit über jeden Cent zu geben.';

  @override
  String get onboardingTitle2 => 'Reibung durch Design';

  @override
  String get onboardingBody2 =>
      'Große Ausgaben lösen einen Moment der Reflexion aus. War es geplant? Wie fühlst du dich? Dieser \'Intent Prompt\' hilft dir, bessere Entscheidungen zu treffen.';

  @override
  String get onboardingTitle3 => 'Reflektierende Einblicke';

  @override
  String get onboardingBody3 =>
      'Wöchentliche Rückblicke und klare Trends helfen dir, Verhaltensmuster zu verstehen, ohne von Daten überwältigt zu werden.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get transactionDeleted => 'Transaktion gelöscht';

  @override
  String moneyAllocatedInfo(String amount) {
    return 'davon budgetiert: $amount';
  }

  @override
  String get savingBudgets => 'Sparen & Investieren';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get targetAmount => 'Zielbetrag';

  @override
  String get monthlyAllocation => 'Monatliches Budget';

  @override
  String get allocated => 'Budgetiert';

  @override
  String get noAllocations => 'Noch keine Spar-Budgets';

  @override
  String get addAllocation => 'Spar-Budget hinzufügen';

  @override
  String get editAllocation => 'Spar-Budget bearbeiten';

  @override
  String get allocate => 'Hinzufügen';

  @override
  String get amountToAllocate => 'Betrag zum Hinzufügen';

  @override
  String get name => 'Name';
}
