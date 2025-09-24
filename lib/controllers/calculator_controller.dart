import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/show_error_snackbar.dart';
import 'package:textile_po/models/cal_weft_model.dart';
import 'package:textile_po/models/design_list_response.dart';

class CalculatorController extends GetxController implements GetxService {
  Rx<DesignModel?> selectedDesign = Rx(null);

  DesignModel? get getDesign => selectedDesign.value;
  set setDesign(DesignModel? design) => selectedDesign.value = design;

  RxInt selectedTab = 0.obs;
  set setIndex(int index) => selectedTab.value = index;

  RxDouble warpCost = 0.0.obs;

  RxDouble denier = 0.0.obs;
  set setDenier(double d) => denier.value = d;

  RxDouble tar = 0.0.obs;
  set setTar(double t) => tar.value = t;

  RxDouble meter = 0.0.obs;
  set setMeter(double m) => meter.value = m;

  RxDouble ratePerKg = 0.0.obs;
  set setRatePerKg(double rate) => ratePerKg.value = rate;

  TextEditingController qualityCont = TextEditingController();
  TextEditingController denierCont = TextEditingController();
  TextEditingController tarCont = TextEditingController();
  TextEditingController meterCont = TextEditingController();
  TextEditingController ratePerKgCont = TextEditingController();

  //weft List
  RxList<CalWeftModel> weftList = RxList();
  RxDouble totalWeftCost = 0.0.obs;

  calculateWeft() {
    totalWeftCost.value = calculateTotalWeftCost(weftList);
  }

  generateDefaultBoxes() {
    var list = List.generate(
      4,
      (index) => CalWeftModel(id: index + 1, feeder: 'Feeder ${index + 1}'),
    );

    weftList.value = list;
  }

  addNewWeft() {
    int lastIndex = weftList.last.id;
    if (weftList.length < 12) {
      weftList.add(
        CalWeftModel(id: lastIndex + 1, feeder: 'Feeder ${weftList.length}'),
      );
    } else {
      showErrorSnackbar('Only 12 Feeders are Allowed');
    }
  }

  removeBox(int index) {
    if (weftList.length > 1) {
      weftList.removeAt(index);
    } else {
      showErrorSnackbar('One Feeder is required');
    }
  }

  double calculateWarpCost() {
    // Check for invalid inputs. If any value is null, NaN, or negative,
    // the calculation cannot be performed, so we return 0.0.
    if (denier.isNaN ||
        denier.isNegative ||
        tar.isNaN ||
        tar.isNegative ||
        meter.isNaN ||
        meter.isNegative ||
        ratePerKg.isNaN ||
        ratePerKg.isNegative) {
      return 0.0;
    }

    // Perform the warp consumption calculation.
    double weftConsumption =
        ((110 * tar.value * denier.value) / (900000 / 1100)) * meter.value;

    // Calculate the final warp cost.
    final double warpCostCal = weftConsumption * ratePerKg.value;
    warpCost.value = warpCostCal;
    return warpCostCal;
  }

  //function to calculate total weft cost

  double calculateTotalWeftCost(List<CalWeftModel> weftRows) {
    double totalWeftCost = 0.0;

    // Iterate over each model in the list
    for (final ctrl in weftRows) {
      // Check if the required values are valid (not null, not NaN, not negative)
      if (ctrl.denier != null &&
          !ctrl.denier!.isNaN &&
          !ctrl.denier!.isNegative &&
          ctrl.pick != null &&
          !ctrl.pick!.isNaN &&
          !ctrl.pick!.isNegative &&
          ctrl.panno != null &&
          !ctrl.panno!.isNaN &&
          !ctrl.panno!.isNegative &&
          ctrl.rate != null &&
          !ctrl.rate!.isNaN &&
          !ctrl.rate!.isNegative &&
          ctrl.meter != null &&
          !ctrl.meter!.isNaN &&
          !ctrl.meter!.isNegative) {
        // Since we know the values are not null at this point, we can use the `!` operator.
        final double denier = ctrl.denier!;
        final double pick = ctrl.pick!;
        final double panno = ctrl.panno!;
        final double rate = ctrl.rate!;
        final double meter = ctrl.meter!;

        // Calculate weft consumption based on the formula.
        final double weftConsumption =
            (((110 * panno * denier * pick) / 900000) / 1000) * meter;

        // Calculate the weft cost for the current row.
        final double weftCost = weftConsumption * rate;

        // Add the cost to the running total.
        totalWeftCost += weftCost;
      }
    }

    return totalWeftCost;
  }
}
