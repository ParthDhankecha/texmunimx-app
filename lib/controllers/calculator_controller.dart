import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/cal_weft_model.dart';
import 'package:texmunimx/models/calculator_get_response.dart';
import 'package:texmunimx/models/design_list_response.dart';
import 'package:texmunimx/models/labour_cost_model.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/calculator_repo.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/utils/app_const.dart';

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

  //for pdf imaage
  Uint8List? designImageBytes;

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

    weftList.removeWhere(
      (weft) =>
          weft.denier == null ||
          weft.pick == null ||
          weft.panno == null ||
          weft.rate == null ||
          weft.meter == null,
    );

    Map<String, dynamic> body = {
      "designId": getDesign!.id,
      "warp": {
        "quality": qualityCont.text,
        "denier": denier.value,
        "tar": tar.value,
        "meter": meter.value,
        "ratePerKg": ratePerKg.value,
      },

      "weft": weftList.map((weft) {
        return {
          "quality": weft.quality ?? '',
          "denier": weft.denier ?? 0.0,
          "pick": weft.pick ?? 0.0,
          "panno": weft.panno ?? 0.0,
          "rate": weft.rate ?? 0.0,
          "meter": weft.meter ?? 0.0,
        };
      }).toList(),
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

  //pdf validations
  bool pdfValidations() {
    if (getDesign == null) {
      showErrorSnackbar('Please select a design first');
      return false;
    }

    if (designCardCont.text.isEmpty || designCard.value <= 0) {
      showErrorSnackbar('design_card_required'.tr);
      return false;
    }

    if (totalWeftCost.value <= 0) {
      showErrorSnackbar('atleast_one_feeder_is_required'.tr);
      return false;
    }

    if (designCard.value <= 0) {
      showErrorSnackbar('design_card_required'.tr);
      return false;
    }

    return true;
  }

  Future<void> generateAndDownloadPdf() async {
    final String imageUrl =
        AppConst.imageBaseUrl + (selectedDesign.value?.designImage ?? '');
    try {
      designImageBytes = await repository.getImageBytes(imageUrl);
    } catch (e) {
      log('Error fetching design image: $e');
      designImageBytes = null;
    }

    final pdf = pw.Document();

    // Create the PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          // Optional: Add a repeating header (e.g., app name, page number)
          if (context.pageNumber > 1) {
            return pw.Center(
              child: pw.Text(
                'Continuation - Page ${context.pageNumber}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            );
          }
          return pw.Container();
        },
        build: (pw.Context context) {
          return _buildPdfContent();
        },
      ),
    );

    // 2. Save/Download the PDF
    try {
      final String fileName =
          'Calculator_Data_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Get a suitable directory for the file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');

      // Write the PDF bytes to the file
      await file.writeAsBytes(await pdf.save());

      // Use the printing package to share/open the file
      await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);

      Get.snackbar(
        'Success',
        'PDF generated and ready to share/save.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate or save PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- PDF Widget Builders ---

  List<pw.Widget> _buildPdfContent() {
    final pw.TextStyle titlePdfStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      // font: boldFont,
    );
    final pw.TextStyle bodyPdfStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      // font: boldFont,
    );
    final pw.TextStyle normalPdfStyle = pw.TextStyle(
      fontSize: 14,
      // font: font,
    );
    final pw.TextStyle smallNormalPdfStyle = pw.TextStyle(
      fontSize: 12,
      // font: font,
    );

    return [
      // Design Details
      _buildPdfDesignDetails(
        titlePdfStyle: titlePdfStyle,
        normalPdfStyle: normalPdfStyle,
        designName: selectedDesign.value?.designName ?? 'N/A',
        designNumber: selectedDesign.value?.designNumber ?? 'N/A',
      ),
      pw.SizedBox(height: 2),

      // Wrap Details
      _buildPdfWrapDetails(
        titlePdfStyle: titlePdfStyle,
        bodyPdfStyle: bodyPdfStyle,
        smallNormalPdfStyle: smallNormalPdfStyle,
        quality: qualityCont.text.trim().toString(),
        denier: denierCont.text.trim().toString(),
        tar: tarCont.text.trim().toString(),
        meter: meterCont.text.trim().toString(),
        ratePerKg: ratePerKgCont.text.trim().toString(),
        totalWarpCost: warpCost.value.toStringAsFixed(2),
      ),
      pw.SizedBox(height: 2),

      // Weft Details
      _buildPdfWeftDetails(
        titlePdfStyle: titlePdfStyle,
        bodyPdfStyle: bodyPdfStyle,
        smallNormalPdfStyle: smallNormalPdfStyle,
        weftList: weftList,
        totalWeftCost: totalWeftCost.toStringAsFixed(2),
      ),
      pw.SizedBox(height: 2),

      // Labour Details
      _buildPdfLabourDetails(
        titlePdfStyle: titlePdfStyle,
        bodyPdfStyle: bodyPdfStyle,
        smallNormalPdfStyle: smallNormalPdfStyle,
        designCard: designCardCont.text,
        labourCostList: labourCostList,
      ),
    ];
  }

  pw.Widget _buildPdfKeyValueRow(
    String key,
    String value,
    pw.TextStyle keyStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF5F5F5),
        border: pw.Border.all(color: PdfColors.black, width: 0.10),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key, style: keyStyle),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTotalRow(
    String key,
    String value,
    pw.TextStyle bodyStyle,
    pw.TextStyle boldStyle,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF5F5F5),
        border: pw.Border.all(color: PdfColors.black, width: 0.50),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key, style: bodyStyle.copyWith(color: PdfColors.black)),
          pw.Text(value, style: boldStyle),
        ],
      ),
    );
  }

  // Design Details Section
  pw.Widget _buildPdfDesignDetails({
    required pw.TextStyle titlePdfStyle,
    required pw.TextStyle normalPdfStyle,
    required String designName,
    required String designNumber,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.black, width: 0.50),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              if (designImageBytes != null) // Conditionally show image
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 10),
                  child: pw.Container(
                    height: 56,
                    width: 56,
                    child: pw.ClipRRect(
                      horizontalRadius: 10,
                      verticalRadius: 10,
                      child: pw.Image(
                        pw.MemoryImage(designImageBytes!),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              pw.Text(
                'Design: $designName ($designNumber)',
                style: normalPdfStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Wrap Details Section
  pw.Widget _buildPdfWrapDetails({
    required pw.TextStyle titlePdfStyle,
    required pw.TextStyle bodyPdfStyle,
    required pw.TextStyle smallNormalPdfStyle,
    required String quality,
    required String denier,
    required String tar,
    required String meter,
    required String ratePerKg,
    required String totalWarpCost,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.black, width: 0.50),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Wrap', style: titlePdfStyle),
          pw.SizedBox(height: 10),

          _buildPdfKeyValueRow(
            'Quality',
            quality,
            smallNormalPdfStyle,
            bodyPdfStyle,
          ),

          pw.Row(
            children: [
              pw.Expanded(
                child: _buildPdfKeyValueRow(
                  'Denier',
                  denier,
                  smallNormalPdfStyle,
                  bodyPdfStyle,
                ),
              ),
              pw.Expanded(
                child: _buildPdfKeyValueRow(
                  'Tar',
                  tar,
                  smallNormalPdfStyle,
                  bodyPdfStyle,
                ),
              ),
            ],
          ),

          pw.Row(
            children: [
              pw.Expanded(
                child: _buildPdfKeyValueRow(
                  'Meter',
                  meter,
                  smallNormalPdfStyle,
                  bodyPdfStyle,
                ),
              ),
              pw.Expanded(
                child: _buildPdfKeyValueRow(
                  'Rate Per Kg',
                  ratePerKg,
                  smallNormalPdfStyle,
                  bodyPdfStyle,
                ),
              ),
            ],
          ),

          _buildPdfTotalRow(
            'Total Wrap Cost',
            totalWarpCost,
            bodyPdfStyle,
            bodyPdfStyle,
          ),
        ],
      ),
    );
  }

  // Weft Details Section
  pw.Widget _buildPdfWeftDetails({
    required pw.TextStyle titlePdfStyle,
    required pw.TextStyle bodyPdfStyle,
    required pw.TextStyle smallNormalPdfStyle,
    required List<dynamic> weftList,
    required String totalWeftCost,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.black, width: 0.50),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Weft', style: titlePdfStyle),
          pw.SizedBox(height: 10),

          ...weftList.map((element) {
            String feeder = element.feeder;
            String quality = element.quality?.trim() ?? 'N/A';
            String denier = element.denier?.toStringAsFixed(2) ?? 'N/A';
            String pick = element.pick?.toStringAsFixed(2) ?? 'N/A';
            String panno = element.panno?.toStringAsFixed(2) ?? 'N/A';
            String meter = element.meter?.toStringAsFixed(2) ?? 'N/A';
            String rate = element.rate?.toStringAsFixed(2) ?? 'N/A';

            if (rate == 'N/A') {
              return pw.SizedBox.shrink();
            }

            return pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Feeder',
                        feeder,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Quality',
                        quality,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Denier',
                        denier,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Pick',
                        pick,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Panno',
                        panno,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Meter',
                        meter,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildPdfKeyValueRow(
                        'Rate',
                        rate,
                        smallNormalPdfStyle,
                        bodyPdfStyle,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
              ],
            );
          }),

          _buildPdfTotalRow(
            'Total Weft Cost',
            totalWeftCost,
            bodyPdfStyle,
            bodyPdfStyle,
          ),
        ],
      ),
    );
  }

  // Labour Details Section
  pw.Widget _buildPdfLabourDetails({
    required pw.TextStyle titlePdfStyle,
    required pw.TextStyle bodyPdfStyle,
    required pw.TextStyle smallNormalPdfStyle,
    required String designCard,
    required List<dynamic> labourCostList,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.black, width: 0.50),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Labour', style: titlePdfStyle),

          _buildPdfKeyValueRow(
            'Design Card',
            designCard,
            smallNormalPdfStyle,
            bodyPdfStyle,
          ),
          pw.SizedBox(height: 10),

          // Header for cost list: Paisa | Cost
          _buildPdfKeyValueRow(
            'Paisa',
            'Cost',
            smallNormalPdfStyle,
            bodyPdfStyle,
          ),

          ...labourCostList.map((element) {
            String paisa = element.paisa.toStringAsFixed(2);
            String cost = element.cost.toStringAsFixed(2);

            return pw.Row(
              children: [
                pw.Expanded(
                  child: _buildPdfKeyValueRow(
                    paisa,
                    cost,
                    smallNormalPdfStyle,
                    bodyPdfStyle,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
