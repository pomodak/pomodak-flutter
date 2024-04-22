import 'package:flutter/material.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/views/dialogs/acquisition_dialogs/widgets/character_acquisition_dialog.dart';
import 'package:pomodak/views/dialogs/acquisition_dialogs/widgets/item_acquisition_dialog.dart';
import 'package:pomodak/views/dialogs/acquisition_dialogs/widgets/palette_acquisition_dialog.dart';
import 'package:pomodak/views/dialogs/acquisition_dialogs/widgets/point_acquisition_dialog.dart';

class AcquisitionDialogManager {
  static void showAcquisitionDialog(BuildContext context,
      dynamic acquisitionResult, ItemInventoryModel? inventory) {
    if (acquisitionResult is ConsumableItemAcquisition) {
      showItemAcquisitionDialog(context, acquisitionResult);
    } else if (acquisitionResult is CharacterAcquisition) {
      showCharacterAcquisitionDialog(context, acquisitionResult);
    } else if (acquisitionResult is PaletteAcquisition && inventory != null) {
      showPaletteAcquisitionDialog(context, acquisitionResult, inventory);
    } else if (acquisitionResult is PointAcquisition) {
      showPointAcquisitionDialog(context, acquisitionResult);
    }
  }

  static void showItemAcquisitionDialog(
      BuildContext context, ConsumableItemAcquisition result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      builder: (BuildContext context) => ItemAcquisitionDialog(
        result: result,
      ),
    );
  }

  static void showCharacterAcquisitionDialog(
      BuildContext context, CharacterAcquisition result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      builder: (BuildContext context) => CharacterAcquisitionDialog(
        result: result,
      ),
    );
  }

  static void showPaletteAcquisitionDialog(BuildContext context,
      PaletteAcquisition result, ItemInventoryModel inventory) {
    showDialog(
      context: context,
      builder: (BuildContext context) => PaletteAcquisitionDialog(
        inventory: inventory,
        initialPalette: result.palette,
      ),
    );
  }

  static void showPointAcquisitionDialog(
      BuildContext context, PointAcquisition result) {
    showDialog(
      context: context,
      builder: (BuildContext context) => PointAcquisitionDialog(
        result: result,
      ),
    );
  }
}
