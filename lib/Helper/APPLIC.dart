import 'dart:ui';

typedef void LocaleChangeCallback(Locale locale);
class APPLIC {
  // List of supported languages
  final List<String> supportedLanguages = ['en','fr'];

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Function to be invoked when changing the working language
  LocaleChangeCallback onLocaleChanged;

  ///
  /// Internals
  ///
  static final APPLIC _applic = new APPLIC._internal();

  factory APPLIC(){
    return _applic;
  }

  APPLIC._internal();
}

APPLIC applic = new APPLIC();