import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/widgets/widgets.dart';
import '../screens.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // auth check in page constructor
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : const HomeScreen();
        // auth check in page constructor
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      isSingleChildScrollView: true,
      topLinearGradientStops: const [0, 0.50],
      topLinearGradient: true,
      children: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // login page title
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: SvgPicture.asset(
                      'assets/logo/logo.svg',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cat Matching',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 100),
                  // login page title

                  // email input
                  CustomTextTitle(
                    text: 'E-meow',
                    textCenter: false,
                    padding: const EdgeInsets.only(bottom: 8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: Theme.of(context).primaryColor,
                  ),
                  _EmailInput(),
                  // email input

                  const SizedBox(height: 30),

                  // password input
                  CustomTextTitle(
                    text: 'Pussword',
                    textCenter: false,
                    padding: const EdgeInsets.only(bottom: 8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: Theme.of(context).primaryColor,
                  ),
                  _PasswordInput(),
                  // password input

                  const SizedBox(height: 20),

                  // signup link
                  const _SignUpLink(),
                  // signup link

                  const SizedBox(height: 10),

                  // login button
                  const _LoginButton(),
                  // login button

                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFieldComponent(
          inputType: TextInputType.emailAddress,
          errorText: state.email.invalid ? 'The email is invalid.' : null,
          padding: const EdgeInsets.all(0),
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFieldComponent(
          inputType: TextInputType.emailAddress,
          obscureText: true,
          errorText: state.password.invalid
              ? 'Must contain alphabet and at least 6 characters.'
              : null,
          padding: const EdgeInsets.all(0),
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
        );
      },
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

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
              text: 'Are you a new cat?',
              textCenter: true,
              padding: EdgeInsets.only(bottom: 0),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            TextButton(
              // on click move route to signup
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                OnboardingScreen.routeName,
                ModalRoute.withName('/onboarding'),
              ),
              // on click move route to signup
              child: Text(
                'Sign Up',
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

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == FormzStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : ProfilesElevatedButton(
                text: 'Meowgin',
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  state.status == FormzStatus.valid
                      ? context.read<LoginCubit>().logInWithCredentials()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // content: Text('Check your Email and Password'),
                            content: Text(
                                'Check your Email and Password. ${state.errorMessage != null ? state.errorMessage?.replaceAll("Exception: ", "") : ''}'),
                          ),
                        );
                },
                width: MediaQuery.of(context).size.width,
              );
      },
    );
  }
}
