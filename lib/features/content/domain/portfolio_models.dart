import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_models.freezed.dart';
part 'portfolio_models.g.dart';

@freezed
sealed class PortfolioContent with _$PortfolioContent {
  const factory PortfolioContent({
    required String schemaVersion,
    @Default('en') String defaultLocale,
    @Default(['en', 'ar']) List<String> locales,
    @Default(SiteInfo()) SiteInfo site,
    @Default([]) List<PortfolioSection> sections,
  }) = _PortfolioContent;

  factory PortfolioContent.fromJson(Map<String, Object?> json) =>
      _$PortfolioContentFromJson(json);
}

@freezed
sealed class SiteInfo with _$SiteInfo {
  const factory SiteInfo({
    @L10nTextConverter() L10nText? name,
    @L10nTextConverter() L10nText? role,
    @L10nTextConverter() L10nText? subtitle,
    @L10nTextConverter() L10nText? bio,
    @Default([]) List<SocialLink> social,
    @Default(ContactInfo()) ContactInfo contact,
  }) = _SiteInfo;

  factory SiteInfo.fromJson(Map<String, Object?> json) =>
      _$SiteInfoFromJson(json);
}

@freezed
sealed class SocialLink with _$SocialLink {
  const factory SocialLink({
    required String label,
    required String url,
  }) = _SocialLink;

  factory SocialLink.fromJson(Map<String, Object?> json) =>
      _$SocialLinkFromJson(json);
}

@freezed
sealed class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    String? email,
    String? phone,
    String? whatsapp,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, Object?> json) =>
      _$ContactInfoFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.none)
enum FieldType {
  @JsonValue('string')
  string,
  @JsonValue('markdown')
  markdown,
  @JsonValue('image')
  image,
  @JsonValue('link')
  link,
  @JsonValue('tagList')
  tagList,
  @JsonValue('date')
  date,
  @JsonValue('number')
  number,
  @JsonValue('boolean')
  boolean,
}

@freezed
sealed class FieldDefinition with _$FieldDefinition {
  const factory FieldDefinition({
    required String key,
    @L10nTextConverter() required L10nText label,
    required FieldType type,
    @Default(false) bool required,
    @Default(false) bool localized,
    @Default(false) bool multiple,
  }) = _FieldDefinition;

  factory FieldDefinition.fromJson(Map<String, Object?> json) =>
      _$FieldDefinitionFromJson(json);
}

@freezed
sealed class CardLayout with _$CardLayout {
  const factory CardLayout({
    required String titleField,
    String? subtitleField,
    String? mediaField,
  }) = _CardLayout;

  factory CardLayout.fromJson(Map<String, Object?> json) =>
      _$CardLayoutFromJson(json);
}

@freezed
sealed class DetailLayout with _$DetailLayout {
  const factory DetailLayout({
    required String titleField,
    String? subtitleField,
    String? mediaField,
    String? galleryField,
    @Default([]) List<String> bodyFields,
    @Default([]) List<String> actionFields,
  }) = _DetailLayout;

  factory DetailLayout.fromJson(Map<String, Object?> json) =>
      _$DetailLayoutFromJson(json);
}

@freezed
sealed class PortfolioSection with _$PortfolioSection {
  const factory PortfolioSection({
    required String id,
    required String slug,
    @L10nTextConverter() required L10nText title,
    @Default(true) bool enabled,
    @Default([]) List<FieldDefinition> fieldDefinitions,
    required CardLayout cardLayout,
    required DetailLayout detailLayout,
    @Default([]) List<SectionItem> items,
  }) = _PortfolioSection;

  factory PortfolioSection.fromJson(Map<String, Object?> json) =>
      _$PortfolioSectionFromJson(json);
}

@freezed
sealed class SectionItem with _$SectionItem {
  const factory SectionItem({
    required String id,
    @Default(true) bool enabled,
    @Default(<String, Object?>{}) Map<String, Object?> fields,
  }) = _SectionItem;

  factory SectionItem.fromJson(Map<String, Object?> json) =>
      _$SectionItemFromJson(json);
}

@immutable
class L10nText {
  const L10nText(this.values);

  final Map<String, String> values;

  String resolve(String localeCode, {String fallback = 'en'}) {
    return values[localeCode] ?? values[fallback] ?? values.values.firstOrNull ??
        '';
  }

  static L10nText fromJson(Object? json) {
    if (json is String) return L10nText({'en': json});
    if (json is Map) {
      return L10nText(
        json.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')),
      );
    }
    return const L10nText({});
  }

  Object toJson() => values;
}

class L10nTextConverter implements JsonConverter<L10nText, Object?> {
  const L10nTextConverter();

  @override
  L10nText fromJson(Object? json) => L10nText.fromJson(json);

  @override
  Object? toJson(L10nText object) => object.toJson();
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
