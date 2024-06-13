import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/models/models.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  final Match match;

  const ChatScreen({
    super.key,
    required this.match,
  });

  static Route route({required Match match}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadChat(match.chat.id)),
        child: ChatScreen(match: match),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatScreenCustomAppBar(match: match),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatDeleted) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: state.chat.messages.length,
                    itemBuilder: (context, index) {
                      List<Message> messages = state.chat.messages;
                      return ListTile(
                        title: _Message(
                          message: messages[index].message,
                          dateTime: messages[index].dateTime,
                          isFromCurrentUser: messages[index].senderId ==
                              context.read<AuthBloc>().state.authUser!.uid,
                        ),
                      );
                    },
                  ),
                ),
                _MessageInput(match: match)
              ],
            );
          }
          if (state is ChatDeleted) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'The chat has been deleted.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      ProfilesElevatedButton(
                        text: 'BACK TO MATCHES',
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: MediaQuery.of(context).size.width * 0.6,
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: Text(
                  'Something went wrong!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                Colors.black.withOpacity(0.1), // You can specify any color here
            width: 1.0, // Adjust the width as needed
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black38,
                ),
                // labelText: 'TextField',
                hintText: 'Write your message here',
                // contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    width: 0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0),
                    width: 0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                context.read<ChatBloc>().add(
                      AddMessage(
                        userId: match.userId,
                        matchUserId: match.matchUser.id!,
                        message: controller.text,
                      ),
                    );
                controller.clear();
              },
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.dateTime,
    required this.message,
    required this.isFromCurrentUser,
  });

  final DateTime dateTime;
  final String message;
  final bool isFromCurrentUser;

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;
    Color color = isFromCurrentUser
        ? Theme.of(context).colorScheme.secondary.withAlpha(30)
        : Theme.of(context).primaryColor;
    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isFromCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              color: color,
            ),
            child: Text(
              message,
              style: textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              DateFormat('EEE \'AT\' h:mm a').format(dateTime),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatScreenCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ChatScreenCustomAppBar({
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      bottom: PreferredSize(
        preferredSize:
            const Size.fromHeight(1.0), // Set the height of the bottom border
        child: Container(
          color: Colors.black
              .withOpacity(0.15), // Set the color of the bottom border
          height: 1.0, // Set the height of the bottom border
        ),
      ),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            match.matchUser.name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
      actions: [
        _DeleteChatButton(
          match: match,
          context: context,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65.0);
}

// delete chat button
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
        // backgroundColor: Theme.of(context).primaryColor,
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
// delete chat button
