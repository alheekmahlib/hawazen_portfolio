import 'package:flutter/widgets.dart';

class AppStrings {
  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const defaultLocale = Locale('en');

  static const _strings = <String, Map<String, String>>{
    'en': {
      'nav.home': 'Home',
      'nav.contact': 'Contact',
      'nav.admin': 'Admin',
      'common.loading': 'Loading…',
      'common.retry': 'Retry',
      'common.save': 'Save',
      'common.cancel': 'Cancel',
      'common.add': 'Add',
      'common.delete': 'Delete',
      'common.export': 'Export JSON',
      'common.import': 'Import JSON',
      'common.preview': 'Preview',
      'admin.contentUrl': 'Content URL (GitHub raw)',
      'admin.reload': 'Reload',
      'admin.addSection': 'Add section',
      'admin.sections': 'Sections',
      'admin.items': 'Items',
      'admin.itemsHelp':
          'Add an item, then click Edit to enter text and paste image/link URLs in the fields below.',
      'admin.addItem': 'Add item',
      'admin.sectionSlug': 'Section slug',
      'admin.sectionTitleEn': 'Title (EN)',
      'admin.sectionTitleAr': 'Title (AR)',
      'admin.sectionEnabled': 'Enabled',
      'admin.fields': 'Fields',
      'admin.cardLayout': 'Card layout',
      'admin.detailLayout': 'Detail layout',
      'admin.titleField': 'Title field',
      'admin.subtitleField': 'Subtitle field',
      'admin.mediaField': 'Media field',
      'admin.galleryField': 'Gallery field',
      'admin.bodyFields': 'Body fields',
      'admin.actionFields': 'Action link fields',
      'admin.addAppGalleryField': 'Add AppGallery link',
      'admin.addMacAppStoreField': 'Add Mac App Store link',
      'errors.notFound': 'Not found',
    },
    'ar': {
      'nav.home': 'الرئيسية',
      'nav.contact': 'تواصل معنا',
      'nav.admin': 'لوحة التحكم',
      'common.loading': 'جارٍ التحميل…',
      'common.retry': 'إعادة المحاولة',
      'common.save': 'حفظ',
      'common.cancel': 'إلغاء',
      'common.add': 'إضافة',
      'common.delete': 'حذف',
      'common.export': 'تصدير JSON',
      'common.import': 'استيراد JSON',
      'common.preview': 'معاينة',
      'admin.contentUrl': 'رابط المحتوى (GitHub raw)',
      'admin.reload': 'تحديث',
      'admin.addSection': 'إضافة قسم',
      'admin.sections': 'الأقسام',
      'admin.items': 'العناصر',
      'admin.itemsHelp':
          'أضِف عنصرًا ثم اضغط تحرير لإدخال النصوص ولصق روابط الصور/التحميل داخل الحقول.',
      'admin.addItem': 'إضافة عنصر',
      'admin.sectionSlug': 'Slug القسم',
      'admin.sectionTitleEn': 'العنوان (EN)',
      'admin.sectionTitleAr': 'العنوان (AR)',
      'admin.sectionEnabled': 'مفعل',
      'admin.fields': 'الحقول',
      'admin.cardLayout': 'تخطيط الكارد',
      'admin.detailLayout': 'تخطيط التفاصيل',
      'admin.titleField': 'حقل العنوان',
      'admin.subtitleField': 'حقل العنوان الفرعي',
      'admin.mediaField': 'حقل الصورة',
      'admin.galleryField': 'حقل المعرض',
      'admin.bodyFields': 'حقول المحتوى',
      'admin.actionFields': 'حقول الروابط',
      'admin.addAppGalleryField': 'إضافة رابط AppGallery',
      'admin.addMacAppStoreField': 'إضافة رابط Mac App Store',
      'errors.notFound': 'غير موجود',
    },
  };

  static String tr(Locale locale, String key) {
    final lang = locale.languageCode;
    return _strings[lang]?[key] ?? _strings['en']?[key] ?? key;
  }
}
