// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioContent {

 String get schemaVersion; String get defaultLocale; List<String> get locales; SiteInfo get site; List<PortfolioSection> get sections;
/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioContentCopyWith<PortfolioContent> get copyWith => _$PortfolioContentCopyWithImpl<PortfolioContent>(this as PortfolioContent, _$identity);

  /// Serializes this PortfolioContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioContent&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.defaultLocale, defaultLocale) || other.defaultLocale == defaultLocale)&&const DeepCollectionEquality().equals(other.locales, locales)&&(identical(other.site, site) || other.site == site)&&const DeepCollectionEquality().equals(other.sections, sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,defaultLocale,const DeepCollectionEquality().hash(locales),site,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'PortfolioContent(schemaVersion: $schemaVersion, defaultLocale: $defaultLocale, locales: $locales, site: $site, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $PortfolioContentCopyWith<$Res>  {
  factory $PortfolioContentCopyWith(PortfolioContent value, $Res Function(PortfolioContent) _then) = _$PortfolioContentCopyWithImpl;
@useResult
$Res call({
 String schemaVersion, String defaultLocale, List<String> locales, SiteInfo site, List<PortfolioSection> sections
});


$SiteInfoCopyWith<$Res> get site;

}
/// @nodoc
class _$PortfolioContentCopyWithImpl<$Res>
    implements $PortfolioContentCopyWith<$Res> {
  _$PortfolioContentCopyWithImpl(this._self, this._then);

  final PortfolioContent _self;
  final $Res Function(PortfolioContent) _then;

/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? defaultLocale = null,Object? locales = null,Object? site = null,Object? sections = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,defaultLocale: null == defaultLocale ? _self.defaultLocale : defaultLocale // ignore: cast_nullable_to_non_nullable
as String,locales: null == locales ? _self.locales : locales // ignore: cast_nullable_to_non_nullable
as List<String>,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteInfo,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<PortfolioSection>,
  ));
}
/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteInfoCopyWith<$Res> get site {
  
  return $SiteInfoCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// Adds pattern-matching-related methods to [PortfolioContent].
extension PortfolioContentPatterns on PortfolioContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioContent value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioContent():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioContent value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String schemaVersion,  String defaultLocale,  List<String> locales,  SiteInfo site,  List<PortfolioSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioContent() when $default != null:
return $default(_that.schemaVersion,_that.defaultLocale,_that.locales,_that.site,_that.sections);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String schemaVersion,  String defaultLocale,  List<String> locales,  SiteInfo site,  List<PortfolioSection> sections)  $default,) {final _that = this;
switch (_that) {
case _PortfolioContent():
return $default(_that.schemaVersion,_that.defaultLocale,_that.locales,_that.site,_that.sections);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String schemaVersion,  String defaultLocale,  List<String> locales,  SiteInfo site,  List<PortfolioSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioContent() when $default != null:
return $default(_that.schemaVersion,_that.defaultLocale,_that.locales,_that.site,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioContent implements PortfolioContent {
  const _PortfolioContent({required this.schemaVersion, this.defaultLocale = 'en', final  List<String> locales = const ['en', 'ar'], this.site = const SiteInfo(), final  List<PortfolioSection> sections = const []}): _locales = locales,_sections = sections;
  factory _PortfolioContent.fromJson(Map<String, dynamic> json) => _$PortfolioContentFromJson(json);

@override final  String schemaVersion;
@override@JsonKey() final  String defaultLocale;
 final  List<String> _locales;
@override@JsonKey() List<String> get locales {
  if (_locales is EqualUnmodifiableListView) return _locales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locales);
}

@override@JsonKey() final  SiteInfo site;
 final  List<PortfolioSection> _sections;
@override@JsonKey() List<PortfolioSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioContentCopyWith<_PortfolioContent> get copyWith => __$PortfolioContentCopyWithImpl<_PortfolioContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioContent&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.defaultLocale, defaultLocale) || other.defaultLocale == defaultLocale)&&const DeepCollectionEquality().equals(other._locales, _locales)&&(identical(other.site, site) || other.site == site)&&const DeepCollectionEquality().equals(other._sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,defaultLocale,const DeepCollectionEquality().hash(_locales),site,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'PortfolioContent(schemaVersion: $schemaVersion, defaultLocale: $defaultLocale, locales: $locales, site: $site, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$PortfolioContentCopyWith<$Res> implements $PortfolioContentCopyWith<$Res> {
  factory _$PortfolioContentCopyWith(_PortfolioContent value, $Res Function(_PortfolioContent) _then) = __$PortfolioContentCopyWithImpl;
@override @useResult
$Res call({
 String schemaVersion, String defaultLocale, List<String> locales, SiteInfo site, List<PortfolioSection> sections
});


@override $SiteInfoCopyWith<$Res> get site;

}
/// @nodoc
class __$PortfolioContentCopyWithImpl<$Res>
    implements _$PortfolioContentCopyWith<$Res> {
  __$PortfolioContentCopyWithImpl(this._self, this._then);

  final _PortfolioContent _self;
  final $Res Function(_PortfolioContent) _then;

/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? defaultLocale = null,Object? locales = null,Object? site = null,Object? sections = null,}) {
  return _then(_PortfolioContent(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as String,defaultLocale: null == defaultLocale ? _self.defaultLocale : defaultLocale // ignore: cast_nullable_to_non_nullable
as String,locales: null == locales ? _self._locales : locales // ignore: cast_nullable_to_non_nullable
as List<String>,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteInfo,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<PortfolioSection>,
  ));
}

