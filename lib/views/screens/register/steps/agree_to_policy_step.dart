import 'package:flutter/material.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:pomodak/views/widgets/privacy_policy_modal.dart';
import 'package:pomodak/views/widgets/terms_modal.dart';

class AgreeToPolicyStep extends StatefulWidget {
  final VoidCallback onSuccess;

  const AgreeToPolicyStep({super.key, required this.onSuccess});

  @override
  State<AgreeToPolicyStep> createState() => _AgreeToPolicyStepState();
}

class _AgreeToPolicyStepState extends State<AgreeToPolicyStep> {
  final List<bool> _checked = [false, false];

  void _handleAllChecked(bool? value) {
    setState(() {
      for (int i = 0; i < _checked.length; i++) {
        _checked[i] = value ?? false;
      }
    });
  }

  void _handleCheckClick(int index) {
    setState(() {
      _checked[index] = !_checked[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool allChecked = !_checked.contains(false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Text("모두 동의합니다."),
            value: allChecked,
            onChanged: _handleAllChecked,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Divider(
                    color: Colors.black12,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          _buildCheckboxWithLink(
              "[필수] 이용약관 동의", 0, () => showPrivacyPolicyModal(context)),
          _buildCheckboxWithLink(
              "[필수] 개인정보 수집 및 이용 동의", 1, () => showTermsModal(context)),
          const SizedBox(height: 20),
          CustomButton(
            disabled: !allChecked,
            onTap: () {
              if (allChecked) {
                widget.onSuccess();
              }
            },
            text: '동의하기',
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxWithLink(String title, int index, Function onPressed) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(title),
      trailing: IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: () => onPressed(),
      ),
      leading: Checkbox(
        value: _checked[index],
        onChanged: (bool? value) {
          _handleCheckClick(index);
        },
      ),
      onTap: () => _handleCheckClick(index),
    );
  }
}
