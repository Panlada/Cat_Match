import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '/blocs/blocs.dart';

import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      topLinearGradientStops: const [0.2, 0.9],
      topLinearGradient: true,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          // ignore: deprecated_member_use
          child: WillPopScope(
            onWillPop: () async => false,
            child: BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) {
                return previous.authUser != current.authUser ||
                    current.authUser == null;
              },
              listener: (context, state) {
                if (state.status == AuthStatus.unauthenticated) {
                  // redirect to login if not authenticated after 1s delay
                  Timer(
                    const Duration(seconds: 1),
                    () => Navigator.of(context).pushNamed(
                      LoginScreen.routeName,
                    ),
                  );
                  // redirect to login if not authenticated after 1s delay
                } else if (state.status == AuthStatus.authenticated) {
                  // redirect to home screen if authenticated after 1s delay
                  Timer(
                    const Duration(seconds: 1),
                    () => Navigator.of(context).pushNamed(
                      HomeScreen.routeName,
                    ),
                  );
                  // redirect to home screen if authenticated after 1s delay
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/logo/logo.svg',
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Cat Matching',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.9),
                                ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextButton(
                          onPressed: () {
                            RepositoryProvider.of<AuthRepository>(context)
                                .signOut();
                          },
                          child: Center(
                            child: Text(
                              'Sign Out',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