/// Create a copy of PortfolioContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteInfoCopyWith<$Res> get site {
  
  return $SiteInfoCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// @nodoc
mixin _$SiteInfo {

@L10nTextConverter() L10nText? get name;@L10nTextConverter() L10nText? get role;@L10nTextConverter() L10nText? get subtitle;@L10nTextConverter() L10nText? get bio; List<SocialLink> get social; ContactInfo get contact;
/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteInfoCopyWith<SiteInfo> get copyWith => _$SiteInfoCopyWithImpl<SiteInfo>(this as SiteInfo, _$identity);

  /// Serializes this SiteInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.social, social)&&(identical(other.contact, contact) || other.contact == contact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,role,subtitle,bio,const DeepCollectionEquality().hash(social),contact);

@override
String toString() {
  return 'SiteInfo(name: $name, role: $role, subtitle: $subtitle, bio: $bio, social: $social, contact: $contact)';
}


}

/// @nodoc
abstract mixin class $SiteInfoCopyWith<$Res>  {
  factory $SiteInfoCopyWith(SiteInfo value, $Res Function(SiteInfo) _then) = _$SiteInfoCopyWithImpl;
@useResult
$Res call({
@L10nTextConverter() L10nText? name,@L10nTextConverter() L10nText? role,@L10nTextConverter() L10nText? subtitle,@L10nTextConverter() L10nText? bio, List<SocialLink> social, ContactInfo contact
});


$ContactInfoCopyWith<$Res> get contact;

}
/// @nodoc
class _$SiteInfoCopyWithImpl<$Res>
    implements $SiteInfoCopyWith<$Res> {
  _$SiteInfoCopyWithImpl(this._self, this._then);

  final SiteInfo _self;
  final $Res Function(SiteInfo) _then;

/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? role = freezed,Object? subtitle = freezed,Object? bio = freezed,Object? social = null,Object? contact = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as L10nText?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as L10nText?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as L10nText?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as L10nText?,social: null == social ? _self.social : social // ignore: cast_nullable_to_non_nullable
as List<SocialLink>,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactInfo,
  ));
}
/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<$Res> get contact {
  
  return $ContactInfoCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteInfo].
extension SiteInfoPatterns on SiteInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteInfo value)  $default,){
final _that = this;
switch (_that) {
case _SiteInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SiteInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@L10nTextConverter()  L10nText? name, @L10nTextConverter()  L10nText? role, @L10nTextConverter()  L10nText? subtitle, @L10nTextConverter()  L10nText? bio,  List<SocialLink> social,  ContactInfo contact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteInfo() when $default != null:
return $default(_that.name,_that.role,_that.subtitle,_that.bio,_that.social,_that.contact);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@L10nTextConverter()  L10nText? name, @L10nTextConverter()  L10nText? role, @L10nTextConverter()  L10nText? subtitle, @L10nTextConverter()  L10nText? bio,  List<SocialLink> social,  ContactInfo contact)  $default,) {final _that = this;
switch (_that) {
case _SiteInfo():
return $default(_that.name,_that.role,_that.subtitle,_that.bio,_that.social,_that.contact);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@L10nTextConverter()  L10nText? name, @L10nTextConverter()  L10nText? role, @L10nTextConverter()  L10nText? subtitle, @L10nTextConverter()  L10nText? bio,  List<SocialLink> social,  ContactInfo contact)?  $default,) {final _that = this;
switch (_that) {
case _SiteInfo() when $default != null:
return $default(_that.name,_that.role,_that.subtitle,_that.bio,_that.social,_that.contact);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteInfo implements SiteInfo {
  const _SiteInfo({@L10nTextConverter() this.name, @L10nTextConverter() this.role, @L10nTextConverter() this.subtitle, @L10nTextConverter() this.bio, final  List<SocialLink> social = const [], this.contact = const ContactInfo()}): _social = social;
  factory _SiteInfo.fromJson(Map<String, dynamic> json) => _$SiteInfoFromJson(json);

@override@L10nTextConverter() final  L10nText? name;
@override@L10nTextConverter() final  L10nText? role;
@override@L10nTextConverter() final  L10nText? subtitle;
@override@L10nTextConverter() final  L10nText? bio;
 final  List<SocialLink> _social;
@override@JsonKey() List<SocialLink> get social {
  if (_social is EqualUnmodifiableListView) return _social;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_social);
}

@override@JsonKey() final  ContactInfo contact;

/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteInfoCopyWith<_SiteInfo> get copyWith => __$SiteInfoCopyWithImpl<_SiteInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._social, _social)&&(identical(other.contact, contact) || other.contact == contact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,role,subtitle,bio,const DeepCollectionEquality().hash(_social),contact);

@override
String toString() {
  return 'SiteInfo(name: $name, role: $role, subtitle: $subtitle, bio: $bio, social: $social, contact: $contact)';
}


}

/// @nodoc
abstract mixin class _$SiteInfoCopyWith<$Res> implements $SiteInfoCopyWith<$Res> {
  factory _$SiteInfoCopyWith(_SiteInfo value, $Res Function(_SiteInfo) _then) = __$SiteInfoCopyWithImpl;
@override @useResult
$Res call({
@L10nTextConverter() L10nText? name,@L10nTextConverter() L10nText? role,@L10nTextConverter() L10nText? subtitle,@L10nTextConverter() L10nText? bio, List<SocialLink> social, ContactInfo contact
});


@override $ContactInfoCopyWith<$Res> get contact;

}
/// @nodoc
class __$SiteInfoCopyWithImpl<$Res>
    implements _$SiteInfoCopyWith<$Res> {
  __$SiteInfoCopyWithImpl(this._self, this._then);

  final _SiteInfo _self;
  final $Res Function(_SiteInfo) _then;

/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? role = freezed,Object? subtitle = freezed,Object? bio = freezed,Object? social = null,Object? contact = null,}) {
  return _then(_SiteInfo(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as L10nText?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as L10nText?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as L10nText?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as L10nText?,social: null == social ? _self._social : social // ignore: cast_nullable_to_non_nullable
as List<SocialLink>,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactInfo,
  ));
}

