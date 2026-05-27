// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vitebsk Museums';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get logout => 'Logout';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get museums => 'Museums';

  @override
  String get weather => 'Weather';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoading => 'Failed to load data';

  @override
  String get offlineMode => 'Offline mode — cached data';

  @override
  String get theme => 'Theme';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get appVersion => 'App Version';

  @override
  String get noExhibitions => 'No exhibitions scheduled';

  @override
  String get address => 'Address';

  @override
  String get openHours => 'Opening Hours';

  @override
  String get admissionFee => 'Admission Fee';
}
