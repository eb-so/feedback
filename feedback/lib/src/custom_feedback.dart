import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class CustomFeedbackForm extends StatefulWidget {
  final OnSubmit onSubmit;

  const CustomFeedbackForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  String? feedbackText;
  final ValueNotifier<bool> _isBusy = ValueNotifier(false);
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    _isBusy.dispose();
    feedbackController.dispose();
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
      controller: feedbackController,
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
        feedbackText = newFeedback;
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
          onPressed: isBusy
              ? null
              : () async {
                  if (!mounted) return;
                  _isBusy.value = true;
                  await widget.onSubmit(feedbackText ?? '');
                },
          child: child,
        );
      },
      child: const Text('Submit',
          style: TextStyle(color: Colors.white, fontFamily: 'Madera')),
    );
  }
}
