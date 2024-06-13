import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';
import '/widgets/widgets.dart';
import '../screens.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  const MatchesScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MatchBloc>(
        create: (context) => MatchBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadMatches(user: context.read<AuthBloc>().state.user!)),
        child: const MatchesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        if (state is MatchLoading) {
          return const AppLayout(
            // custom appbar widget
            appBar: CatMatchingAppBar(
              title: 'MATCHES',
              isLoading: false,
              hasActions: true,
              centerTitle: false,
              actionsIcons: [
                'assets/svg-icons/profile.svg',
              ],
              actionsRoutes: [
                ProfileScreen.routeName,
              ],
            ),
            // custom appbar widget
            children: [
              // loading
              Expanded(
                child: CenterLoadingComponent(),
              ),
              // loading
            ],
          );
        }

        if (state is MatchLoaded) {
          final inactiveMatches = state.matches
              .where((match) => match.chat.messages.isEmpty)
              .toList();
          final activeMatches = state.matches
              .where((match) => match.chat.messages.isNotEmpty)
              .toList();

          return AppLayout(
            // custom appbar widget
            appBar: const CatMatchingAppBar(
              title: 'MATCHES',
              isLoading: false,
              hasActions: true,
              centerTitle: false,
              actionsIcons: [
                'assets/svg-icons/profile.svg',
              ],
              actionsRoutes: [
                ProfileScreen.routeName,
              ],
            ),
            // custom appbar widget
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: CustomTextTitle(
                        text: 'Your Likes',
                        textCenter: false,
                        fontSize: 18,
                        textColor: Colors.black.withOpacity(0.6),
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    inactiveMatches.isEmpty
                        ? const _NoItemFoundWidget(
                            title: 'There is no match found yet',
                            subTitle: 'Go find a match first',
                            height: 118,
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child:
                                MatchesList(inactiveMatches: inactiveMatches),
                          ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: CustomTextTitle(
                        text: 'Your Chats',
                        textCenter: false,
                        fontSize: 18,
                        textColor: Colors.black.withOpacity(0.7),
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    activeMatches.isEmpty
                        ? _NoItemFoundWidget(
                            title: 'There is no chat found',
                            subTitle: inactiveMatches.isEmpty
                                ? 'Go find a match first'
                                : 'You can chat with matched cat',
                            height: 76,
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height - 340,
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: ChatsList(activeMatches: activeMatches),
                          ),
                  ],
                ),
              )
            ],
          );
        }

        if (state is MatchUnavailable) {
          return AppLayout(
            appBar: const CatMatchingAppBar(
              title: 'MATCHES',
              isLoading: false,
              hasActions: true,
              centerTitle: false,
              actionsIcons: [
                'assets/svg-icons/profile.svg',
              ],
              actionsRoutes: [
                ProfileScreen.routeName,
              ],
            ),
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No matches yet.',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 30),
                      ProfilesElevatedButton(
                        text: 'BACK TO SWIPING',
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return AppLayout(
            appBar: const CatMatchingAppBar(
              title: 'MATCHES',
              isLoading: false,
              hasActions: true,
              centerTitle: false,
              actionsIcons: [
                'assets/svg-icons/profile.svg',
              ],
              actionsRoutes: [
                ProfileScreen.routeName,
              ],
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
        }
      },
    );
  }
}

class _NoItemFoundWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final double height;

  const _NoItemFoundWidget({
    required this.title,
    this.height = 125,
    this.subTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        color: const Color(0xff06afe2).withOpacity(0.02),
        borderRadius:
            BorderRadius.circular(10.0), // Adjust radius for desired roundness
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
            ),
            SizedBox(height: subTitle.isNotEmpty ? 2 : 0),
            subTitle.isNotEmpty
                ? Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class MatchesList extends StatelessWidget {
  const MatchesList({
    super.key,
    required this.inactiveMatches,
  });

  final List<Match> inactiveMatches;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: inactiveMatches.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: inactiveMatches[index],
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      UserImage.small(
                        height: 70,
                        width: 70,
                        border: Border.all(
                          color: const Color(0xff06afe2),
                          width: 2,
                        ),
                        borderRadius: 40.0,
                        url: inactiveMatches[index]
                                .matchUser
                                .imageUrls
                                .isNotEmpty
                            ? inactiveMatches[index].matchUser.imageUrls[0]
                            : null,
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 80,
                        child: Text(
                          inactiveMatches[index].matchUser.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({
    super.key,
    required this.activeMatches,
  });

  final List<Match> activeMatches;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) => ChatBloc(
        databaseRepository: context.read<DatabaseRepository>(),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: activeMatches.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // chat user with text button
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: activeMatches[index],
                    );
                  },
                  child: Row(
                    children: [
                      UserImage.small(
                        height: 70,
                        width: 70,
                        border: Border.all(
                          color: const Color(0xff06afe2),
                          width: 2,
                        ),
                        borderRadius: 40.0,
                        url: activeMatches[index].matchUser.imageUrls.isNotEmpty
                            ? activeMatches[index].matchUser.imageUrls[0]
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 190,
                            // color: Colors.black,
                            child: Text(
                              activeMatches[index].matchUser.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 250,
                                ),
                                child: Text(
                                  activeMatches[index].chat.messages[0].message,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Colors.black54,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  ' . ${activeMatches[index].chat.messages[0].timeString}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // chat user with text button

                // delete chat button
                _DeleteChatButton(
                  match: activeMatches[index],
                  context: context,
                ),
                // delete chat button
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DeleteChatButton extends StatefulWidget {
  final Match match;
  final BuildContext context;

  const _DeleteChatButton({
    required this.match,
    required this.context,
  });

  @override
  _DeleteChatButtonState createState() => _DeleteChatButtonState();
}

class _DeleteChatButtonState extends State<_DeleteChatButton> {
  final bool _showBottomSheet = false;

  void _showOrHideBottomSheet() {
    widget.context.read<ChatBloc>().add(
          LoadChat(widget.match.chat.id),
        );

    if (_showBottomSheet == false) {
      showModalBottomSheet(
        backgroundColor: Colors.black.withOpacity(0.1),
        context: context,
        builder: (context) {
          return SizedBox(
            height: 100,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);

                  widget.context.read<ChatBloc>().add(
                        DeleteChat(
                          userId: widget.match.userId,
                          matchUserId: widget.match.matchUser.id!,
                        ),
                      );
                },
                child: const Text('Delete Chat'),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      color: Theme.of(context).primaryColor,
      iconSize: 32,
      onPressed: () {
        _showOrHideBottomSheet();
      },
    );
  }
}
