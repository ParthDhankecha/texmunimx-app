import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/cal_weft_model.dart';
import 'package:texmunimx/models/calculator_get_response.dart';
import 'package:texmunimx/models/design_list_response.dart';
import 'package:texmunimx/models/labour_cost_model.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/calculator_repo.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';

class CalculatorController extends GetxController implements GetxService {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  int currentPage = 1;
  int limit = 10;
  String search = '';

  CalculatorRepo repository = Get.find();

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

  RxDouble designCard = 0.0.obs;
  set setDesignCard(double value) => designCard.value = value;

  RxDouble enterPaisa = 0.0.obs;
  set setEnterPaisa(double p) => enterPaisa.value = p;

  RxDouble costByPaisa = 0.0.obs;
  set setCostByPaisa(double c) => costByPaisa.value = c;

  TextEditingController qualityCont = TextEditingController();
  TextEditingController denierCont = TextEditingController();
  TextEditingController tarCont = TextEditingController();
  TextEditingController meterCont = TextEditingController();
  TextEditingController ratePerKgCont = TextEditingController();

  TextEditingController designCardCont = TextEditingController();
  TextEditingController enterPaisaCont = TextEditingController();

  //weft List
  RxList<CalWeftModel> weftList = RxList();
  RxDouble totalWeftCost = 0.0.obs;

  //labour cost
  RxList<LabourCostModel> labourCostList = RxList();

