import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/domain/portfolio_models.dart';
import '../../content/state/content_controller.dart';
import '../state/portfolio_scroll_controller.dart';
import 'item_bottom_sheet.dart';
import 'portfolio_scaffold.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
    required this.sectionSlug,
    required this.itemId,
  });

  final String? sectionSlug;
  final String? itemId;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  late final ContentController _contentController;
  late final LocaleController _localeController;
  late final PortfolioScrollController _portfolioScroll;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};
  final GlobalKey _contactKey = GlobalKey();

  Worker? _contentWorker;
  String? _openedFor;
  String? _scrolledFor;

  @override
  void initState() {
    super.initState();
    _contentController = Get.find<ContentController>();
    _localeController = Get.find<LocaleController>();
    _portfolioScroll = Get.find<PortfolioScrollController>();
    _portfolioScroll.attachScrollController(_scrollController);
    _scrollController.addListener(_handleScroll);

    _contentWorker = ever<PortfolioContent?>(_contentController.content, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeScroll();
        _maybeOpen();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeScroll();
      _maybeOpen();
    });
  }

  @override
  void didUpdateWidget(covariant PortfolioPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sectionSlug != widget.sectionSlug) {
      _scrolledFor = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeScroll());
    }

    if (oldWidget.itemId != widget.itemId) {
      _openedFor = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
    }
  }

  @override
  void dispose() {
    _contentWorker?.dispose();
    _portfolioScroll.detachScrollController(_scrollController);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _keyForSlug(String slug) {
    final key = _sectionKeys.putIfAbsent(slug, () => GlobalKey());
    _portfolioScroll.registerSectionKey(slug, key);
    return key;
  }

  GlobalKey _keyForContact() {
    _portfolioScroll.registerSectionKey('contact', _contactKey);
    return _contactKey;
  }

  void _maybeScroll() {
    final slug = widget.sectionSlug;
    if (slug == null || slug.isEmpty) return;
    if (_scrolledFor == slug) return;

    final key = slug == 'contact' ? _contactKey : _sectionKeys[slug];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    _scrolledFor = slug;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      alignment: 0.03,
    );
  }

  void _maybeOpen() {
    final slug = widget.sectionSlug;
    final itemId = widget.itemId;

    if (slug == null || slug.isEmpty) return;
    if (itemId == null || itemId.isEmpty) return;
    if (_openedFor == '$slug/$itemId') return;

    final content = _contentController.content.value;
    if (content == null) return;

    final section = content.sections.where((s) => s.slug == slug).firstOrNull;
    if (section == null) return;

    final item = section.items.where((i) => i.id == itemId).firstOrNull;
    if (item == null) return;

    _openedFor = '$slug/$itemId';

    _maybeScroll();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final locale = _localeController.locale.value;
        return ItemBottomSheet(
          section: section,
          item: item,
          localeCode: locale.languageCode,
        );
      },
    ).whenComplete(() {
      if (!mounted) return;
      context.go('/$slug');
    });
  }

  void _handleScroll() {
    final content = _contentController.content.value;
    if (content == null) return;

    const threshold = 140.0;
    final candidates = <MapEntry<String, double>>[];

    for (final section in content.sections.where((s) => s.enabled)) {
      final dy = _sectionTop(section.slug);
      if (dy != null) {
        candidates.add(MapEntry(section.slug, dy));
      }
    }

    final contactDy = _sectionTop('contact');
    if (contactDy != null) {
      candidates.add(MapEntry('contact', contactDy));
    }

    final above = candidates.where((e) => e.value <= threshold).toList();
    if (above.isEmpty) {
      _portfolioScroll.setActiveSlug('');
      return;
    }

    above.sort((a, b) => a.value.compareTo(b.value));
    _portfolioScroll.setActiveSlug(above.last.key);
  }

  double? _sectionTop(String slug) {
    final key = slug == 'contact' ? _contactKey : _sectionKeys[slug];
    if (key == null) return null;
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    final offset = box.localToGlobal(Offset.zero);
    return offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      child: Obx(() {
        final locale = _localeController.locale.value;
        final content = _contentController.content.value;
        final isLoading = _contentController.loading.value;
        final error = _contentController.error.value;

        if (content == null) {
          if (isLoading) {
            return Center(child: Text(AppStrings.tr(locale, 'common.loading')));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (error != null) Text(error),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _contentController.forceReload,
                  child: Text(AppStrings.tr(locale, 'common.retry')),
                ),
              ],
            ),
          );
        }

        final sections = content.sections.where((s) => s.enabled).toList();

        final name = content.site.name?.resolve(locale.languageCode) ?? '';
        final role = content.site.role?.resolve(locale.languageCode) ?? '';
        final subtitle =
            content.site.subtitle?.resolve(locale.languageCode) ?? '';
        final bio = content.site.bio?.resolve(locale.languageCode) ?? '';

        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Hero(
                    name: name,
                    role: role,
                    subtitle: subtitle,
                    bio: bio,
                    localeCode: locale.languageCode,
                    sections: sections,
                  ),
                  const SizedBox(height: 18),
                  for (final section in sections) ...[
                    _SectionBlock(
                      key: _keyForSlug(section.slug),
                      section: section,
                      localeCode: locale.languageCode,
                      onItemTap: (itemId) =>
                          context.go('/${section.slug}/$itemId'),
                    ),
                    const SizedBox(height: 18),
                  ],
                  _ContactSection(key: _keyForContact(), locale: locale),
                  const SizedBox(height: 18),
                  _Footer(locale: locale, sections: sections),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.name,
    required this.role,
    required this.subtitle,
    required this.bio,
    required this.localeCode,
    required this.sections,
  });

  final String name;
  final String role;
  final String subtitle;
  final String bio;
  final String localeCode;
  final List<PortfolioSection> sections;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final hero = GlassContainer(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GradientText(
            text: name,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(height: 1.05),
          ),
          const SizedBox(height: 12),
          Text(
            role,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white.withAlpha(220),
              height: 1.2,
            ),
          ),
          if (subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
          if (bio.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              bio,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.7,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in sections)
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.go('/${s.slug}');
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(s.title.resolve(localeCode)),
                ),
              OutlinedButton.icon(
                onPressed: () => context.go('/contact'),
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(
                  AppStrings.tr(Localizations.localeOf(context), 'nav.contact'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [hero, const SizedBox(height: 14), const _SocialBlock()],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: hero),
        const SizedBox(width: 14),
        const SizedBox(width: 360, child: _SocialBlock()),
      ],
    );
  }
}

