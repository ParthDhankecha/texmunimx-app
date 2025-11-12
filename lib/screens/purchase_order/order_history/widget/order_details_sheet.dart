import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/models/order_history_response.dart';
import 'package:texmunimx/screens/purchase_order/order_history/widget/build_job_users_table.dart';
import 'package:texmunimx/screens/purchase_order/order_history/widget/build_matchings_table.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';
// Import your models and AppColors/extension file here

class OrderHistoryDetailsSheet extends StatelessWidget {
  final OrderHistory order;

  const OrderHistoryDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final details = order.remarksDetails;

    return DraggableScrollableSheet(
      initialChildSize: 0.8, // Start at 80% height
      minChildSize: 0.5,
      maxChildSize: 0.95, // Maximize to near full height
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle and Title
              _buildHandle(context),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      'order_history'.tr,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // --- General History Info (Matching the Card) ---
                    _buildHistorySection(
                      title: 'updated_at'.tr,
                      value: order.eventDate.toLocal().ddMMyyyyhhmmssa,
                      context: context,
                    ),
                    _buildHistorySection(
                      title: 'user'.tr,
                      value: order.userId.capitalizeFirst!,
                      context: context,
                    ),
                    _buildHistorySection(
                      title: 'moved_by'.tr,
                      value: order.movedBy.capitalizeFirst!,
                      context: context,
                    ),

                    const SizedBox(height: 10),
                    // --- Details Section ---
                    if (details != null) ...[
                      // --- Matchings Table ---
                      Text(
                        'Matchings',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BuildMatchingsTable(matchings: details.matchings ?? []),
                      const SizedBox(height: 20),

                      // --- Job Users Table (if applicable) ---
                      if (details.jobUser != null &&
                          details.jobUser!.isNotEmpty) ...[
                        Text(
                          'Job Users',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Note: JobUser structure is dynamic in your model.
                        // Assuming it's a list of maps that we can display in a table.
                        BuildJobUsersTable(jobUsers: details.jobUser!),
                        const SizedBox(height: 20),
                      ],
                    ] else ...[
                      // Fallback if details couldn't be parsed
                      SizedBox.shrink(),
                    ],

                    // --- Raw Remarks (if not parsed as object) ---
                    if (order.remarks is String &&
                        order.remarks.toString().isNotEmpty)
                      _buildHistorySection(
                        title: 'Remarks',
                        value: order.remarks.toString(),
                        context: context,
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildHandle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHistorySection({
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Fixed width for titles
            child: Text(
              '$title:',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
