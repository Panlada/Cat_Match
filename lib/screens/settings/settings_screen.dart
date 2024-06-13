import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '../screens.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // preference page necessary providers
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  authBloc: BlocProvider.of<AuthBloc>(context),
                  databaseRepository: context.read<DatabaseRepository>(),
                  storageRepository: context.read<StorageRepository>(),
                  locationRepository: context.read<LocationRepository>(),
                )..add(
                    LoadProfile(
                        userId: context.read<AuthBloc>().state.authUser!.uid),
                  ),
                child: const SettingsScreen(),
              );
        // preference page necessary providers
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      extendBodyBehindAppBar: false,
      isSingleChildScrollView: true,

      // custom appbar
      appBar: const CatMatchingAppBar(
        title: 'PREFERENCES',
        topOverlay: false,
        actionsRoutes: [
          MatchesScreen.routeName,
          ProfileScreen.routeName,
        ],
      ),
      // custom appbar

      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.12),
          ),
          width: MediaQuery.of(context).size.width,
          child: const CustomTextTitle(
            text: 'Set Up your Preferences',
            textCenter: true,
            textColor: Colors.white,
          ),
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              // loading
              return SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: const CenterLoadingComponent(),
              );
              // loading
            }
            if (state is ProfileLoaded) {
              return const Padding(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    // gender preference
                    _GenderPreference(),
                    // gender preference

                    SizedBox(height: 10),

                    // age range preference
                    _AgeRangePreference(),
                    // age range preference

                    SizedBox(height: 10),

                    // distance preference
                    _DistancePreference(),
                    // distance preference

                    SizedBox(height: 10),

                    // color preference
                    _ColorPreference(),
                    // color preference

                    SizedBox(height: 40),

                    // species preference
                    _SpeciesPreference(),
                    // species preference

                    SizedBox(height: 40),
                  ],
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: const Center(
                  child: Text('Something went wrong.'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _GenderPreference extends StatelessWidget {
  const _GenderPreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTextTitle(
                text: 'Show Me',
                padding: EdgeInsets.all(0),
              ),
              const SizedBox(height: 5),
              CheckboxInput(
                text: 'Male',
                value: state.user.genderPreference!.contains('Male'),
                onChanged: (value) {
                  if (state.user.genderPreference!.contains('Male')) {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              genderPreference:
                                  List.from(state.user.genderPreference!)
                                    ..remove('Male'),
                            ),
                          ),
                        );
                    context.read<ProfileBloc>().add(
                          SaveProfile(user: state.user),
                        );
                  } else {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              genderPreference:
                                  List.from(state.user.genderPreference!)
                                    ..add('Male'),
                            ),
                          ),
                        );
                    context.read<ProfileBloc>().add(
                          SaveProfile(user: state.user),
                        );
                  }
                },
              ),
              CheckboxInput(
                text: 'Female',
                value: state.user.genderPreference!.contains('Female'),
                onChanged: (value) {
                  if (state.user.genderPreference!.contains('Female')) {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              genderPreference:
                                  List.from(state.user.genderPreference!)
                                    ..remove('Female'),
                            ),
                          ),
                        );
                    context.read<ProfileBloc>().add(
                          SaveProfile(user: state.user),
                        );
                  } else {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              genderPreference:
                                  List.from(state.user.genderPreference!)
                                    ..add('Female'),
                            ),
                          ),
                        );
                    context.read<ProfileBloc>().add(
                          SaveProfile(user: state.user),
                        );
                  }
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

class _AgeRangePreference extends StatelessWidget {
  const _AgeRangePreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const CustomTextTitle(
                      text: 'Age Range', padding: EdgeInsets.all(0)),
                  const SizedBox(height: 10),
                  CustomTextTitle(
                    text:
                        'Between ${state.user.ageRangePreference![0]}  And ${state.user.ageRangePreference![1]} Years',
                    textColor: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.all(0),
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 1.0,
                ),
                child: RangeSlider(
                  values: RangeValues(
                    state.user.ageRangePreference![0].toDouble(),
                    state.user.ageRangePreference![1].toDouble() > 20
                        ? 20
                        : state.user.ageRangePreference![1].toDouble(),
                  ),
                  min: 0,
                  max: 20,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor,
                  onChanged: (rangeValues) {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              ageRangePreference: [
                                double.parse(
                                    rangeValues.start.toStringAsFixed(2)),
                                double.parse(
                                    rangeValues.end.toStringAsFixed(2)),
                              ],
                            ),
                          ),
                        );
                  },
                  onChangeEnd: (RangeValues newRangeValues) {
                    context.read<ProfileBloc>().add(
                          SaveProfile(
                            user: state.user.copyWith(
                              ageRangePreference: [
                                double.parse(
                                    newRangeValues.start.toStringAsFixed(2)),
                                double.parse(
                                    newRangeValues.end.toStringAsFixed(2)),
                              ],
                            ),
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DistancePreference extends StatelessWidget {
  const _DistancePreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const CustomTextTitle(
                      text: 'Maximum Distance', padding: EdgeInsets.all(0)),
                  const SizedBox(height: 10),
                  CustomTextTitle(
                    text: 'Up To ${state.user.distancePreference!} K.M Only',
                    textColor: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.all(0),
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 1.0,
                ),
                child: Slider(
                  value: state.user.distancePreference!.toDouble(),
                  min: 0,
                  max: 100,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                            user: state.user.copyWith(
                              distancePreference: value.toInt(),
                            ),
                          ),
                        );
                  },
                  onChangeEnd: (double newValue) {
                    context.read<ProfileBloc>().add(
                          SaveProfile(
                            user: state.user.copyWith(
                              distancePreference: newValue.toInt(),
                            ),
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ColorPreference extends StatelessWidget {
  const _ColorPreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                children: [
                  CustomTextTitle(
                      text: 'Color Preferences', padding: EdgeInsets.all(0)),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // color preference input
            TagInputFieldComponent(
              hint: 'Type Color Preferences Here',
              initialValue: state.user.colorPreference,
              onChanged: (value) {
                context.read<ProfileBloc>().add(
                      SaveProfile(
                        user: state.user.copyWith(
                          colorPreference: value,
                        ),
                      ),
                    );
              },
            ),
            // color preference input
          ],
        );
      },
    );
  }
}

class _SpeciesPreference extends StatelessWidget {
  const _SpeciesPreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                children: [
                  CustomTextTitle(
                      text: 'Species Preferences', padding: EdgeInsets.all(0)),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // species Preference
            TagInputFieldComponent(
              hint: 'Type Species Preferences Here',
              initialValue: state.user.speciesPreference,
              onChanged: (value) {
                context.read<ProfileBloc>().add(
                      SaveProfile(
                        user: state.user.copyWith(
                          speciesPreference: value,
                        ),
                      ),
                    );
              },
            ),
            // species Preference
          ],
        );
      },
    );
  }
}
