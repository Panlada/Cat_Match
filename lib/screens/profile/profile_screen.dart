import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '/models/models.dart';
import '/screens/screens.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // init my profiles necessary providers
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.authenticated
            ? BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  authBloc: BlocProvider.of<AuthBloc>(context),
                  databaseRepository: context.read<DatabaseRepository>(),
                  storageRepository: context.read<StorageRepository>(),
                  locationRepository: context.read<LocationRepository>(),
                )..add(
                    LoadProfile(
                        userId: context.read<AuthBloc>().state.authUser!.uid),
                  ),
                child: const ProfileScreen(),
              )
            : const LoginScreen();
        // init my profiles necessary providers
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      extendBodyBehindAppBar: true,
      isSingleChildScrollView: true,

      // custom appbar
      appBar: const CatMatchingAppBar(
        title: 'PROFILE',
        topOverlay: true,
        actionsIcons: [
          'assets/svg-icons/matching.svg',
          'assets/svg-icons/settings.svg',
        ],
        actionsRoutes: [
          MatchesScreen.routeName,
          SettingsScreen.routeName,
        ],
      ),
      // custom appbar

      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              // loading
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const CenterLoadingComponent(),
              );
              // loading
            }

            if (state is ProfileLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // expanded to appbar user image
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        UserImage.medium(
                          url: (state.user.imageUrls.isNotEmpty)
                              ? state.user.imageUrls[0]
                              : null,
                          borderRadius: 20.00,
                          isUserDetails: true,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // expanded to appbar user image

                  const SizedBox(height: 20),

                  // view & edit button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // view button
                        ProfilesElevatedButton(
                          text: 'View',
                          color: state.isEditingOn
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          textColor: state.isEditingOn
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                                  SaveProfile(user: state.user),
                                );
                          },
                          width: MediaQuery.of(context).size.width * 0.44,
                        ),
                        // view button

                        const SizedBox(width: 15),

                        // edit button
                        ProfilesElevatedButton(
                          text: 'Edit',
                          color: state.isEditingOn
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          textColor: state.isEditingOn
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                                  // ignore: prefer_const_constructors
                                  EditProfile(isEditingOn: true),
                                );
                          },
                          width: MediaQuery.of(context).size.width * 0.44,
                        ),
                        // edit button
                      ],
                    ),
                  ),
                  // view & edit button

                  const SizedBox(height: 20),

                  // profile details & inputs
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Wrap(
                      spacing: 8.0, // Adjust spacing between items
                      runSpacing: 8.0, // Adjust spacing between lines
                      children: [
                        // cat name
                        _TextField(
                          title: 'Name',
                          value: state.user.name,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(name: value),
                                  ),
                                );
                          },
                        ),
                        // cat name

                        // species
                        _TextField(
                          title: 'Species',
                          value: state.user.species,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(species: value),
                                  ),
                                );
                          },
                        ),
                        // species

                        // gender
                        _GenderCheckboxField(
                          title: 'Gender',
                          value: state.user.gender,
                          onChangedMale: (bool? newValue) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(gender: 'Male'),
                                  ),
                                );
                          },
                          onChangedFemale: (bool? newValue) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(gender: 'Female'),
                                  ),
                                );
                          },
                        ),
                        // gender

                        // color
                        _TextField(
                          title: 'Color',
                          value: state.user.color,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(color: value),
                                  ),
                                );
                          },
                        ),
                        // color

                        // age
                        _TextField(
                          title: 'Age',
                          value: '${state.user.age}',
                          formInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            if (value == null || value == '') {
                              return;
                            }

                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(
                                      age: double.parse(value),
                                    ),
                                  ),
                                );
                          },
                        ),
                        // age

                        // location
                        _Location(
                          title: 'Location/Zip',
                          value: state.user.location!.name,
                        ),
                        // location
                      ],
                    ),
                  ),
                  // profile details & inputs

                  const SizedBox(height: 20),

                  // bio
                  _TextAreaField(
                    title: 'Bio',
                    value: state.user.bio,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(bio: value),
                            ),
                          );
                    },
                  ),
                  // bio

                  const SizedBox(height: 20),

                  // behavior
                  _MultiSelectField(
                    title: 'Behavior',
                    value: state.user.behavior,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                behavior: value!.isNotEmpty
                                    ? {...?state.user.behavior, ...value}
                                        .toList()
                                    : [],
                              ),
                            ),
                          );
                    },
                  ),
                  // behavior

                  const SizedBox(height: 20),

                  // Medical History
                  _MultiSelectField(
                    title: 'Medical History',
                    value: state.user.medicalHistory,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                medicalHistory: value!.isNotEmpty
                                    ? {...?state.user.medicalHistory, ...value}
                                        .toList()
                                    : [],
                              ),
                            ),
                          );
                    },
                  ),
                  // Medical History

                  const SizedBox(height: 20),

                  // pictures
                  const _Pictures(),
                  // pictures

                  const SizedBox(height: 10),

                  const _SignOut(),

                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const Center(
                child: Text('Something went wrong.'),
              );
            }
          },
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final String value;
  final Function(dynamic) onChanged;
  final TextInputType formInputType;

  const _TextField({
    required this.title,
    required this.value,
    required this.onChanged,

    // ignore: unused_element
    this.formInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        return ProfileTextInput(
          title: title,
          value: value,
          onChanged: onChanged,
          isEditingOn: state.isEditingOn,
          inputType: formInputType,
        );
      },
    );
  }
}

