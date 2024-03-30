import 'package:flutter/material.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:pomodak/views/widgets/custom_text_field.dart';

class CheckCodeForm extends StatefulWidget {
  final Function(String code) onRegister;

  const CheckCodeForm({super.key, required this.onRegister});

  @override
  State<CheckCodeForm> createState() => _CheckCodeFormState();
}

class _CheckCodeFormState extends State<CheckCodeForm> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';

  String? _codeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "인증코드를 입력해주세요.";
    }

    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onRegister(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            labelText: '인증코드',
            validator: _codeValidator,
            onSaved: (value) => _code = value!,
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: "확인",
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}
