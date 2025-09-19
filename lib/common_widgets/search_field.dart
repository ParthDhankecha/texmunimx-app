import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.textInputType,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final Function(String searchText)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 8),
      decoration: BoxDecoration(
        color: Color(0xffF9F9FA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_outlined, color: Colors.grey),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: textEditingController,
              keyboardType: textInputType,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