class _GenderCheckboxField extends StatelessWidget {
  const _GenderCheckboxField({
    required this.title,
    required this.value,
    required this.onChangedMale,
    required this.onChangedFemale,
  });

  final String title;
  final String value;
  final Function(bool?) onChangedMale;
  final Function(bool?) onChangedFemale;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        return ProfileGenderInput(
          title: title,
          value: value,
          onChangedMale: onChangedMale,
          onChangedFemale: onChangedFemale,
          isEditingOn: state.isEditingOn,
        );
      },
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final String title;
  final String value;
  final Function(String?) onChanged;
  final TextInputType formInputType;

  const _TextAreaField({
    required this.title,
    required this.value,
    required this.onChanged,

    // ignore: unused_element
    this.formInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        return Column(
          children: [
            CustomTextTitle(
              text: title,
              textCenter: !state.isEditingOn,
            ),
            const SizedBox(height: 5),
            state.isEditingOn
                ? TextFieldComponent(
                    hint: 'Type $title Here',
                    onChanged: onChanged,
                    inputType: TextInputType.multiline,
                    maxLines: null,
                    initialValue: value,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(height: 1.5),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _MultiSelectField extends StatelessWidget {
  final String title;
  final List<String>? value;
  final Function(List<String>?) onChanged;
  final TextInputType formInputType;

  const _MultiSelectField({
    required this.title,
    required this.value,
    required this.onChanged,

    // ignore: unused_element
    this.formInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        return Column(
          children: [
            CustomTextTitle(
              text: title,
              textCenter: !state.isEditingOn,
            ),
            state.isEditingOn
                ? TagInputFieldComponent(
                    hint: 'Type $title Here',
                    onChanged: onChanged,
                    initialValue: value,
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0, // Adjust spacing between badge items
                        runSpacing: 8.0, // Adjust spacing between lines
                        children: value!.map((badgeText) {
                          return CustomBadge(
                            text: badgeText,
                            bgColor: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            bgOpacity: 1,
                            fontSize: 14,
                            hasStroke: false,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _Location extends StatelessWidget {
  final String title;
  final String value;

  const _Location({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double containerWidthFull = MediaQuery.of(context).size.width - 24;
    double containerWidthHalf = MediaQuery.of(context).size.width / 2 -
        24; // Subtracting padding from width

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        return state.isEditingOn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: containerWidthFull,
                    child: TextFieldComponent(
                      inputType: TextInputType.text,
                      padding: const EdgeInsets.all(0),
                      initialValue: value,
                      onChanged: (value) {
                        Location location =
                            state.user.location!.copyWith(name: value);
                        context
                            .read<ProfileBloc>()
                            .add(UpdateUserLocation(location: location));
                      },
                      onFocusChanged: (hasFocus) {
                        if (hasFocus) {
                          return;
                        } else {
                          context.read<ProfileBloc>().add(
                                UpdateUserLocation(
                                  isUpdateComplete: true,
                                  location: state.user.location,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      height: 300,
                      child: GoogleMap(
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          context.read<ProfileBloc>().add(
                                UpdateUserLocation(controller: controller),
                              );
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            state.user.location!.lat.toDouble(),
                            state.user.location!.lon.toDouble(),
                          ),
                          zoom: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              )
            : Container(
                width: containerWidthHalf,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff06afe2),
                  ),
                  color: const Color(0xff06afe2).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust radius for desired roundness
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

class _Pictures extends StatelessWidget {
  const _Pictures();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextTitle(
                text: 'Pictures',
                textCenter: !state.isEditingOn,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                child: Wrap(
                  spacing: 8.0, // Adjust spacing between image items
                  runSpacing: 8.0, // Adjust spacing between lines
                  children: [
                    ...state.user.imageUrls.asMap().entries.map((entry) {
                      // final int index = entry.key;
                      final String imageUrl = entry.value;

                      return ManageImageComponent(
                        imageUrl: imageUrl,
                        isEditingOn: state.isEditingOn,
                        onPressedAdd: () async {},
                        onPressedRemove: () async {
                          if (imageUrl.isNotEmpty) {
                            BlocProvider.of<ProfileBloc>(context).add(
                              DeleteUserImageFromProfile(
                                user: state.user,
                                imageUrl: imageUrl,
                              ),
                            );
                          }
                        },
                      );
                    }),
                    state.isEditingOn
                        ? ManageImageComponent(
                            isEditingOn: state.isEditingOn,
                            onPressedRemove: () async {},
                            onPressedAdd: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50);

                              if (image == null) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No image was selected.'),
                                  ),
                                );
                              } else {
                                // image upload
                                // ignore: use_build_context_synchronously
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateUserImagesFromProfile(
                                    user: state.user,
                                    image: image,
                                  ),
                                );
                                // image upload
                              }
                            },
                          )
                        : Container(),
                    state.user.imageUrls.isEmpty && !state.isEditingOn
                        ? const Center(
                            child: Text(
                              'No pictures uploaded yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                RepositoryProvider.of<AuthRepository>(context).signOut();
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 15.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    "Sign Out",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
