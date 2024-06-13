//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';
import '../../screens.dart';
import '../widgets/widgets.dart';

class DemoTab extends StatelessWidget {
  const DemoTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 3,
      children: [
        const CustomTextHeader(text: 'What\'s Your Name?'),
        const SizedBox(height: 20),
        CustomTextField(
          hint: 'ENTER YOUR NAME',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(name: value),
                  ),
                );
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'What\'s Your Gender?'),
        const SizedBox(height: 20),
        CustomCheckbox(
          text: 'MALE',
          value: state.user.gender == 'Male',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(gender: 'Male'),
                  ),
                );
          },
        ),
        CustomCheckbox(
          text: 'FEMALE',
          value: state.user.gender == 'Female',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(gender: 'Female'),
                  ),
                );
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'How old are you?'),
        CustomTextField(
          hint: 'ENTER YOUR AGE',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(age: double.parse(value)),
                  ),
                );
          },
        ),
      ],
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
    );
  }
}
