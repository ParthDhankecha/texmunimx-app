import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/models/party_list_response.dart';
import 'package:textile_po/screens/party/create_party.dart';

class PartyCard extends StatelessWidget {
  const PartyCard({super.key, required this.party});

  final PartyModel party;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => CreatePartyScreen(partyModel: party));
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 8,
            right: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // You can use a real image for a logo here
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.partyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRow('Party No', party.partyNumber, Icons.numbers),
                    const SizedBox(height: 8),
                    if ((party.gstNo ?? '').isNotEmpty)
                      _buildRow(
                        'GST :',
                        party.gstNo ?? 'N/A',
                        Icons.article_outlined,
                      ),

                    const SizedBox(height: 8),
                    if ((party.mobile ?? '').isNotEmpty)
                      _buildRow(
                        'Mobile',
                        party.mobile ?? '',
                        Icons.call_outlined,
                      ),
                    const SizedBox(height: 8),

                    if ((party.email ?? '').isNotEmpty)
                      _buildRow(
                        'Email',
                        party.email ?? 'N/A',
                        Icons.email_outlined,
                      ),

                    const SizedBox(height: 8),
                    if ((party.brokerName ?? '').isNotEmpty)
                      _buildRow(
                        'Broker Name',
                        party.brokerName ?? '',
                        Icons.person_outline,
                      ),
                    const SizedBox(height: 8),
                    if ((party.address ?? '').isNotEmpty)
                      _buildRow(
                        'Address',
                        party.address ?? '',
                        Icons.location_pin,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, IconData? icon) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: Colors.grey),
        if (icon != null) SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.black)),
        SizedBox(width: 10),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
