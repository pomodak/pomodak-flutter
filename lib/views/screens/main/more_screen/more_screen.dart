import 'package:flutter/material.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/views/screens/main/more_screen/widgets/show_delete_account_dialog.dart';
import 'package:pomodak/views/screens/main/more_screen/widgets/show_logout_dialog.dart';
import 'package:pomodak/views/widgets/privacy_policy_modal.dart';
import 'package:pomodak/views/widgets/terms_modal.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appViewModel = Provider.of<AppViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "설정",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Text(
                  '시스템',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(
                  appViewModel.vibration ? Icons.vibration : Icons.close,
                  size: 20,
                ),
                title: const Text(
                  '진동',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  appViewModel.vibration = !appViewModel.vibration;
                  if (await Vibration.hasVibrator() == true &&
                      appViewModel.vibration) {
                    Vibration.vibrate(duration: 400);
                  }
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(
                  appViewModel.keepScreenOn
                      ? Icons.remove_red_eye_outlined
                      : Icons.close,
                  size: 20,
                ),
                title: const Text(
                  '화면 꺼짐 방지',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  appViewModel.keepScreenOn = !appViewModel.keepScreenOn;
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Text(
                  '계정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.delete_outline,
                  size: 20,
                ),
                title: const Text(
                  '계정 삭제',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  showDeleteAccountDialog(context);
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.logout_outlined,
                  size: 20,
                ),
                title: const Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  showLogoutDialog(context);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Text(
                  '앱 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(
                  Icons.info_outline,
                  size: 20,
                ),
                title: Text(
                  '앱 버전',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: Text(
                  "1.0.21",
                  style: TextStyle(fontSize: 14, letterSpacing: 1.2),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.document_scanner_outlined,
                  size: 20,
                ),
                title: const Text(
                  '이용약관',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  showTermsModal(context);
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(
                  Icons.shield_outlined,
                  size: 20,
                ),
                title: const Text(
                  '개인정보처리방침',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  showPrivacyPolicyModal(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
