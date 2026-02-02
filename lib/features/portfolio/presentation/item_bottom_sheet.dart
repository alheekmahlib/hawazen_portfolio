import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/glass_container.dart';
import '../../content/domain/portfolio_models.dart';

class ItemBottomSheet extends StatelessWidget {
  const ItemBottomSheet({
    super.key,
    required this.section,
    required this.item,
    required this.localeCode,
  });

  final PortfolioSection section;
  final SectionItem item;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final layout = section.detailLayout;
    final title = _fieldText(layout.titleField);
    final subtitle = layout.subtitleField == null
        ? null
        : _fieldText(layout.subtitleField!);
    final mediaUrl = layout.mediaField == null
        ? null
        : _fieldString(layout.mediaField!);

    final gallery = layout.galleryField == null
        ? const <String>[]
        : _fieldStringList(layout.galleryField!);

    final actions = layout.actionFields
        .map((k) => MapEntry(k, _fieldString(k)))
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .toList();

    final bodyFields = layout.bodyFields;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: GlassContainer(
              padding: const EdgeInsets.all(18),
              borderRadius: const BorderRadius.all(Radius.circular(28)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              if (subtitle != null &&
                                  subtitle.trim().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    if (mediaUrl != null && mediaUrl.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 7,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                mediaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.white10,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withAlpha(170),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (gallery.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _GalleryStrip(images: gallery),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final a in actions)
                            FilledButton.tonalIcon(
                              onPressed: () => _launch(a.value!),
                              icon: const Icon(Icons.open_in_new),
                              label: Text(_labelFor(a.key)),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    for (final key in bodyFields) ...[
                      _FieldBlock(
                        label: _labelFor(key),
                        child: _fieldWidget(context, key),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _labelFor(String key) {
    final def = section.fieldDefinitions.where((d) => d.key == key).firstOrNull;
    return def == null ? key : def.label.resolve(localeCode);
  }

  Widget _fieldWidget(BuildContext context, String key) {
    final def = section.fieldDefinitions.where((d) => d.key == key).firstOrNull;
    final value = item.fields[key];
    if (def == null || value == null) return const SizedBox.shrink();

    switch (def.type) {
      case FieldType.markdown:
        final text = _asLocalizedOrString(def, value);
        return MarkdownBody(
          data: text,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.7,
            ),
            a: const TextStyle(color: Color(0xFF22D3EE)),
            codeblockDecoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withAlpha(18)),
            ),
          ),
        );
      case FieldType.image:
        final images = def.multiple
            ? _fieldStringList(key)
            : <String>[_fieldString(key) ?? ''];
        final filtered = images.where((e) => e.trim().isNotEmpty).toList();
        if (filtered.isEmpty) return const SizedBox.shrink();
        return _GalleryStrip(images: filtered);
      case FieldType.link:
        final url = _fieldString(key);
        if (url == null || url.isEmpty) return const SizedBox.shrink();
        return OutlinedButton.icon(
          onPressed: () => _launch(url),
          icon: const Icon(Icons.link),
          label: Text(url),
        );
      case FieldType.tagList:
        final tags = (value is List)
            ? value.map((e) => e.toString()).toList()
            : value
                  .toString()
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in tags)
              Chip(label: Text(t), backgroundColor: Colors.white.withAlpha(18)),
          ],
        );
      case FieldType.boolean:
      case FieldType.number:
      case FieldType.date:
      case FieldType.string:
        final text = _asLocalizedOrString(def, value);
        return Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        );
    }
  }

  String _fieldText(String key) {
    final def = section.fieldDefinitions.where((d) => d.key == key).firstOrNull;
    final value = item.fields[key];
    if (def == null || value == null) return '';
    return _asLocalizedOrString(def, value);
  }

  String _asLocalizedOrString(FieldDefinition def, Object? value) {
    if (!def.localized) return value?.toString() ?? '';
    if (value is Map) {
      final map = value
          .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
          .cast<String, String>();
      return L10nText(map).resolve(localeCode);
    }
    return value?.toString() ?? '';
  }

  String? _fieldString(String key) {
    final v = item.fields[key];
    if (v == null) return null;
    return v.toString();
  }

  List<String> _fieldStringList(String key) {
    final v = item.fields[key];
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v == null) return const [];
    final s = v.toString();
    if (s.isEmpty) return const [];
    return [s];
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final url = images[index];
          return InkWell(
            onTap: () => _open(context, images, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white10,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _open(BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (_) {
        final controller = PageController(initialPage: initialIndex);
        var currentIndex = initialIndex;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              backgroundColor: Colors.black,
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    itemCount: images.length,
                    pageController: controller,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(images[index]),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: currentIndex > 0
                            ? () => controller.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              )
                            : null,
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                        tooltip: 'Previous',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: currentIndex < images.length - 1
                            ? () => controller.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              )
                            : null,
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                        tooltip: 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
