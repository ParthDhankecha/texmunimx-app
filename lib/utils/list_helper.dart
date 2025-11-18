extension ListStringExtensions on List<String> {
  String toNonNullString([String separator = ', ']) {
    return where((element) => element.trim().isNotEmpty)
        // 2. Capitalize the first letter of each remaining element.
        .map((e) {
          final trimmed = e.trim();
          // Ensure non-empty (should be true due to where()), then capitalize:
          if (trimmed.isEmpty) return '';

          // Capitalize the first character and lowercase the rest for consistency
          return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
        })
        // 3. Join the elements using the specified separator.
        .join(separator);
  }
}
