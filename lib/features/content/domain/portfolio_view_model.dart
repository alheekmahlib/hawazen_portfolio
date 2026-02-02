import 'package:flutter/widgets.dart';

import 'portfolio_models.dart';

class PortfolioViewModel {
  PortfolioViewModel({
    required this.name,
    required this.role,
    required this.subtitle,
    required this.bio,
    required this.sections,
  });

  final String name;
  final String role;
  final String subtitle;
  final String bio;
  final List<PortfolioSection> sections;

  factory PortfolioViewModel.from(PortfolioContent content, Locale locale) {
    return PortfolioViewModel(
      name: content.site.name?.resolve(locale.languageCode) ?? '',
      role: content.site.role?.resolve(locale.languageCode) ?? '',
      subtitle: content.site.subtitle?.resolve(locale.languageCode) ?? '',
      bio: content.site.bio?.resolve(locale.languageCode) ?? '',
      sections: content.sections.where((s) => s.enabled).toList(),
    );
  }
}