/// Create a copy of SiteInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<$Res> get contact {
  
  return $ContactInfoCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// @nodoc
mixin _$SocialLink {

 String get label; String get url;
/// Create a copy of SocialLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialLinkCopyWith<SocialLink> get copyWith => _$SocialLinkCopyWithImpl<SocialLink>(this as SocialLink, _$identity);

  /// Serializes this SocialLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'SocialLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $SocialLinkCopyWith<$Res>  {
  factory $SocialLinkCopyWith(SocialLink value, $Res Function(SocialLink) _then) = _$SocialLinkCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$SocialLinkCopyWithImpl<$Res>
    implements $SocialLinkCopyWith<$Res> {
  _$SocialLinkCopyWithImpl(this._self, this._then);

  final SocialLink _self;
  final $Res Function(SocialLink) _then;

/// Create a copy of SocialLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialLink].
extension SocialLinkPatterns on SocialLink {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialLink() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialLink value)  $default,){
final _that = this;
switch (_that) {
case _SocialLink():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialLink value)?  $default,){
final _that = this;
switch (_that) {
case _SocialLink() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialLink() when $default != null:
return $default(_that.label,_that.url);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String url)  $default,) {final _that = this;
switch (_that) {
case _SocialLink():
return $default(_that.label,_that.url);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String url)?  $default,) {final _that = this;
switch (_that) {
case _SocialLink() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocialLink implements SocialLink {
  const _SocialLink({required this.label, required this.url});
  factory _SocialLink.fromJson(Map<String, dynamic> json) => _$SocialLinkFromJson(json);

@override final  String label;
@override final  String url;

/// Create a copy of SocialLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialLinkCopyWith<_SocialLink> get copyWith => __$SocialLinkCopyWithImpl<_SocialLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocialLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'SocialLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$SocialLinkCopyWith<$Res> implements $SocialLinkCopyWith<$Res> {
  factory _$SocialLinkCopyWith(_SocialLink value, $Res Function(_SocialLink) _then) = __$SocialLinkCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$SocialLinkCopyWithImpl<$Res>
    implements _$SocialLinkCopyWith<$Res> {
  __$SocialLinkCopyWithImpl(this._self, this._then);

  final _SocialLink _self;
  final $Res Function(_SocialLink) _then;

/// Create a copy of SocialLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_SocialLink(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ContactInfo {

 String? get email; String? get phone; String? get whatsapp;
/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<ContactInfo> get copyWith => _$ContactInfoCopyWithImpl<ContactInfo>(this as ContactInfo, _$identity);

  /// Serializes this ContactInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactInfo&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,whatsapp);

@override
String toString() {
  return 'ContactInfo(email: $email, phone: $phone, whatsapp: $whatsapp)';
}


}

/// @nodoc
abstract mixin class $ContactInfoCopyWith<$Res>  {
  factory $ContactInfoCopyWith(ContactInfo value, $Res Function(ContactInfo) _then) = _$ContactInfoCopyWithImpl;
@useResult
$Res call({
 String? email, String? phone, String? whatsapp
});




}
/// @nodoc
class _$ContactInfoCopyWithImpl<$Res>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._self, this._then);

  final ContactInfo _self;
  final $Res Function(ContactInfo) _then;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? phone = freezed,Object? whatsapp = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactInfo].
extension ContactInfoPatterns on ContactInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactInfo value)  $default,){
final _that = this;
switch (_that) {
case _ContactInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email,  String? phone,  String? whatsapp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that.email,_that.phone,_that.whatsapp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email,  String? phone,  String? whatsapp)  $default,) {final _that = this;
switch (_that) {
case _ContactInfo():
return $default(_that.email,_that.phone,_that.whatsapp);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email,  String? phone,  String? whatsapp)?  $default,) {final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that.email,_that.phone,_that.whatsapp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactInfo implements ContactInfo {
  const _ContactInfo({this.email, this.phone, this.whatsapp});
  factory _ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);

@override final  String? email;
@override final  String? phone;
@override final  String? whatsapp;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactInfoCopyWith<_ContactInfo> get copyWith => __$ContactInfoCopyWithImpl<_ContactInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactInfo&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,whatsapp);

@override
String toString() {
  return 'ContactInfo(email: $email, phone: $phone, whatsapp: $whatsapp)';
}


}

