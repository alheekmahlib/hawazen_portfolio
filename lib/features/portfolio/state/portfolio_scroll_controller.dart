import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioScrollController extends GetxController {
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};
  ScrollController? _scrollController;
  final RxString activeSlug = ''.obs;

  void attachScrollController(ScrollController controller) {
    _scrollController = controller;
  }

  void detachScrollController(ScrollController controller) {
    if (_scrollController == controller) {
      _scrollController = null;
    }
  }

  void registerSectionKey(String slug, GlobalKey key) {
    _sectionKeys[slug] = key;
  }

  void setActiveSlug(String slug) {
    if (activeSlug.value == slug) return;
    activeSlug.value = slug;
  }

  bool scrollToTop({Duration duration = const Duration(milliseconds: 550)}) {
    final c = _scrollController;
    if (c == null || !c.hasClients) return false;
    c.animateTo(0, duration: duration, curve: Curves.easeOutCubic);
    return true;
  }

  bool scrollToSection(
    String slug, {
    Duration duration = const Duration(milliseconds: 550),
    double alignment = 0.03,
  }) {
    final ctx = _sectionKeys[slug]?.currentContext;
    if (ctx == null) return false;

    Scrollable.ensureVisible(
      ctx,
      duration: duration,
      curve: Curves.easeOutCubic,
      alignment: alignment,
    );

    return true;
  }
}
