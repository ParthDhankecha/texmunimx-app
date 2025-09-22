import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/party_controller.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/screens/party/create_party.dart';
import 'package:textile_po/screens/party/widgets/party_card.dart';
import 'package:textile_po/screens/party/widgets/search_party_appbar.dart';

class PartyListScreen extends StatefulWidget {
  final bool openForSelect;
  const PartyListScreen({super.key, this.openForSelect = false});

  @override
  State<PartyListScreen> createState() => _PartyListScreenState();
}

class _PartyListScreenState extends State<PartyListScreen> {
  PartyController controller = Get.find<PartyController>();

  @override
  void initState() {
    super.initState();
    controller.getPartyList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPartyAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.partyList.length,
          itemBuilder: (context, index) {
            final party = controller.partyList[index];
            return PartyCard(
              party: party,
              onPartySelect: () {
                if (widget.openForSelect) {
                  Get.find<PurchaseOrderController>().selectParty(party);
                  Get.back();
                } else {
                  Get.to(() => CreatePartyScreen(partyModel: party));
                }
              },
            );
          },
        );
      }),
    );
  }
}