/// @nodoc
abstract mixin class _$ContactInfoCopyWith<$Res> implements $ContactInfoCopyWith<$Res> {
  factory _$ContactInfoCopyWith(_ContactInfo value, $Res Function(_ContactInfo) _then) = __$ContactInfoCopyWithImpl;
@override @useResult
$Res call({
 String? email, String? phone, String? whatsapp
});




}
/// @nodoc
class __$ContactInfoCopyWithImpl<$Res>
    implements _$ContactInfoCopyWith<$Res> {
  __$ContactInfoCopyWithImpl(this._self, this._then);

  final _ContactInfo _self;
  final $Res Function(_ContactInfo) _then;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? phone = freezed,Object? whatsapp = freezed,}) {
  return _then(_ContactInfo(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FieldDefinition {

 String get key;@L10nTextConverter() L10nText get label; FieldType get type; bool get required; bool get localized; bool get multiple;
/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldDefinitionCopyWith<FieldDefinition> get copyWith => _$FieldDefinitionCopyWithImpl<FieldDefinition>(this as FieldDefinition, _$identity);

  /// Serializes this FieldDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldDefinition&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.localized, localized) || other.localized == localized)&&(identical(other.multiple, multiple) || other.multiple == multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,localized,multiple);

@override
String toString() {
  return 'FieldDefinition(key: $key, label: $label, type: $type, required: $required, localized: $localized, multiple: $multiple)';
}


}

/// @nodoc
abstract mixin class $FieldDefinitionCopyWith<$Res>  {
  factory $FieldDefinitionCopyWith(FieldDefinition value, $Res Function(FieldDefinition) _then) = _$FieldDefinitionCopyWithImpl;
@useResult
$Res call({
 String key,@L10nTextConverter() L10nText label, FieldType type, bool required, bool localized, bool multiple
});




}
/// @nodoc
class _$FieldDefinitionCopyWithImpl<$Res>
    implements $FieldDefinitionCopyWith<$Res> {
  _$FieldDefinitionCopyWithImpl(this._self, this._then);

  final FieldDefinition _self;
  final $Res Function(FieldDefinition) _then;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? localized = null,Object? multiple = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as L10nText,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,localized: null == localized ? _self.localized : localized // ignore: cast_nullable_to_non_nullable
as bool,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldDefinition].
extension FieldDefinitionPatterns on FieldDefinition {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldDefinition value)  $default,){
final _that = this;
switch (_that) {
case _FieldDefinition():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key, @L10nTextConverter()  L10nText label,  FieldType type,  bool required,  bool localized,  bool multiple)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.localized,_that.multiple);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key, @L10nTextConverter()  L10nText label,  FieldType type,  bool required,  bool localized,  bool multiple)  $default,) {final _that = this;
switch (_that) {
case _FieldDefinition():
return $default(_that.key,_that.label,_that.type,_that.required,_that.localized,_that.multiple);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key, @L10nTextConverter()  L10nText label,  FieldType type,  bool required,  bool localized,  bool multiple)?  $default,) {final _that = this;
switch (_that) {
case _FieldDefinition() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.localized,_that.multiple);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldDefinition implements FieldDefinition {
  const _FieldDefinition({required this.key, @L10nTextConverter() required this.label, required this.type, this.required = false, this.localized = false, this.multiple = false});
  factory _FieldDefinition.fromJson(Map<String, dynamic> json) => _$FieldDefinitionFromJson(json);

@override final  String key;
@override@L10nTextConverter() final  L10nText label;
@override final  FieldType type;
@override@JsonKey() final  bool required;
@override@JsonKey() final  bool localized;
@override@JsonKey() final  bool multiple;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldDefinitionCopyWith<_FieldDefinition> get copyWith => __$FieldDefinitionCopyWithImpl<_FieldDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldDefinition&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.localized, localized) || other.localized == localized)&&(identical(other.multiple, multiple) || other.multiple == multiple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,localized,multiple);

@override
String toString() {
  return 'FieldDefinition(key: $key, label: $label, type: $type, required: $required, localized: $localized, multiple: $multiple)';
}


}

