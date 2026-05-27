// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Музеи Витебска';

  @override
  String get login => 'Вход';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get invalidCredentials => 'Неверный email или пароль';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get museums => 'Музеи';

  @override
  String get weather => 'Погода';

  @override
  String get loading => 'Загрузка...';

  @override
  String get errorLoading => 'Не удалось загрузить данные';

  @override
  String get offlineMode => 'Офлайн-режим — кэшированные данные';

  @override
  String get theme => 'Тема';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get cacheCleared => 'Кэш очищен';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get noExhibitions => 'Выставки не запланированы';

  @override
  String get address => 'Адрес';

  @override
  String get openHours => 'Часы работы';

  @override
  String get admissionFee => 'Стоимость входа';
}
