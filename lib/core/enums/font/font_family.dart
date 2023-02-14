enum AppFontFamily {
  nunito,
  WTGothic,
  LatoTR,
  arial,
}

extension AppFontFamilyValue on AppFontFamily {
  String get value {
    switch (this) {
      case AppFontFamily.nunito:
        return 'Nunito';
      case AppFontFamily.WTGothic:
        return 'WTGothic';
      case AppFontFamily.LatoTR:
        return 'LatoTR';
      case AppFontFamily.arial:
        return 'Arial';
      default:
        return 'Nunito';
    }
  }
}