/// @nodoc
abstract mixin class _$FieldDefinitionCopyWith<$Res> implements $FieldDefinitionCopyWith<$Res> {
  factory _$FieldDefinitionCopyWith(_FieldDefinition value, $Res Function(_FieldDefinition) _then) = __$FieldDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String key,@L10nTextConverter() L10nText label, FieldType type, bool required, bool localized, bool multiple
});




}
/// @nodoc
class __$FieldDefinitionCopyWithImpl<$Res>
    implements _$FieldDefinitionCopyWith<$Res> {
  __$FieldDefinitionCopyWithImpl(this._self, this._then);

  final _FieldDefinition _self;
  final $Res Function(_FieldDefinition) _then;

/// Create a copy of FieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? localized = null,Object? multiple = null,}) {
  return _then(_FieldDefinition(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as L10nText,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,localized: null == localized ? _self.localized : localized // ignore: cast_nullable_to_non_nullable
as bool,multiple: null == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CardLayout {

 String get titleField; String? get subtitleField; String? get mediaField;
/// Create a copy of CardLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardLayoutCopyWith<CardLayout> get copyWith => _$CardLayoutCopyWithImpl<CardLayout>(this as CardLayout, _$identity);

  /// Serializes this CardLayout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardLayout&&(identical(other.titleField, titleField) || other.titleField == titleField)&&(identical(other.subtitleField, subtitleField) || other.subtitleField == subtitleField)&&(identical(other.mediaField, mediaField) || other.mediaField == mediaField));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,titleField,subtitleField,mediaField);

@override
String toString() {
  return 'CardLayout(titleField: $titleField, subtitleField: $subtitleField, mediaField: $mediaField)';
}


}

/// @nodoc
abstract mixin class $CardLayoutCopyWith<$Res>  {
  factory $CardLayoutCopyWith(CardLayout value, $Res Function(CardLayout) _then) = _$CardLayoutCopyWithImpl;
@useResult
$Res call({
 String titleField, String? subtitleField, String? mediaField
});




}
/// @nodoc
class _$CardLayoutCopyWithImpl<$Res>
    implements $CardLayoutCopyWith<$Res> {
  _$CardLayoutCopyWithImpl(this._self, this._then);

  final CardLayout _self;
  final $Res Function(CardLayout) _then;

/// Create a copy of CardLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleField = null,Object? subtitleField = freezed,Object? mediaField = freezed,}) {
  return _then(_self.copyWith(
titleField: null == titleField ? _self.titleField : titleField // ignore: cast_nullable_to_non_nullable
as String,subtitleField: freezed == subtitleField ? _self.subtitleField : subtitleField // ignore: cast_nullable_to_non_nullable
as String?,mediaField: freezed == mediaField ? _self.mediaField : mediaField // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardLayout].
extension CardLayoutPatterns on CardLayout {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardLayout() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardLayout value)  $default,){
final _that = this;
switch (_that) {
case _CardLayout():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardLayout value)?  $default,){
final _that = this;
switch (_that) {
case _CardLayout() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleField,  String? subtitleField,  String? mediaField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardLayout() when $default != null:
return $default(_that.titleField,_that.subtitleField,_that.mediaField);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleField,  String? subtitleField,  String? mediaField)  $default,) {final _that = this;
switch (_that) {
case _CardLayout():
return $default(_that.titleField,_that.subtitleField,_that.mediaField);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleField,  String? subtitleField,  String? mediaField)?  $default,) {final _that = this;
switch (_that) {
case _CardLayout() when $default != null:
return $default(_that.titleField,_that.subtitleField,_that.mediaField);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardLayout implements CardLayout {
  const _CardLayout({required this.titleField, this.subtitleField, this.mediaField});
  factory _CardLayout.fromJson(Map<String, dynamic> json) => _$CardLayoutFromJson(json);

@override final  String titleField;
@override final  String? subtitleField;
@override final  String? mediaField;

/// Create a copy of CardLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardLayoutCopyWith<_CardLayout> get copyWith => __$CardLayoutCopyWithImpl<_CardLayout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardLayoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardLayout&&(identical(other.titleField, titleField) || other.titleField == titleField)&&(identical(other.subtitleField, subtitleField) || other.subtitleField == subtitleField)&&(identical(other.mediaField, mediaField) || other.mediaField == mediaField));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,titleField,subtitleField,mediaField);

@override
String toString() {
  return 'CardLayout(titleField: $titleField, subtitleField: $subtitleField, mediaField: $mediaField)';
}


}

/// @nodoc
abstract mixin class _$CardLayoutCopyWith<$Res> implements $CardLayoutCopyWith<$Res> {
  factory _$CardLayoutCopyWith(_CardLayout value, $Res Function(_CardLayout) _then) = __$CardLayoutCopyWithImpl;
@override @useResult
$Res call({
 String titleField, String? subtitleField, String? mediaField
});




}
/// @nodoc
class __$CardLayoutCopyWithImpl<$Res>
    implements _$CardLayoutCopyWith<$Res> {
  __$CardLayoutCopyWithImpl(this._self, this._then);

  final _CardLayout _self;
  final $Res Function(_CardLayout) _then;

/// Create a copy of CardLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleField = null,Object? subtitleField = freezed,Object? mediaField = freezed,}) {
  return _then(_CardLayout(
titleField: null == titleField ? _self.titleField : titleField // ignore: cast_nullable_to_non_nullable
as String,subtitleField: freezed == subtitleField ? _self.subtitleField : subtitleField // ignore: cast_nullable_to_non_nullable
as String?,mediaField: freezed == mediaField ? _self.mediaField : mediaField // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DetailLayout {

 String get titleField; String? get subtitleField; String? get mediaField; String? get galleryField; List<String> get bodyFields; List<String> get actionFields;
/// Create a copy of DetailLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailLayoutCopyWith<DetailLayout> get copyWith => _$DetailLayoutCopyWithImpl<DetailLayout>(this as DetailLayout, _$identity);

  /// Serializes this DetailLayout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailLayout&&(identical(other.titleField, titleField) || other.titleField == titleField)&&(identical(other.subtitleField, subtitleField) || other.subtitleField == subtitleField)&&(identical(other.mediaField, mediaField) || other.mediaField == mediaField)&&(identical(other.galleryField, galleryField) || other.galleryField == galleryField)&&const DeepCollectionEquality().equals(other.bodyFields, bodyFields)&&const DeepCollectionEquality().equals(other.actionFields, actionFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,titleField,subtitleField,mediaField,galleryField,const DeepCollectionEquality().hash(bodyFields),const DeepCollectionEquality().hash(actionFields));

@override
String toString() {
  return 'DetailLayout(titleField: $titleField, subtitleField: $subtitleField, mediaField: $mediaField, galleryField: $galleryField, bodyFields: $bodyFields, actionFields: $actionFields)';
}


}

/// @nodoc
abstract mixin class $DetailLayoutCopyWith<$Res>  {
  factory $DetailLayoutCopyWith(DetailLayout value, $Res Function(DetailLayout) _then) = _$DetailLayoutCopyWithImpl;
@useResult
$Res call({
 String titleField, String? subtitleField, String? mediaField, String? galleryField, List<String> bodyFields, List<String> actionFields
});




}
/// @nodoc
class _$DetailLayoutCopyWithImpl<$Res>
    implements $DetailLayoutCopyWith<$Res> {
  _$DetailLayoutCopyWithImpl(this._self, this._then);

  final DetailLayout _self;
  final $Res Function(DetailLayout) _then;

/// Create a copy of DetailLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleField = null,Object? subtitleField = freezed,Object? mediaField = freezed,Object? galleryField = freezed,Object? bodyFields = null,Object? actionFields = null,}) {
  return _then(_self.copyWith(
titleField: null == titleField ? _self.titleField : titleField // ignore: cast_nullable_to_non_nullable
as String,subtitleField: freezed == subtitleField ? _self.subtitleField : subtitleField // ignore: cast_nullable_to_non_nullable
as String?,mediaField: freezed == mediaField ? _self.mediaField : mediaField // ignore: cast_nullable_to_non_nullable
as String?,galleryField: freezed == galleryField ? _self.galleryField : galleryField // ignore: cast_nullable_to_non_nullable
as String?,bodyFields: null == bodyFields ? _self.bodyFields : bodyFields // ignore: cast_nullable_to_non_nullable
as List<String>,actionFields: null == actionFields ? _self.actionFields : actionFields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DetailLayout].
extension DetailLayoutPatterns on DetailLayout {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailLayout() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailLayout value)  $default,){
final _that = this;
switch (_that) {
case _DetailLayout():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailLayout value)?  $default,){
final _that = this;
switch (_that) {
case _DetailLayout() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleField,  String? subtitleField,  String? mediaField,  String? galleryField,  List<String> bodyFields,  List<String> actionFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailLayout() when $default != null:
return $default(_that.titleField,_that.subtitleField,_that.mediaField,_that.galleryField,_that.bodyFields,_that.actionFields);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleField,  String? subtitleField,  String? mediaField,  String? galleryField,  List<String> bodyFields,  List<String> actionFields)  $default,) {final _that = this;
switch (_that) {
case _DetailLayout():
return $default(_that.titleField,_that.subtitleField,_that.mediaField,_that.galleryField,_that.bodyFields,_that.actionFields);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleField,  String? subtitleField,  String? mediaField,  String? galleryField,  List<String> bodyFields,  List<String> actionFields)?  $default,) {final _that = this;
switch (_that) {
case _DetailLayout() when $default != null:
return $default(_that.titleField,_that.subtitleField,_that.mediaField,_that.galleryField,_that.bodyFields,_that.actionFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DetailLayout implements DetailLayout {
  const _DetailLayout({required this.titleField, this.subtitleField, this.mediaField, this.galleryField, final  List<String> bodyFields = const [], final  List<String> actionFields = const []}): _bodyFields = bodyFields,_actionFields = actionFields;
  factory _DetailLayout.fromJson(Map<String, dynamic> json) => _$DetailLayoutFromJson(json);

@override final  String titleField;
@override final  String? subtitleField;
@override final  String? mediaField;
@override final  String? galleryField;
 final  List<String> _bodyFields;
@override@JsonKey() List<String> get bodyFields {
  if (_bodyFields is EqualUnmodifiableListView) return _bodyFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bodyFields);
}

 final  List<String> _actionFields;
@override@JsonKey() List<String> get actionFields {
  if (_actionFields is EqualUnmodifiableListView) return _actionFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionFields);
}


/// Create a copy of DetailLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailLayoutCopyWith<_DetailLayout> get copyWith => __$DetailLayoutCopyWithImpl<_DetailLayout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DetailLayoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailLayout&&(identical(other.titleField, titleField) || other.titleField == titleField)&&(identical(other.subtitleField, subtitleField) || other.subtitleField == subtitleField)&&(identical(other.mediaField, mediaField) || other.mediaField == mediaField)&&(identical(other.galleryField, galleryField) || other.galleryField == galleryField)&&const DeepCollectionEquality().equals(other._bodyFields, _bodyFields)&&const DeepCollectionEquality().equals(other._actionFields, _actionFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,titleField,subtitleField,mediaField,galleryField,const DeepCollectionEquality().hash(_bodyFields),const DeepCollectionEquality().hash(_actionFields));

@override
String toString() {
  return 'DetailLayout(titleField: $titleField, subtitleField: $subtitleField, mediaField: $mediaField, galleryField: $galleryField, bodyFields: $bodyFields, actionFields: $actionFields)';
}


}

/// @nodoc
abstract mixin class _$DetailLayoutCopyWith<$Res> implements $DetailLayoutCopyWith<$Res> {
  factory _$DetailLayoutCopyWith(_DetailLayout value, $Res Function(_DetailLayout) _then) = __$DetailLayoutCopyWithImpl;
@override @useResult
$Res call({
 String titleField, String? subtitleField, String? mediaField, String? galleryField, List<String> bodyFields, List<String> actionFields
});




}
/// @nodoc
class __$DetailLayoutCopyWithImpl<$Res>
    implements _$DetailLayoutCopyWith<$Res> {
  __$DetailLayoutCopyWithImpl(this._self, this._then);

  final _DetailLayout _self;
  final $Res Function(_DetailLayout) _then;

/// Create a copy of DetailLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleField = null,Object? subtitleField = freezed,Object? mediaField = freezed,Object? galleryField = freezed,Object? bodyFields = null,Object? actionFields = null,}) {
  return _then(_DetailLayout(
titleField: null == titleField ? _self.titleField : titleField // ignore: cast_nullable_to_non_nullable
as String,subtitleField: freezed == subtitleField ? _self.subtitleField : subtitleField // ignore: cast_nullable_to_non_nullable
as String?,mediaField: freezed == mediaField ? _self.mediaField : mediaField // ignore: cast_nullable_to_non_nullable
as String?,galleryField: freezed == galleryField ? _self.galleryField : galleryField // ignore: cast_nullable_to_non_nullable
as String?,bodyFields: null == bodyFields ? _self._bodyFields : bodyFields // ignore: cast_nullable_to_non_nullable
as List<String>,actionFields: null == actionFields ? _self._actionFields : actionFields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PortfolioSection {

 String get id; String get slug;@L10nTextConverter() L10nText get title; bool get enabled; List<FieldDefinition> get fieldDefinitions; CardLayout get cardLayout; DetailLayout get detailLayout; List<SectionItem> get items;
/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioSectionCopyWith<PortfolioSection> get copyWith => _$PortfolioSectionCopyWithImpl<PortfolioSection>(this as PortfolioSection, _$identity);

  /// Serializes this PortfolioSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioSection&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.fieldDefinitions, fieldDefinitions)&&(identical(other.cardLayout, cardLayout) || other.cardLayout == cardLayout)&&(identical(other.detailLayout, detailLayout) || other.detailLayout == detailLayout)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,enabled,const DeepCollectionEquality().hash(fieldDefinitions),cardLayout,detailLayout,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PortfolioSection(id: $id, slug: $slug, title: $title, enabled: $enabled, fieldDefinitions: $fieldDefinitions, cardLayout: $cardLayout, detailLayout: $detailLayout, items: $items)';
}


}

/// @nodoc
abstract mixin class $PortfolioSectionCopyWith<$Res>  {
  factory $PortfolioSectionCopyWith(PortfolioSection value, $Res Function(PortfolioSection) _then) = _$PortfolioSectionCopyWithImpl;
@useResult
$Res call({
 String id, String slug,@L10nTextConverter() L10nText title, bool enabled, List<FieldDefinition> fieldDefinitions, CardLayout cardLayout, DetailLayout detailLayout, List<SectionItem> items
});


$CardLayoutCopyWith<$Res> get cardLayout;$DetailLayoutCopyWith<$Res> get detailLayout;

}
/// @nodoc
class _$PortfolioSectionCopyWithImpl<$Res>
    implements $PortfolioSectionCopyWith<$Res> {
  _$PortfolioSectionCopyWithImpl(this._self, this._then);

  final PortfolioSection _self;
  final $Res Function(PortfolioSection) _then;

/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? enabled = null,Object? fieldDefinitions = null,Object? cardLayout = null,Object? detailLayout = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as L10nText,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,fieldDefinitions: null == fieldDefinitions ? _self.fieldDefinitions : fieldDefinitions // ignore: cast_nullable_to_non_nullable
as List<FieldDefinition>,cardLayout: null == cardLayout ? _self.cardLayout : cardLayout // ignore: cast_nullable_to_non_nullable
as CardLayout,detailLayout: null == detailLayout ? _self.detailLayout : detailLayout // ignore: cast_nullable_to_non_nullable
as DetailLayout,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SectionItem>,
  ));
}
/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardLayoutCopyWith<$Res> get cardLayout {
  
  return $CardLayoutCopyWith<$Res>(_self.cardLayout, (value) {
    return _then(_self.copyWith(cardLayout: value));
  });
}/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailLayoutCopyWith<$Res> get detailLayout {
  
  return $DetailLayoutCopyWith<$Res>(_self.detailLayout, (value) {
    return _then(_self.copyWith(detailLayout: value));
  });
}
}


/// Adds pattern-matching-related methods to [PortfolioSection].
extension PortfolioSectionPatterns on PortfolioSection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioSection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioSection value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioSection():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioSection value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioSection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug, @L10nTextConverter()  L10nText title,  bool enabled,  List<FieldDefinition> fieldDefinitions,  CardLayout cardLayout,  DetailLayout detailLayout,  List<SectionItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioSection() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.enabled,_that.fieldDefinitions,_that.cardLayout,_that.detailLayout,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug, @L10nTextConverter()  L10nText title,  bool enabled,  List<FieldDefinition> fieldDefinitions,  CardLayout cardLayout,  DetailLayout detailLayout,  List<SectionItem> items)  $default,) {final _that = this;
switch (_that) {
case _PortfolioSection():
return $default(_that.id,_that.slug,_that.title,_that.enabled,_that.fieldDefinitions,_that.cardLayout,_that.detailLayout,_that.items);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug, @L10nTextConverter()  L10nText title,  bool enabled,  List<FieldDefinition> fieldDefinitions,  CardLayout cardLayout,  DetailLayout detailLayout,  List<SectionItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioSection() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.enabled,_that.fieldDefinitions,_that.cardLayout,_that.detailLayout,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioSection implements PortfolioSection {
  const _PortfolioSection({required this.id, required this.slug, @L10nTextConverter() required this.title, this.enabled = true, final  List<FieldDefinition> fieldDefinitions = const [], required this.cardLayout, required this.detailLayout, final  List<SectionItem> items = const []}): _fieldDefinitions = fieldDefinitions,_items = items;
  factory _PortfolioSection.fromJson(Map<String, dynamic> json) => _$PortfolioSectionFromJson(json);

@override final  String id;
@override final  String slug;
@override@L10nTextConverter() final  L10nText title;
@override@JsonKey() final  bool enabled;
 final  List<FieldDefinition> _fieldDefinitions;
@override@JsonKey() List<FieldDefinition> get fieldDefinitions {
  if (_fieldDefinitions is EqualUnmodifiableListView) return _fieldDefinitions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fieldDefinitions);
}

@override final  CardLayout cardLayout;
@override final  DetailLayout detailLayout;
 final  List<SectionItem> _items;
@override@JsonKey() List<SectionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioSectionCopyWith<_PortfolioSection> get copyWith => __$PortfolioSectionCopyWithImpl<_PortfolioSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioSection&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._fieldDefinitions, _fieldDefinitions)&&(identical(other.cardLayout, cardLayout) || other.cardLayout == cardLayout)&&(identical(other.detailLayout, detailLayout) || other.detailLayout == detailLayout)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,enabled,const DeepCollectionEquality().hash(_fieldDefinitions),cardLayout,detailLayout,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PortfolioSection(id: $id, slug: $slug, title: $title, enabled: $enabled, fieldDefinitions: $fieldDefinitions, cardLayout: $cardLayout, detailLayout: $detailLayout, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PortfolioSectionCopyWith<$Res> implements $PortfolioSectionCopyWith<$Res> {
  factory _$PortfolioSectionCopyWith(_PortfolioSection value, $Res Function(_PortfolioSection) _then) = __$PortfolioSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug,@L10nTextConverter() L10nText title, bool enabled, List<FieldDefinition> fieldDefinitions, CardLayout cardLayout, DetailLayout detailLayout, List<SectionItem> items
});


@override $CardLayoutCopyWith<$Res> get cardLayout;@override $DetailLayoutCopyWith<$Res> get detailLayout;

}
/// @nodoc
class __$PortfolioSectionCopyWithImpl<$Res>
    implements _$PortfolioSectionCopyWith<$Res> {
  __$PortfolioSectionCopyWithImpl(this._self, this._then);

  final _PortfolioSection _self;
  final $Res Function(_PortfolioSection) _then;

/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? enabled = null,Object? fieldDefinitions = null,Object? cardLayout = null,Object? detailLayout = null,Object? items = null,}) {
  return _then(_PortfolioSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as L10nText,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,fieldDefinitions: null == fieldDefinitions ? _self._fieldDefinitions : fieldDefinitions // ignore: cast_nullable_to_non_nullable
as List<FieldDefinition>,cardLayout: null == cardLayout ? _self.cardLayout : cardLayout // ignore: cast_nullable_to_non_nullable
as CardLayout,detailLayout: null == detailLayout ? _self.detailLayout : detailLayout // ignore: cast_nullable_to_non_nullable
as DetailLayout,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SectionItem>,
  ));
}

/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardLayoutCopyWith<$Res> get cardLayout {
  
  return $CardLayoutCopyWith<$Res>(_self.cardLayout, (value) {
    return _then(_self.copyWith(cardLayout: value));
  });
}/// Create a copy of PortfolioSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailLayoutCopyWith<$Res> get detailLayout {
  
  return $DetailLayoutCopyWith<$Res>(_self.detailLayout, (value) {
    return _then(_self.copyWith(detailLayout: value));
  });
}
}


/// @nodoc
mixin _$SectionItem {

 String get id; bool get enabled; Map<String, Object?> get fields;
/// Create a copy of SectionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionItemCopyWith<SectionItem> get copyWith => _$SectionItemCopyWithImpl<SectionItem>(this as SectionItem, _$identity);

  /// Serializes this SectionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.fields, fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,enabled,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'SectionItem(id: $id, enabled: $enabled, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $SectionItemCopyWith<$Res>  {
  factory $SectionItemCopyWith(SectionItem value, $Res Function(SectionItem) _then) = _$SectionItemCopyWithImpl;
@useResult
$Res call({
 String id, bool enabled, Map<String, Object?> fields
});




}
/// @nodoc
class _$SectionItemCopyWithImpl<$Res>
    implements $SectionItemCopyWith<$Res> {
  _$SectionItemCopyWithImpl(this._self, this._then);

  final SectionItem _self;
  final $Res Function(SectionItem) _then;

/// Create a copy of SectionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? enabled = null,Object? fields = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionItem].
extension SectionItemPatterns on SectionItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionItem value)  $default,){
final _that = this;
switch (_that) {
case _SectionItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionItem value)?  $default,){
final _that = this;
switch (_that) {
case _SectionItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool enabled,  Map<String, Object?> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionItem() when $default != null:
return $default(_that.id,_that.enabled,_that.fields);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool enabled,  Map<String, Object?> fields)  $default,) {final _that = this;
switch (_that) {
case _SectionItem():
return $default(_that.id,_that.enabled,_that.fields);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool enabled,  Map<String, Object?> fields)?  $default,) {final _that = this;
switch (_that) {
case _SectionItem() when $default != null:
return $default(_that.id,_that.enabled,_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionItem implements SectionItem {
  const _SectionItem({required this.id, this.enabled = true, final  Map<String, Object?> fields = const <String, Object?>{}}): _fields = fields;
  factory _SectionItem.fromJson(Map<String, dynamic> json) => _$SectionItemFromJson(json);

@override final  String id;
@override@JsonKey() final  bool enabled;
 final  Map<String, Object?> _fields;
@override@JsonKey() Map<String, Object?> get fields {
  if (_fields is EqualUnmodifiableMapView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fields);
}


/// Create a copy of SectionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionItemCopyWith<_SectionItem> get copyWith => __$SectionItemCopyWithImpl<_SectionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,enabled,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'SectionItem(id: $id, enabled: $enabled, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$SectionItemCopyWith<$Res> implements $SectionItemCopyWith<$Res> {
  factory _$SectionItemCopyWith(_SectionItem value, $Res Function(_SectionItem) _then) = __$SectionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, bool enabled, Map<String, Object?> fields
});




}
/// @nodoc
class __$SectionItemCopyWithImpl<$Res>
    implements _$SectionItemCopyWith<$Res> {
  __$SectionItemCopyWithImpl(this._self, this._then);

  final _SectionItem _self;
  final $Res Function(_SectionItem) _then;

/// Create a copy of SectionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? enabled = null,Object? fields = null,}) {
  return _then(_SectionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
