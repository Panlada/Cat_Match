import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/widgets.dart';
import '/cubits/signup/signup_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '../../screens.dart';

class EmailTab extends StatelessWidget {
  const EmailTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 1,
      children: [
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: SvgPicture.asset(
              'assets/logo/logo.svg',
            ),
          ),
        ),
        const SizedBox(height: 80),
        CustomTextTitle(
          text: 'Register',
          textCenter: true,
          padding: const EdgeInsets.only(bottom: 8),
          fontSize: 26,
          fontWeight: FontWeight.w700,
          textColor: Theme.of(context).shadowColor,
        ),
        Center(
          child: Text(
            'Awesome! your are almost there, Please enter your email and password.',
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(height: 1.8),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),

        // signup email field
        const CustomTextTitle(
            text: 'Email',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            return TextFieldComponent(
              hint: "Enter your email",
              inputType: TextInputType.emailAddress,
              errorText: state.email.invalid ? 'The email is invalid.' : null,
              padding: const EdgeInsets.all(0),
              onChanged: (email) {
                context.read<SignupCubit>().emailChanged(email);
              },
            );
          },
        ),
        // signup email field

        const SizedBox(height: 30),

        // signup password field
        const CustomTextTitle(
            text: 'Password',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) =>
              previous.password != current.password,
          builder: (context, state) {
            return TextFieldComponent(
              hint: "Enter your password",
              inputType: TextInputType.emailAddress,
              obscureText: true,
              errorText: state.password.invalid
                  ? 'Must contain alphabet and at least 6 characters.'
                  : null,
              padding: const EdgeInsets.all(0),
              onChanged: (password) {
                context.read<SignupCubit>().passwordChanged(password);
              },
            );
          },
        ),
        // signup password field

        const SizedBox(height: 100),
      ],
      onPressed: () async {
        // on click next step button from email screen of signup
        if (BlocProvider.of<SignupCubit>(context).state.status ==
            FormzStatus.valid) {
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
        } else {
          // invalid data snack
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email and password'),
            ),
          );
          // invalid data snack
        }
        // on click next step button from email screen of signup
      },
    );
  }
}
