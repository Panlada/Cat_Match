import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/models.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '../screens.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // auth bloc init in home constructor
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : BlocProvider<SwipeBloc>(
                create: (context) => SwipeBloc(
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(LoadUsers()),
                child: const HomeScreen(),
              );
        // auth bloc init in home constructor
      },
    );
  }

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
          // swipeable cards
          return _SwipeLoadedHomeScreen(state: state);
          // swipeable cards
        }

        if (state is SwipeMatched) {
          // its a match screen
          return _SwipeMatchedHomeScreen(state: state);
          // its a match screen
        }

        if (state is SwipeError) {
          // no more cards to swipe screen
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
                    'There aren\'t any more cats.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          );
          // no more cards to swipe screen
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

class _SwipeLoadedHomeScreen extends StatelessWidget {
  const _SwipeLoadedHomeScreen({
    required this.state,
  });

  final SwipeLoaded state;

  @override
  Widget build(BuildContext context) {
    var userCount = state.users.length;

    return AppLayout(
      appBar: const CatMatchingAppBar(title: 'HOME'),
      children: [
        Column(
          children: [
            InkWell(
              onDoubleTap: () {
                Navigator.pushNamed(
                  context,
                  UsersScreen.routeName,
                  arguments: state.users[0],
                );
              },
              child: Draggable<User>(
                data: state.users[0],
                feedback: UserCard(user: state.users[0]),
                childWhenDragging: (userCount > 1)
                    ? UserCard(user: state.users[1])
                    : Container(
                        height: MediaQuery.of(context).size.height - 225,
                      ),
                onDragEnd: (drag) {
                  if (drag.velocity.pixelsPerSecond.dx < 0) {
                    // Swiped Left
                    context
                        .read<SwipeBloc>()
                        .add(SwipeLeft(user: state.users[0]));
                    // Swiped Left
                  } else {
                    // Swiped Right
                    context
                        .read<SwipeBloc>()
                        .add(SwipeRight(user: state.users[0]));
                    // Swiped Right
                  }
                },
                child: UserCard(user: state.users[0]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceButton.small(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icons.clear_rounded,
              onTap: () {
                // on tap Swiped left button
                context.read<SwipeBloc>().add(
                      SwipeLeft(user: state.users[0]),
                    );
                // on tap Swiped left button
              },
            ),
            const SizedBox(width: 10),
            ChoiceButton.large(
              onTap: () {
                // on tap Swiped right button
                context.read<SwipeBloc>().add(
                      SwipeRight(user: state.users[0]),
                    );
                // on tap Swiped right button
              },
            ),
            const SizedBox(width: 10),
            ChoiceButton.small(
              color: Theme.of(context).primaryColor,
              icon: Icons.watch_later,
              onTap: () {
                // on tap skip card button
                context.read<SwipeBloc>().add(
                      SwipeSkip(user: state.users[0]),
                    );
                // on tap skip card button
              },
            ),
          ],
        ),
      ],
    );
  }
}
