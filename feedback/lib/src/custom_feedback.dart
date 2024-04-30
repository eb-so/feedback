import 'package:flutter/material.dart';

class CustomFeedback {
  String? feedbackText;

  CustomFeedback({this.feedbackText});

  Map<String, dynamic> toMap() {
    return {'Feedback': feedbackText};
  }
}

class CustomFeedbackForm extends StatefulWidget {
  final Function(String, {Map<String, dynamic>? extras}) onSubmit;

  const CustomFeedbackForm({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();
  final ValueNotifier<bool> _isBusy = ValueNotifier(false);

  @override
  void dispose() {
    _isBusy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('What went wrong?',
                  style: TextStyle(fontFamily: 'Madera')),
              const SizedBox(height: 8),
              _buildFeedbackTextField(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackTextField() {
    return TextField(
      cursorColor: const Color(0xfff05423),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xfff05423)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xfff05423), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      maxLines: 2,
      onChanged: (newFeedback) {
        _customFeedback.feedbackText = newFeedback;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isBusy,
      builder: (context, isBusy, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfff05423),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isBusy ? null : _handleSubmit,
          child: child,
        );
      },
      child: const Text('Submit',
          style: TextStyle(color: Colors.white, fontFamily: 'Madera')),
    );
  }

  void _handleSubmit() {
    setState(() => _isBusy.value = true);
    widget.onSubmit(
      _customFeedback.feedbackText ?? '',
      extras: _customFeedback.toMap(),
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isBusy.value = false);
    });
  }
}
