import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class UserEditModal extends StatefulWidget {
  const UserEditModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) => const UserEditModal(),
    );
  }

  @override
  State<UserEditModal> createState() => _UserEditModalState();
}

class _UserEditModalState extends State<UserEditModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _statusMessageController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? _nicknameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임을 입력해주세요.';
    } else if (value.trim().length < 2 || value.trim().length > 100) {
      return '닉네임은 2자 이상 100자 이하로 입력해주세요.';
    } else if (value.contains(' ')) {
      return '닉네임에 공백을 포함할 수 없습니다.';
    }
    return null;
  }

  String? _statusMessageValidator(String? value) {
    if (value != null && value.length > 500) {
      return '상태메세지는 500자 이하로 입력해주세요.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    var memberViewModel = Provider.of<MemberViewModel>(context, listen: false);

    _nicknameController.text = memberViewModel.member?.nickname ?? "";
    _statusMessageController.text = memberViewModel.member?.statusMessage ?? "";
    _imageUrlController.text = memberViewModel.member?.imageUrl ?? "";
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _statusMessageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var memberViewModel =
          Provider.of<MemberViewModel>(context, listen: false);
      await memberViewModel.updateMemberInfo(
        nickname: _nicknameController.text,
        imageUrl: _imageUrlController.text,
        statusMessage: _statusMessageController.text,
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var memberViewModel = Provider.of<MemberViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, size: 32),
        ),
        title: const Text(
          "프로필 수정",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.network(
                _imageUrlController.text.isEmpty
                    ? CDNImages.newMember["mascot"]!
                    : _imageUrlController.text,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 28),
              const Row(
                children: [
                  Text(
                    "캐릭터 목록",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: memberViewModel.characterInventory.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageUrlController.text = memberViewModel
                              .characterInventory[index].character.imageUrl;
                        });
                      },
                      child: Image.network(
                        memberViewModel
                            .characterInventory[index].character.imageUrl,
                        width: 80,
                        height: 80,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              CustomTextField(
                labelText: '닉네임',
                controller: _nicknameController,
                validator: _nicknameValidator,
                onSaved: (value) => _nicknameController.text = value!,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: '상태메세지',
                controller: _statusMessageController,
                validator: _statusMessageValidator,
                onSaved: (value) => _statusMessageController.text = value!,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
