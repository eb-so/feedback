import 'package:another_flushbar/flushbar.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class CustomFeedback {
  CustomFeedback({
    this.feedbackText,
  });

  String? feedbackType;
  String? feedbackText;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Feedback': feedbackText,
    };
  }
}

class CustomFeedbackForm extends StatefulWidget {
  const CustomFeedbackForm({
    super.key,
    required this.onSubmit,
  });

  final OnSubmit onSubmit;

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();
  final ValueNotifier<bool> _isBusy = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            children: [
              const Text(
                'What went wrong ?',
                style: TextStyle(
                  fontFamily: 'Madera',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: const Color(0xfff05423),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff05423)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff05423), width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                maxLines: 2,
                onChanged: (newFeedback) => setState(() {
                  _customFeedback.feedbackText = newFeedback;
                }),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff05423),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Specify the border radius here
                  ),
                ),
                onPressed: !_isBusy.value
                    ? () async {
                        _isBusy.value = true;
                        //await
                        widget.onSubmit(
                          _customFeedback.feedbackText ?? '',
                          extras: _customFeedback.toMap(),
                        );

                        Flushbar(
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          message: 'Thank you for submitting your feedback',
                          duration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(16),
                          backgroundColor: const Color(0xffdb6d6c),
                        ).show(context);

                        _isBusy.value = false;
                      }
                    : null,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Madera',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
