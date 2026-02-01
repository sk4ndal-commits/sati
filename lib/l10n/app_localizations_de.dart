// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sati';

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
  String get feeling1 => 'Schrecklich';

  @override
  String get feeling2 => 'Schlecht';

  @override
  String get feeling3 => 'Neutral';

  @override
  String get feeling4 => 'Gut';

  @override
  String get feeling5 => 'Sehr gut';

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
      'Deine ungeplanten Ausgaben sind diese Woche recht hoch. Versuche, mehr Ausgaben im Voraus zu planen.';

  @override
  String suggestionReduceTop(String category) {
    return 'Du hast am meisten für $category ausgegeben. Findest du einen Weg, dies nächste Woche zu reduzieren?';
  }

  @override
  String get weeklyReviewDescription => 'Deine Finanzwoche im Überblick.';

  @override
  String get feelingDistribution => 'Gefühlsverteilung';

  @override
  String get avgFeelingNegative =>
      'Ungeplante Ausgaben fühlten sich im Schnitt eher negativ an.';

  @override
  String get avgFeelingNeutral =>
      'Ungeplante Ausgaben fühlten sich im Schnitt neutral an.';

  @override
  String get avgFeelingPositive =>
      'Ungeplante Ausgaben fühlten sich im Schnitt positiv an.';

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
  String get forThisMonth => 'für diesen Monat';

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
}
