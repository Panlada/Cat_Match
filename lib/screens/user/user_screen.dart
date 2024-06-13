import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '/models/models.dart';
import '../screens.dart';

class UsersScreen extends StatelessWidget {
  static const String routeName = '/users';

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // other user profile screens necessary providers & auth check
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : BlocProvider<SwipeBloc>(
                create: (context) => SwipeBloc(
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(LoadUsers()),
                child: UsersScreen(
                  user: user,
                ),
              );
        // other user profile screens necessary providers & auth check
      },
    );
  }

  final User user;

  const UsersScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          // loading
          return const AppLayout(
            appBar: CatMatchingAppBar(
                isLoading: true, hasActions: false, centerTitle: false),
            children: [
              Expanded(
                child: CenterLoadingComponent(),
              ),
            ],
          );
          // loading
        }

        if (state is SwipeLoaded) {
          return AppLayout(
            extendBodyBehindAppBar: true,
            isSingleChildScrollView: true,
            appBar: const CatMatchingAppBar(
              title: '',
              iconTheme: IconThemeData(
                color: Colors.white,
                fill: BorderSide.strokeAlignCenter,
              ),
              isLogoVisible: false,
              automaticallyImplyLeading: true,
              topOverlay: true,
              hasActions: false,
            ),
            children: [
              // user image with elevated buttons
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.9,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'user_card',
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 45.0),
                        child: UserImage.medium(
                          url: user.imageUrls.isNotEmpty
                              ? user.imageUrls[0]
                              : null,
                          borderRadius: 20.00,
                          isUserDetails: true,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceButton.small(
                              color: Theme.of(context).colorScheme.secondary,
                              icon: Icons.clear_rounded,
                              onTap: () {
                                // swipe left button on tap
                                BlocProvider.of<SwipeBloc>(context).add(
                                  SwipeLeft(user: user),
                                );
                                // swipe left button on tap
                              },
                            ),
                            ChoiceButton.large(onTap: () {
                              // swipe right button on tap
                              BlocProvider.of<SwipeBloc>(context).add(
                                SwipeRight(user: user),
                              );
                              // swipe right button on tap
                            }),
                            ChoiceButton.small(
                              color: Theme.of(context).primaryColor,
                              icon: Icons.watch_later,
                              onTap: () {
                                // skip button on tap
                                context.read<SwipeBloc>().add(
                                      SwipeSkip(user: state.users[0]),
                                    );
                                Navigator.pop(context);
                                // skip button on tap
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // user image with elevated buttons

              // user details
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Wrap(
                  spacing: 8.0, // Adjust spacing between items
                  runSpacing: 8.0, // Adjust spacing between lines
                  children: [
                    _TextItem(title: 'Name', value: user.name),
                    _TextItem(title: 'Species', value: user.species),
                    _TextItem(title: 'Gender', value: user.gender),
                    _TextItem(title: 'Color', value: user.color),
                    _TextItem(title: 'Age', value: '${user.age} Years'),
                    _TextItem(title: 'Location', value: user.location!.name),
                    const SizedBox(height: 10),

                    // bio
                    user.bio.isNotEmpty
                        ? Column(
                            children: [
                              const CustomTextTitle(
                                  text: 'Bio', textCenter: true),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  user.bio,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    // bio

                    const SizedBox(height: 10),

                    // behavior
                    user.behavior!.isNotEmpty
                        ? Column(
                            children: [
                              const CustomTextTitle(
                                text: 'Behavior',
                                textCenter: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      right: 8, bottom: 8),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing:
                                        8.0, // Adjust spacing between badge items
                                    runSpacing:
                                        8.0, // Adjust spacing between lines
                                    children: user.behavior!.map((badgeText) {
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
                          )
                        : Container(),
                    // behavior

                    // medical history
                    user.medicalHistory!.isNotEmpty
                        ? Column(
                            children: [
                              const CustomTextTitle(
                                text: 'Medical History',
                                textCenter: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      right: 8, bottom: 8),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing:
                                        8.0, // Adjust spacing between badge items
                                    runSpacing:
                                        8.0, // Adjust spacing between lines
                                    children:
                                        user.medicalHistory!.map((badgeText) {
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
                          )
                        : Container(),
                    // medical history

                    // pictures
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          user.imageUrls.isNotEmpty
                              ? const CustomTextTitle(
                                  text: 'Pictures', textCenter: true)
                              : Container(),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, bottom: 10),
                            child: Wrap(
                              spacing:
                                  8.0, // Adjust spacing between image items
                              runSpacing: 8.0, // Adjust spacing between lines
                              children: user.imageUrls.map((imageUrl) {
                                return ManageImageComponent(
                                  imageUrl: imageUrl,
                                  isEditingOn: false,
                                  onPressedAdd: () async {},
                                  onPressedRemove: () async {},
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // pictures

                    const SizedBox(height: 50),
                  ],
                ),
              ),
              // user details
            ],
          );
        }

        if (state is SwipeMatched) {
          // its a match screen
          return _SwipeMatchedHomeScreen(state: state);
          // its a match screen
        }

        if (state is SwipeError) {
          // no more profile to swipe screen
          return AppLayout(
            isSingleChildScrollView: false,

            // custom appbar
            appBar: const CatMatchingAppBar(
              title: 'HOME',
              hasActions: true,
              centerTitle: false,
            ),
            // custom appbar

            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Text(
                    'There aren\'t any more cats.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          );
          // no more profile to swipe screen
        } else {
          // something went wrong screen
          return AppLayout(
            isSingleChildScrollView: false,
            appBar: const CatMatchingAppBar(
              title: 'HOME',
              hasActions: true,
              centerTitle: false,
            ),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Text(
                    'Something went wrong!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          );
          // something went wrong screen
        }
      },
    );
  }
}

class _TextItem extends StatelessWidget {
  final String title;
  final String value;

  const _TextItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff06afe2),
        ),
        color: const Color(0xff06afe2).withOpacity(0.05),
        borderRadius:
            BorderRadius.circular(10.0), // Adjust radius for desired roundness
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.isNotEmpty ? value : 'N/A',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeMatchedHomeScreen extends StatelessWidget {
  const _SwipeMatchedHomeScreen({
    required this.state,
  });

  final SwipeMatched state;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 80,
                      child: ClipOval(
                        child: Container(
                          color: const Color(0xff06afe2),
                          padding: const EdgeInsets.all(1.5),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(context
                                .read<AuthBloc>()
                                .state
                                .user!
                                .imageUrls[0]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 190,
                      child: ClipOval(
                        child: Container(
                          color: const Color(0xff06afe2),
                          padding: const EdgeInsets.all(1.5),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage:
                                NetworkImage(state.user.imageUrls[0]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Congrats, it\'s a match!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'You and ${state.user.name} have liked each other!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'You can start Conversation now',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              const SizedBox(height: 40),
              ProfilesElevatedButton(
                text: 'GO TO MATCHES',
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MatchesScreen.routeName,
                  );
                },
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(height: 15),
              ProfilesElevatedButton(
                text: 'BACK TO SWIPING',
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  context.read<SwipeBloc>().add(LoadUsers());
                },
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
