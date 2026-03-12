enum Environment { dev, staging, prod }

class EnvConfig {
  static const Environment current = Environment.dev;

  static String get apiBaseUrl {
    switch (current) {
      case Environment.prod:
        return 'https://api.example.com';
      case Environment.staging:
        return 'https://staging.api.example.com';
      case Environment.dev:
      default:
        return 'https://dev.api.example.com';
    }
  }
}
