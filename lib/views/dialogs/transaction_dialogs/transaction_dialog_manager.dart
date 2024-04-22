import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/buy_item_dialog.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/consume_item_dialog.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/delete_account_dialog.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/logout_dialog.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/sell_character_dialog.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/stop_timer_dialog.dart';

class TransactionDialogManager {
  // 아이템 사용
  static void showConsumeItemDialog(
      BuildContext context, ItemInventoryModel inventory) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ConsumeItemDialog(inventory: inventory),
    );
  }

  // 캐릭터 판매
  static void showSellCharacterDialog(
      BuildContext context, CharacterInventoryModel inventory, int maxCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          SellCharacterDialog(inventory: inventory, maxCount: maxCount),
    );
  }

  // 아이템 구매
  static void showBuyItemDialog(
      BuildContext context, ItemModel item, int maxCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          BuyItemDialog(item: item, maxCount: maxCount),
    );
  }

  // 로그아웃
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LogoutDialog(),
    );
  }

  // 계정 삭제
  static void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const DeleteAccountDialog(),
    );
  }

  // 타이머 중지
  static void showStopTimerDialog(
      BuildContext context, StopTimerDialogType dialogType) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          StopTimerDialog(dialogType: dialogType),
    );
  }
}
