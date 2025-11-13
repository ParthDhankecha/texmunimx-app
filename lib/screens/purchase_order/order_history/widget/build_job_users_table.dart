import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/models/order_history_response.dart';

class BuildJobUsersTable extends StatefulWidget {
  final List<HistoryJobUserModel> jobUsers;

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

  Widget _buildJobUsersTable(List<HistoryJobUserModel> jobUsers) {
    const userFlex = 1;
    const firmFlex = 2;
    const qtyFlex = 1;
    const pendingQtyFlex = 1;
    const matchingFlex = 2;

    Widget buildHeaderRow() {
      return Row(
        children: [
          buildCell(
            'user'.tr,
            flex: userFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'firm'.tr,
            flex: firmFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'qty'.tr,
            flex: qtyFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          buildCell(
            'pending'.tr,
            flex: pendingQtyFlex,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.grey.shade300,
            alignment: Alignment.center,
          ),
          if (jobUsers.any((j) => j.matchingNo.isNotEmpty))
            buildCell(
              'matching'.tr,
              flex: matchingFlex,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.grey.shade300,
              alignment: Alignment.center,
            ),
        ],
      );
    }

    List<Widget> buildDataRows() {
      return jobUsers.map((j) {
        final matchingNo = j.matchingNo;
        final quantity = j.quantity;
        final pending = j.pending;
        final userId = j.userId;
        final firmId = j.firmId;

        return Row(
          children: [
            buildCell(userId, flex: userFlex, alignment: Alignment.center),
            buildCell(firmId, flex: firmFlex, alignment: Alignment.center),
            buildCell('$quantity', flex: qtyFlex, alignment: Alignment.center),
            buildCell(
              '$pending',
              flex: pendingQtyFlex,
              alignment: Alignment.center,
            ),
            if (matchingNo.isNotEmpty)
              buildCell(
                matchingNo,
                flex: matchingFlex,
                alignment: Alignment.center,
              ),
          ],
        );
      }).toList();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buildHeaderRow(), ...buildDataRows()],
      ),
    );
  }
}
