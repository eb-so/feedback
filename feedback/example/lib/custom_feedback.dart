import 'package:another_flushbar/flushbar.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

/// A data type holding user feedback consisting of a feedback type, free from
/// feedback text, and a sentiment rating.
class CustomFeedback {
  CustomFeedback({
    this.feedbackType,
    this.feedbackText,
    this.rating,
  });

  FeedbackType? feedbackType;
  String? feedbackText;
  FeedbackRating? rating;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (rating != null) 'Rating': rating?.name,
      'Type': feedbackType?.name,
      'Feedback': feedbackText,
    };
  }
}

/// What type of feedback the user wants to provide.
enum FeedbackType {
  bugReport('Bug Report'),
  enhancement(' Enhancement'),
  featureRequest('Feature Request'),
  rateUs('Rate App');

  final String name;

  const FeedbackType(
    this.name,
  );
}

/// A user-provided sentiment rating.
enum FeedbackRating {
  bad('Bad'),
  neutral('Neutral'),
  good('Good');

  final String name;

  const FeedbackRating(this.name);
}

/// A form that prompts the user for the type of feedback they want to give,
/// free form text feedback, and a sentiment rating.
class CustomFeedbackForm extends StatefulWidget {
  const CustomFeedbackForm({
    super.key,
    required this.onSubmit,
    required this.scrollController,
  });

  final OnSubmit onSubmit;
  final ScrollController? scrollController;

  @override
  State<CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<CustomFeedbackForm> {
  final CustomFeedback _customFeedback = CustomFeedback();
  final ValueNotifier<bool> _isBusy = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.fromLTRB(
              16,
              widget.scrollController != null ? 4 : 16,
              16,
              0,
            ),
            children: [
              // if (widget.scrollController != null)
              //   const FeedbackSheetDragHandle(),
              const Text('What kind of feedback do you want to give?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text('*'),
                  ),
                  Flexible(
                    child: DropdownButton<FeedbackType>(
                      dropdownColor: theme.cardColor,
                      value: _customFeedback.feedbackType,
                      items: FeedbackType.values
                          .map((type) => DropdownMenuItem<FeedbackType>(
                              value: type,
                              child: Text(
                                type.name,
                              )))
                          .toList(),
                      onChanged: (feedbackType) => setState(
                          () => _customFeedback.feedbackType = feedbackType),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _feedbackQuestionWidget(),
              if (_customFeedback.feedbackType != null &&
                  _customFeedback.feedbackType != FeedbackType.rateUs)
                TextField(
                  onChanged: (newFeedback) => setState(() {
                    _customFeedback.feedbackText = newFeedback;
                  }),
                ),
              const SizedBox(height: 8),
              if (_customFeedback.feedbackType == FeedbackType.rateUs)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: FeedbackRating.values.map(_ratingToIcon).toList(),
                ),
              if ((_customFeedback.feedbackType?.name != null &&
                      _customFeedback.feedbackType!.name.isNotEmpty == true &&
                      _customFeedback.feedbackText != null &&
                      _customFeedback.feedbackText?.isNotEmpty == true) ||
                  (_customFeedback.feedbackType?.name != null &&
                      _customFeedback.feedbackType!.name.isNotEmpty == true &&
                      _customFeedback.rating != null &&
                      _customFeedback.rating?.name.isNotEmpty == true))
                TextButton(
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
                  child: const Text('Submit'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _ratingToIcon(FeedbackRating rating) {
    final bool isSelected = _customFeedback.rating == rating;
    late IconData icon;
    switch (rating) {
      case FeedbackRating.bad:
        icon = Icons.sentiment_dissatisfied;
        break;
      case FeedbackRating.neutral:
        icon = Icons.sentiment_neutral;
        break;
      case FeedbackRating.good:
        icon = Icons.sentiment_satisfied;
        break;
    }
    return IconButton(
      color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey,
      onPressed: () => setState(() => _customFeedback.rating = rating),
      icon: Icon(icon),
      iconSize: 36,
    );
  }

  Widget _feedbackQuestionWidget() {
    switch (_customFeedback.feedbackType) {
      case FeedbackType.bugReport:
        return const Text('What went wrong ?');
      case FeedbackType.enhancement:
        return const Text('What should we improve ?');
      case FeedbackType.featureRequest:
        return const Text('What should we add ?');
      case FeedbackType.rateUs:
        return const Text('How does the app make you feel ?');
      default:
        return const SizedBox
            .shrink(); // Handle the null case with an empty widget
    }
  }
}