class _SocialBlock extends StatelessWidget {
  const _SocialBlock();

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();

    return Obx(() {
      final content = contentController.content.value;
      if (content == null) return const SizedBox.shrink();

      return GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Links',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final s in content.site.social)
                  OutlinedButton.icon(
                    onPressed: () => _launch(s.url),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(s.label),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key, required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final content = contentController.content.value;
    if (content == null) return const SizedBox.shrink();

    final c = content.site.contact;
    final hasAny = c.email != null || c.phone != null || c.whatsapp != null;
    if (!hasAny) return const SizedBox.shrink();

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.tr(locale, 'nav.contact'),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (c.email != null) _ContactRow(label: 'Email', value: c.email!),
          if (c.phone != null) _ContactRow(label: 'Phone', value: c.phone!),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (c.email != null)
                OutlinedButton.icon(
                  onPressed: () => _launch('mailto:${c.email}'),
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Email'),
                ),
              if (c.whatsapp != null)
                OutlinedButton.icon(
                  onPressed: () => _launch(c.whatsapp!),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('WhatsApp'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.locale, required this.sections});

  final Locale locale;
  final List<PortfolioSection> sections;

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final content = contentController.content.value;
    if (content == null) return const SizedBox.shrink();

    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final name = content.site.name?.resolve(locale.languageCode) ?? 'Portfolio';
    final role = content.site.role?.resolve(locale.languageCode) ?? '';
    final subtitle = content.site.subtitle?.resolve(locale.languageCode) ?? '';
    final c = content.site.contact;

    final year = DateTime.now().year;
    final rights = locale.languageCode == 'ar'
        ? '© $year $name — جميع الحقوق محفوظة'
        : '© $year $name — All rights reserved';
    final builtWith = locale.languageCode == 'ar'
        ? 'مبني بـ Flutter • محتوى مُدار عبر JSON'
        : 'Built with Flutter • Content managed via JSON';

    final about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        if (role.isNotEmpty)
          Text(
            role,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white60),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          builtWith,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.white60),
        ),
      ],
    );

    final links = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.languageCode == 'ar' ? 'روابط سريعة' : 'Quick links',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in sections)
              OutlinedButton(
                onPressed: () => context.go('/${s.slug}'),
                child: Text(s.title.resolve(locale.languageCode)),
              ),
            OutlinedButton(
              onPressed: () => context.go('/contact'),
              child: Text(AppStrings.tr(locale, 'nav.contact')),
            ),
          ],
        ),
      ],
    );

    final social = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.languageCode == 'ar' ? 'تواصل' : 'Connect',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in content.site.social)
              OutlinedButton.icon(
                onPressed: () => _launch(s.url),
                icon: const Icon(Icons.open_in_new),
                label: Text(s.label),
              ),
            if (c.email != null)
              OutlinedButton.icon(
                onPressed: () => _launch('mailto:${c.email}'),
                icon: const Icon(Icons.mail_outline),
                label: const Text('Email'),
              ),
            if (c.whatsapp != null)
              OutlinedButton.icon(
                onPressed: () => _launch(c.whatsapp!),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('WhatsApp'),
              ),
          ],
        ),
      ],
    );

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: about),
                const SizedBox(width: 18),
                Expanded(child: links),
                const SizedBox(width: 18),
                Expanded(child: social),
              ],
            )
          else ...[
            about,
            const SizedBox(height: 16),
            links,
            const SizedBox(height: 16),
            social,
          ],
          const SizedBox(height: 16),
          Divider(color: Colors.white.withAlpha(20)),
          const SizedBox(height: 10),
          Text(
            rights,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    super.key,
    required this.section,
    required this.localeCode,
    required this.onItemTap,
  });

  final PortfolioSection section;
  final String localeCode;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    final items = section.items.where((i) => i.enabled).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  section.title.resolve(localeCode),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withAlpha(12),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                child: Text(
                  '${items.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final crossAxisCount = w >= 1100
                ? 3
                : w >= 760
                ? 2
                : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 16 / 10.6,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _SectionItemCard(
                  section: section,
                  item: item,
                  localeCode: localeCode,
                  onTap: () => onItemTap(item.id),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _SectionItemCard extends StatelessWidget {
  const _SectionItemCard({
    required this.section,
    required this.item,
    required this.localeCode,
    required this.onTap,
  });

  final PortfolioSection section;
  final SectionItem item;
  final String localeCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final layout = section.cardLayout;
    final title = _fieldText(layout.titleField);
    final subtitle = layout.subtitleField == null
        ? null
        : _fieldText(layout.subtitleField!);
    final mediaUrl = layout.mediaField == null
        ? null
        : _fieldString(layout.mediaField!);

    final radius = BorderRadius.circular(26);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: radius,
        child: Stack(
          children: [
            if (mediaUrl != null && mediaUrl.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: radius,
                  child: Image.network(
                    mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withAlpha(210),
                      Colors.black.withAlpha(25),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: GlassContainer(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (subtitle != null && subtitle.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _plain(subtitle),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const _ArrowDot(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _plain(String s) {
    return s
        .replaceAll(RegExp(r'[#*_`>\\-]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _fieldText(String key) {
    final def = section.fieldDefinitions.where((d) => d.key == key).firstOrNull;
    final value = item.fields[key];
    if (def == null || value == null) return '';
    if (!def.localized) return value.toString();
    if (value is Map) {
      final map = value
          .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
          .cast<String, String>();
      return L10nText(map).resolve(localeCode);
    }
    return value.toString();
  }

  String? _fieldString(String key) {
    final v = item.fields[key];
    return v?.toString();
  }
}

class _ArrowDot extends StatelessWidget {
  const _ArrowDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.surface, AppTheme.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(90),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.displayMedium;
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ).createShader(bounds);
      },
      child: Text(text, style: effectiveStyle?.copyWith(color: Colors.white)),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
