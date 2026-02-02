// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioContent _$PortfolioContentFromJson(Map<String, dynamic> json) =>
    _PortfolioContent(
      schemaVersion: json['schemaVersion'] as String,
      defaultLocale: json['defaultLocale'] as String? ?? 'en',
      locales:
          (json['locales'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['en', 'ar'],
      site: json['site'] == null
          ? const SiteInfo()
          : SiteInfo.fromJson(json['site'] as Map<String, dynamic>),
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => PortfolioSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortfolioContentToJson(_PortfolioContent instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'defaultLocale': instance.defaultLocale,
      'locales': instance.locales,
      'site': instance.site,
      'sections': instance.sections,
    };

_SiteInfo _$SiteInfoFromJson(Map<String, dynamic> json) => _SiteInfo(
  name: const L10nTextConverter().fromJson(json['name']),
  role: const L10nTextConverter().fromJson(json['role']),
  subtitle: const L10nTextConverter().fromJson(json['subtitle']),
  bio: const L10nTextConverter().fromJson(json['bio']),
  social:
      (json['social'] as List<dynamic>?)
          ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contact: json['contact'] == null
      ? const ContactInfo()
      : ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteInfoToJson(_SiteInfo instance) => <String, dynamic>{
  'name': _$JsonConverterToJson<Object?, L10nText>(
    instance.name,
    const L10nTextConverter().toJson,
  ),
  'role': _$JsonConverterToJson<Object?, L10nText>(
    instance.role,
    const L10nTextConverter().toJson,
  ),
  'subtitle': _$JsonConverterToJson<Object?, L10nText>(
    instance.subtitle,
    const L10nTextConverter().toJson,
  ),
  'bio': _$JsonConverterToJson<Object?, L10nText>(
    instance.bio,
    const L10nTextConverter().toJson,
  ),
  'social': instance.social,
  'contact': instance.contact,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_SocialLink _$SocialLinkFromJson(Map<String, dynamic> json) =>
    _SocialLink(label: json['label'] as String, url: json['url'] as String);

Map<String, dynamic> _$SocialLinkToJson(_SocialLink instance) =>
    <String, dynamic>{'label': instance.label, 'url': instance.url};

_ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => _ContactInfo(
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  whatsapp: json['whatsapp'] as String?,
);

Map<String, dynamic> _$ContactInfoToJson(_ContactInfo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
    };

_FieldDefinition _$FieldDefinitionFromJson(Map<String, dynamic> json) =>
    _FieldDefinition(
      key: json['key'] as String,
      label: const L10nTextConverter().fromJson(json['label']),
      type: $enumDecode(_$FieldTypeEnumMap, json['type']),
      required: json['required'] as bool? ?? false,
      localized: json['localized'] as bool? ?? false,
      multiple: json['multiple'] as bool? ?? false,
    );

Map<String, dynamic> _$FieldDefinitionToJson(_FieldDefinition instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': const L10nTextConverter().toJson(instance.label),
      'type': _$FieldTypeEnumMap[instance.type]!,
      'required': instance.required,
      'localized': instance.localized,
      'multiple': instance.multiple,
    };

const _$FieldTypeEnumMap = {
  FieldType.string: 'string',
  FieldType.markdown: 'markdown',
  FieldType.image: 'image',
  FieldType.link: 'link',
  FieldType.tagList: 'tagList',
  FieldType.date: 'date',
  FieldType.number: 'number',
  FieldType.boolean: 'boolean',
};

_CardLayout _$CardLayoutFromJson(Map<String, dynamic> json) => _CardLayout(
  titleField: json['titleField'] as String,
  subtitleField: json['subtitleField'] as String?,
  mediaField: json['mediaField'] as String?,
);

Map<String, dynamic> _$CardLayoutToJson(_CardLayout instance) =>
    <String, dynamic>{
      'titleField': instance.titleField,
      'subtitleField': instance.subtitleField,
      'mediaField': instance.mediaField,
    };

_DetailLayout _$DetailLayoutFromJson(Map<String, dynamic> json) =>
    _DetailLayout(
      titleField: json['titleField'] as String,
      subtitleField: json['subtitleField'] as String?,
      mediaField: json['mediaField'] as String?,
      galleryField: json['galleryField'] as String?,
      bodyFields:
          (json['bodyFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      actionFields:
          (json['actionFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DetailLayoutToJson(_DetailLayout instance) =>
    <String, dynamic>{
      'titleField': instance.titleField,
      'subtitleField': instance.subtitleField,
      'mediaField': instance.mediaField,
      'galleryField': instance.galleryField,
      'bodyFields': instance.bodyFields,
      'actionFields': instance.actionFields,
    };

_PortfolioSection _$PortfolioSectionFromJson(Map<String, dynamic> json) =>
    _PortfolioSection(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: const L10nTextConverter().fromJson(json['title']),
      enabled: json['enabled'] as bool? ?? true,
      fieldDefinitions:
          (json['fieldDefinitions'] as List<dynamic>?)
              ?.map((e) => FieldDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cardLayout: CardLayout.fromJson(
        json['cardLayout'] as Map<String, dynamic>,
      ),
      detailLayout: DetailLayout.fromJson(
        json['detailLayout'] as Map<String, dynamic>,
      ),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => SectionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortfolioSectionToJson(_PortfolioSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': const L10nTextConverter().toJson(instance.title),
      'enabled': instance.enabled,
      'fieldDefinitions': instance.fieldDefinitions,
      'cardLayout': instance.cardLayout,
      'detailLayout': instance.detailLayout,
      'items': instance.items,
    };

_SectionItem _$SectionItemFromJson(Map<String, dynamic> json) => _SectionItem(
  id: json['id'] as String,
  enabled: json['enabled'] as bool? ?? true,
  fields: json['fields'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$SectionItemToJson(_SectionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enabled': instance.enabled,
      'fields': instance.fields,
    };
