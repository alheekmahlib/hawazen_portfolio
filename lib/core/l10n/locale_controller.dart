import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app.locale';

class LocaleController extends GetxController {
  final Rx<Locale> locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    locale.value = code == null ? const Locale('en') : Locale(code);
    update();
  }

  Future<void> setLocale(Locale next) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, next.languageCode);
    locale.value = next;
    update();
  }
}
