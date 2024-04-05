import 'package:flutter/material.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.vibration),
                title: const Text('진동'),
                onTap: () {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Text(
                  '계정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.delete_outline),
                title: const Text('계정 삭제'),
                onTap: () {},
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.logout_outlined),
                title: const Text('로그아웃'),
                onTap: () async {
                  await authViewModel.logOut();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Text(
                  '앱 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(Icons.info_outline),
                title: Text('앱 버전'),
                trailing: Text(
                  "1.0.21",
                  style: TextStyle(fontSize: 16, letterSpacing: 1.2),
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(Icons.document_scanner_outlined),
                title: Text('이용약관'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                leading: Icon(Icons.shield_outlined),
                title: Text('개인정보처리방침'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
