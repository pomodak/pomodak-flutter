import 'package:flutter/material.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:pomodak/views/widgets/custom_text_field.dart';

class EmailLoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;

  const EmailLoginForm({super.key, required this.onLogin});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "이메일을 입력해주세요.";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '유효하지 않은 이메일 주소입니다.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상입니다.';
    }
    if (value.length > 20) {
      return '비밀번호는 최대 20자 이하입니다.';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 숫자가 포함되어야 합니다.';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 소문자가 포함되어야 합니다.';
    }
    if (!RegExp(r'(?=.*[\W])').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 특수 문자가 포함되어야 합니다.';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onLogin(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            labelText: '이메일',
            validator: _emailValidator,
            onSaved: (value) => _email = value!,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            labelText: '패스워드',
            obscureText: true,
            validator: _passwordValidator,
            onSaved: (value) => _password = value!,
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: "로그인",
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}
