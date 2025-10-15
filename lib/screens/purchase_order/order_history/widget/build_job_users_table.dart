import 'package:flutter/material.dart';

class BuildJobUsersTable extends StatefulWidget {
  final List<dynamic> jobUsers;

  const BuildJobUsersTable({super.key, required this.jobUsers});

  @override
  State<BuildJobUsersTable> createState() => _BuildJobUsersTableState();
}

class _BuildJobUsersTableState extends State<BuildJobUsersTable> {
  @override
  Widget build(BuildContext context) {
    return _buildJobUsersTable(widget.jobUsers);
  }

  Widget buildCell(
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

  Widget _buildJobUsersTable(List<dynamic> jobUsers) {
    final List<Map<String, dynamic>> jobUserList = jobUsers
        .map((e) => e as Map<String, dynamic>)
        .toList();

    const userFlex = 1;
    const firmFlex = 2;
    const qtyFlex = 1;
    const pendingQtyFlex = 1;
    const matchingFlex = 2;

    Widget buildHeaderRow() {
      return Row(
        children: [
          buildCell(
            'User',
            flex: userFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'Firm',
            flex: firmFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'Qty',
            flex: qtyFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'Pending',
            flex: pendingQtyFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'Matching',
            flex: matchingFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
        ],
      );
    }

    List<Widget> buildDataRows() {
      return jobUserList.map((j) {
        // This is a rough mapping based on the screenshot, adjust keys if needed
        final matchingNo = j['matchingNo'] ?? '';
        final quantity = j['quantity'] ?? 0;
        final pending = j['pending'] ?? 0;
        final userId = j['userId'] ?? 'N/A';
        final firmId = j['firmId'] ?? 'N/A';

        // You'll likely need an extra API call or pre-loaded data to get User Name and Firm Name from their IDs.
        // For now, I'll use the IDs as placeholders.
        // Example: controller.getUserName(userId), controller.getFirmName(firmId)

        return Row(
          children: [
            buildCell(
              userId,
              flex: userFlex,
              alignment: Alignment.center,
            ), // Placeholder
            buildCell(
              firmId,
              flex: firmFlex,
              alignment: Alignment.center,
            ), // Placeholder
            buildCell('$quantity', flex: qtyFlex, alignment: Alignment.center),
            buildCell(
              '$pending',
              flex: pendingQtyFlex,
              alignment: Alignment.center,
            ),
            buildCell(
              'Matching $matchingNo', // Placeholder
              flex: matchingFlex,
              alignment: Alignment.center,
            ),
          ],
        );
      }).toList();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Ensures Column takes full width
        children: [buildHeaderRow(), ...buildDataRows()],
      ),
    );
  }
}