  //set selected design and load data
  setSelectedDesign(DesignModel design) {
    selectedDesign.value = design;
    loadCalculatorData();
  }

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
      showErrorSnackbar('only_12_feeders_are_allowed'.tr);
    }
  }

  removeBox(int index) {
    if (weftList.length > 1) {
      weftList.removeAt(index);
    } else {
      showErrorSnackbar('atleast_one_feeder_is_required'.tr);
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

  //labour cost
  double _getLabourCost(double designCard, double paisa, double weftCost) {
    if (designCard <= 0) {
      return 0.0;
    }
    return ((designCard / 39.37) * paisa) + weftCost;
  }

  List<LabourCostModel> calculateLabourCostList(
    double designCard,
    double weftCost,
  ) {
    double startingPaisa = 0.25;
    const double maxPaisa = 0.70;
    final List<LabourCostModel> list = [];

    int paisaInCents = (startingPaisa * 100).round();
    final int maxPaisaInCents = (maxPaisa * 100).round();
    const int incrementInCents = 5;

    while (paisaInCents <= maxPaisaInCents) {
      double currentPaisa = paisaInCents / 100.0;
      final double cost = _getLabourCost(designCard, currentPaisa, weftCost);

      list.add(LabourCostModel(paisa: currentPaisa, cost: cost));

      paisaInCents += incrementInCents;
    }

    labourCostList.value = list;

    return list;
  }

  addLabourCost() {
    if (designCard <= 0) {
      labourCostList.value = [];
      //showErrorSnackbar('design_card_required'.tr);
      return;
    }

    double weftCost = totalWeftCost.value;

    calculateLabourCostList(designCard.value, weftCost);
  }

  labourCostByPaisa(double paisa) {
    double designCard = paisa;

    if (designCard <= 0) {
      setCostByPaisa = 0.0;
      return;
    }

    double weftCost = totalWeftCost.value;

    final double cost = _getLabourCost(designCard, paisa, weftCost);

    enterPaisa.value = paisa;

    //labourCostList.insert(0, LabourCostModel(paisa: paisa, cost: cost));
    setCostByPaisa = cost;
  }

  loadCalculatorData() async {
    try {
      isLoading.value = true;
      CalculatorModel model = await repository.getDesignDetails(
        id: selectedDesign.value?.id,
      );
      isLoading.value = false;
      setDenier = model.warp.denier;
      setTar = model.warp.tar;
      setMeter = model.warp.meter;
      setRatePerKg = model.warp.ratePerKg;
      setDesignCard = model.labour?.designCard.toDouble() ?? 0.0;

      qualityCont.text = model.warp.quality;

      denierCont.text = model.warp.denier.toString();
      tarCont.text = model.warp.tar.toString();
      meterCont.text = model.warp.meter.toString();
      ratePerKgCont.text = model.warp.ratePerKg.toString();
      designCardCont.text = model.labour?.designCard.toString() ?? '';

      for (int i = 0; i < model.weft.length; i++) {
        if (i < weftList.length) {
          weftList[i].quality = model.weft[i].quality;
          weftList[i].denier = model.weft[i].denier;
          weftList[i].pick = model.weft[i].pick;
          weftList[i].panno = model.weft[i].panno;
          weftList[i].rate = model.weft[i].rate;
          weftList[i].meter = model.weft[i].meter;
        } else {
          weftList.add(
            CalWeftModel(
              id: weftList.length + 1,
              quality: model.weft[i].quality,
              feeder: 'Feeder ${weftList.length + 1}',
              denier: model.weft[i].denier,
              pick: model.weft[i].pick,
              panno: model.weft[i].panno,
              rate: model.weft[i].rate,
              meter: model.weft[i].meter,
            ),
          );
        }
      }

      weftList.refresh();

      calculateWeft();
      calculateWarpCost();
      addLabourCost();

      if (weftList.isEmpty) {
        generateDefaultBoxes();
      }
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } catch (e) {
      log('Error loading calculator data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  onSaveWarp() {
    if (getDesign == null) {
      showErrorSnackbar('Please select a design first');
      return;
    }

    Map<String, dynamic> body = {
      "designId": getDesign!.id,
      "warp": {
        "quality": qualityCont.text,
        "denier": denier.value,
        "tar": tar.value,
        "meter": meter.value,
        "ratePerKg": ratePerKg.value,
      },
      // "weft": [],
      // "labour": {"designCard": designCard.value}
    };

    isLoading.value = true;
    repository
        .saveCalculatorData(body: body, id: getDesign!.id)
        .then((success) {
          isLoading.value = false;
          if (success) {
            showSuccessSnackbar('Warp data saved successfully');
            selectedTab.value = 1; // move to weft tab
          } else {
            showErrorSnackbar('Failed to save warp data');
          }
        })
        .catchError((error) {
          log('Error saving warp data: $error');
          isLoading.value = false;
          showErrorSnackbar('An error occurred while saving warp data');

          switch ((error as ApiException).statusCode) {
            case 401:
              Get.offAll(() => LoginScreen());
              break;

            default:
          }
        });
  }

  onSaveWeft() {
    if (getDesign == null) {
      showErrorSnackbar('Please select a design first');
      return;
    }

    Map<String, dynamic> body = {
      "designId": getDesign!.id,
      "weft": weftList
          .map(
            (weft) => {
              "quality": weft.quality,
              "denier": weft.denier,
              "pick": weft.pick,
              "panno": weft.panno,
              "rate": weft.rate,
              "meter": weft.meter,
            },
          )
          .toList(),
    };
    isLoading.value = true;
    repository
        .saveCalculatorData(body: body, id: getDesign!.id)
        .then((success) {
          isLoading.value = false;
          if (success) {
            showSuccessSnackbar('Weft data saved successfully');
            selectedTab.value = 2; // move to labour tab
          } else {
            showErrorSnackbar('Failed to save weft data');
          }
        })
        .catchError((error) {
          log('Error saving weft data: $error');
          isLoading.value = false;
          showErrorSnackbar('An error occurred while saving weft data');

          switch ((error as ApiException).statusCode) {
            case 401:
              Get.offAll(() => LoginScreen());
              break;

            default:
          }
        });
  }

  onSaveLabour() {
    if (getDesign == null) {
      showErrorSnackbar('Please select a design first');
      return;
    }

    if (designCardCont.text.isEmpty || designCard.value <= 0) {
      showErrorSnackbar('design_card_required'.tr);
      return;
    }

    Map<String, dynamic> body = {
      "designId": getDesign!.id,
      "labour": {"designCard": designCard.value},
    };
    isLoading.value = true;
    repository
        .saveCalculatorData(body: body, id: getDesign!.id)
        .then((success) {
          isLoading.value = false;
          if (success) {
            showSuccessSnackbar('Labour data saved successfully');
          } else {
            showErrorSnackbar('Failed to save labour data');
          }
        })
        .catchError((error) {
          log('Error saving labour data: $error');
          isLoading.value = false;
          showErrorSnackbar('An error occurred while saving labour data');

          switch ((error as ApiException).statusCode) {
            case 401:
              Get.offAll(() => LoginScreen());
              break;

            default:
          }
        });
  }

  onMainSave() {
    if (getDesign == null) {
      showErrorSnackbar('Please select a design first');
      return;
    }

    if (designCardCont.text.isEmpty || designCard.value <= 0) {
      showErrorSnackbar('design_card_required'.tr);
      return;
    }

    Map<String, dynamic> body = {
      "designId": getDesign!.id,
      "warp": {
        "quality": qualityCont.text,
        "denier": denier.value,
        "tar": tar.value,
        "meter": meter.value,
        "ratePerKg": ratePerKg.value,
      },

      "weft": weftList
          .map(
            (weft) => {
              "quality": weft.quality,
              "denier": weft.denier,
              "pick": weft.pick,
              "panno": weft.panno,
              "rate": weft.rate,
              "meter": weft.meter,
            },
          )
          .toList(),
      "labour": {"designCard": designCard.value},
    };
    isLoading.value = true;
    repository
        .saveCalculatorData(body: body, id: getDesign!.id)
        .then((success) {
          isLoading.value = false;
          if (success) {
            showSuccessSnackbar('Labour data saved successfully');
          } else {
            showErrorSnackbar('Failed to save labour data');
          }
        })
        .catchError((error) {
          log('Error saving labour data: $error');
          isLoading.value = false;
          showErrorSnackbar('An error occurred while saving labour data');

          switch ((error as ApiException).statusCode) {
            case 401:
              Get.offAll(() => LoginScreen());
              break;

            default:
          }
        });
  }
}
