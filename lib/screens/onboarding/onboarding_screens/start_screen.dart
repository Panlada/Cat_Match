import 'package:cat_matching/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/blocs/blocs.dart';
import '/widgets/widgets.dart';
import '../onboarding_screen.dart';

class StartTab extends StatelessWidget {
  const StartTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      buttonText: 'Continue Sign up',
      stepCounterVisible: false,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 185,
          color: Colors.black.withOpacity(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: SvgPicture.asset(
                  'assets/logo/logo.svg',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cat Matching',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 26,
                    ),
              ),
              const SizedBox(height: 100),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Get ready to find your purr-fect feline companion. Sign up now to begin your journey towards meeting your new furry friend!"',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(height: 1.8),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Spacer(),

        // sign up link widget
        const _SignInLink(),
        // sign up link widget
      ],
      onPressed: () {
        // continue onboarding
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
        // continue onboarding
      },
    );
  }
}

class _SignInLink extends StatelessWidget {
  const _SignInLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomTextTitle(
              text: 'Already have an account?',
              textCenter: true,
              padding: EdgeInsets.only(bottom: 0),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  LoginScreen.routeName,
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
