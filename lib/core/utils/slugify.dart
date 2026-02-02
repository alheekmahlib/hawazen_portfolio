String slugify(String input) {
  final lower = input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return lower.isEmpty ? 'item' : lower;
}

String ensureUniqueSlug(String base, Iterable<String> existing) {
  if (!existing.contains(base)) return base;
  var i = 2;
  while (existing.contains('$base-$i')) {
    i++;
  }
  return '$base-$i';
}
