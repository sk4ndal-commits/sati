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
}
