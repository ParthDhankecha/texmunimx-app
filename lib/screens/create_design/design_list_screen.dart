import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/screens/create_design/widgets/design_grid_card.dart';
import 'package:textile_po/screens/create_design/widgets/search_design_appbar.dart';

class DesignListScreen extends StatefulWidget {
  const DesignListScreen({super.key});

  @override
  State<DesignListScreen> createState() => _DesignListScreenState();
}

class _DesignListScreenState extends State<DesignListScreen> {
  CreateDesignController controller = Get.find<CreateDesignController>();
  final ScrollController _scrollController = ScrollController();
  final RxBool isLoadMoreVisible = false.obs;

  @override
  void initState() {
    super.initState();
    controller.getDesignList(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (controller.hasMore.value) {
        isLoadMoreVisible.value = true;
      } else {
        isLoadMoreVisible.value = false;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchDesignAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.designList.isEmpty
            ? const Center(child: Text('No designs found.'))
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two items per row
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio:
                                0.8, // Adjust as needed to fit the content
                          ),
                      itemCount: controller.designList.length,
                      itemBuilder: (context, index) {
                        var design = controller.designList[index];
                        return DesignCard(design: design);
                      },
                    ),
                  ),
                  if (controller.hasMore.value && isLoadMoreVisible.value)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => controller.nextPage(),
                          child: Text(
                            controller.isLoading.value
                                ? 'Loading...'
                                : 'Load More',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
