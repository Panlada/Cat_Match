import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/signup/signup_cubit.dart';
import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../screens.dart';
import '../widgets/widgets.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 2,
      children: [
        const CustomTextHeader(text: 'What\'s Your Email?'),
        CustomTextField(
          hint: 'ENTER YOUR EMAIL',
          onChanged: (value) {
            context.read<SignupCubit>().emailChanged(value);
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'Choose a Password'),
        CustomTextField(
          hint: 'ENTER YOUR PASSWORD',
          onChanged: (value) {
            context.read<SignupCubit>().passwordChanged(value);
          },
        ),
      ],
      onPressed: () async {
        await context.read<SignupCubit>().signUpWithCredentials();
        // ignore: use_build_context_synchronously
        context.read<OnboardingBloc>().add(
              ContinueOnboarding(
                isSignup: true,
                user: User.empty.copyWith(
                  // ignore: use_build_context_synchronously
                  id: context.read<SignupCubit>().state.user!.uid,
                ),
              ),
            );
      },
    );
  }
}
