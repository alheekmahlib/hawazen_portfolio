class AppConfig {
  /// Optional: pass `--dart-define=CONTENT_URL=<raw github url>` at build time.
  static const String defaultContentUrl = String.fromEnvironment(
    'CONTENT_URL',
    defaultValue:
        'https://raw.githubusercontent.com/alheekmahlib/data/main/websites/hawazen_portfolio/content.json',
  );
}
