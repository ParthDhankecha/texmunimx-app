import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/models/order_history_response.dart';

const matchingFlex = 1;
const rateFlex = 1;

const quantityFlex = 1;

const pendingQtyFlex = 1;

///matchings table
class BuildMatchingsTable extends StatefulWidget {
  final List<Matching> matchings;

  const BuildMatchingsTable({super.key, required this.matchings});

  @override
  State<BuildMatchingsTable> createState() => _BuildMatchingsTableState();
}

class _BuildMatchingsTableState extends State<BuildMatchingsTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Ensures Column takes full width
        children: [_buildHeaderRow(), ..._buildDataRows()],
      ),
    );
  }

  // Header Titles
  final headers = [
    {'title': 'matching'.tr, 'flex': matchingFlex, 'align': Alignment.center},
    {'title': 'rate'.tr, 'flex': rateFlex, 'align': Alignment.center},
    {'title': 'quantity'.tr, 'flex': quantityFlex, 'align': Alignment.center},
    {
      'title': 'pending_qty'.tr,
      'flex': pendingQtyFlex,
      'align': Alignment.center,
    },
  ];

  // Helper to build the header row
  Widget _buildHeaderRow() {
    return Row(
      children: headers.map((header) {
        return _buildCell(
          header['title'] as String,
          flex: header['flex'] as int,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.grey.shade300,
          alignment: header['align'] as Alignment,
        );
      }).toList(),
    );
  }

  // List of data rows
  List<Widget> _buildDataRows() {
    return widget.matchings.map((m) {
      return Row(
        children: [
          // Matching Label
          _buildCell(
            m.mLabel ?? 'N/A',
            flex: matchingFlex,
            alignment: Alignment.center,
          ),
          // Rate (Right aligned)
          _buildCell('${m.rate}', flex: rateFlex, alignment: Alignment.center),
          // Quantity (Right aligned)
          _buildCell(
            '${m.quantity}',
            flex: quantityFlex,
            alignment: Alignment.center,
          ),
          // Pending Qty (Right aligned)
          _buildCell(
            '${m.pending}',
            flex: pendingQtyFlex,
            alignment: Alignment.center,
          ),
        ],
      );
    }).toList();
  }

  Widget _buildCell(
    String text, {
    required int flex,
    FontWeight fontWeight = FontWeight.normal,
    Color backgroundColor = Colors.white,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: .0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey.shade600, width: 0.5),
        ),
        alignment: alignment,
        child: Text(
          text,
          style: TextStyle(fontWeight: fontWeight, fontSize: 12),
          textAlign: alignment == Alignment.center
              ? TextAlign.center
              : alignment == Alignment.centerRight
              ? TextAlign.right
              : TextAlign.left,
        ),
      ),
    );
  }
}
