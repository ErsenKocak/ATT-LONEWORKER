enum HttpClientApiUrl { login }

extension HttpClientApiUrlExtension on HttpClientApiUrl {
  String get uri {
    switch (this) {
      case HttpClientApiUrl.login:
        return 'Login';
      default:
        return '';
    }
  }
}
