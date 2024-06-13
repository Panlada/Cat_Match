import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '../screens.dart';
import 'onboarding_screens/screens.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          // init onboarding bloc
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
              locationRepository: context.read<LocationRepository>(),
            ),
          ),
          // init onboarding bloc

          // init signup cubit
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          // init signup cubit
        ],
        child: const OnboardingScreen(),
      ),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Details'),
    Tab(text: 'Biography'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);

          context
              .read<OnboardingBloc>()
              .add(StartOnboarding(tabController: tabController));

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.5],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30,
                ),
                child: BlocListener<OnboardingBloc, OnboardingState>(
                  listener: (context, state) {
                    if (state is OnboardingComplete) {
                      // on signup complete redirect to homepage
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                      // on signup complete redirect to homepage
                    }
                  },
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      if (state is OnboardingLoading) {
                        // loading
                        return const CenterLoadingComponent();
                        // loading
                      }

                      if (state is OnboardingLoaded) {
                        // tab pages
                        return TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            StartTab(state: state),
                            EmailTab(state: state),
                            DetailsTab(state: state),
                            BioTab(state: state),
                          ],
                        );
                        // tab pages
                      } else {
                        // something went wrong
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Something went wrong!',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, HomeScreen.routeName);
                                  },
                                  child: Center(
                                    child: Text(
                                      'Go to home screen',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                        // something went wrong
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// onboarding pages layout
class OnboardingScreenLayout extends StatelessWidget {
  final bool stepCounterVisible;
  final String buttonText;
  final int currentStep;
  final void Function()? onPressed;
  final List<Widget> children;

  const OnboardingScreenLayout({
    super.key,
    required this.children,
    this.stepCounterVisible = true,
    this.buttonText = 'Next Step',
    this.currentStep = 1,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight - 75,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...children,
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                stepCounterVisible
                    ? Container(
                        height: 20,
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                        color: Colors.white.withOpacity(1),
                        child: StepProgressIndicator(
                          totalSteps: 3,
                          currentStep: currentStep,
                          selectedColor: const Color.fromARGB(248, 248, 117, 170),
                          unselectedColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                        ),
                      )
                    : Container(height: 5),
                Container(
                  color: Colors.white.withOpacity(1),
                  child: ProfilesElevatedButton(
                    text: buttonText,
                    color: const Color.fromARGB(248, 248, 117, 170),
                    textColor: Colors.white,
                    onPressed: onPressed,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
// onboarding pages layout