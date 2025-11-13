import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';

/// A reusable, generic dropdown widget for any data type (T).
///
/// It requires an [itemLabelBuilder] function to specify which property
/// of the item (T) should be displayed as the label.
class CustomDropdown<T> extends StatelessWidget {
  final String title;
  final T? selectedValue;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final bool isEnabled;

  /// A required function that converts an item of type T into the String
  /// that should be displayed in the dropdown list.
  final String Function(T item) itemLabelBuilder;

  /// Optional text for the placeholder/initial value (e.g., "Select Group").
  final String placeholderText;

  const CustomDropdown({
    super.key,
    required this.title,
    this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.placeholderText = 'select', // Default placeholder text
    this.isRequired = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Create the list of items, prepended with a null entry for the placeholder.
    //final List<T?> dropdownItems = [null, ...items];
    final List<T?> dropdownItems = selectedValue == null
        ? [null, ...items]
        : items;

    // 2. Determine the initial value for the dropdown.
    final T? initialValue = dropdownItems.contains(selectedValue)
        ? selectedValue
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (isRequired)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: RedMark(),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<T?>(
            initialValue: initialValue,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            ),
            items: dropdownItems.map((T? value) {
              return DropdownMenuItem<T?>(
                value: value,
                // Use the placeholder text if the value is null,
                // otherwise use the provided itemLabelBuilder function.
                child: Text(
                  value == null ? placeholderText.tr : itemLabelBuilder(value),
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
