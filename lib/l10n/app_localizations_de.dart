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
}
