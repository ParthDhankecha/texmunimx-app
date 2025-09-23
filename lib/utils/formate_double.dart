String formatDouble(double value) {
  if (value == value.toInt()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2);
}
