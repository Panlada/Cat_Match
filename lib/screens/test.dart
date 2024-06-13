import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/widgets.dart';

class TestScreen extends StatelessWidget {
  static const String routeName = '/test-screen';
  const TestScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TestScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.2, 0.5],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                AppBarCustom(),
                SizedBox(height: 16),
                Expanded(
                  child: CatMatchingCard(),
                ),
                SizedBox(height: 16),
                HomeButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: SvgPicture.asset(
                'assets/logo/logo.svg',
                height: 50,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg-icons/matching.svg',
                height: 34,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg-icons/profile.svg',
                height: 32,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CatMatchingCard extends StatelessWidget {
  const CatMatchingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> badgeItems = [
      'Lazy',
      'Friendly',
      'Sleepy',
    ];

    final List<String> imageItems = [
      'https://unsplash.it/67/67',
      'https://unsplash.it/67/67',
      'https://unsplash.it/67/67',
      'https://unsplash.it/67/67',
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          image: const DecorationImage(
            image: NetworkImage('https://unsplash.it/1080/1920'),
            fit: BoxFit.cover,
            alignment: Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Badge(
                  text: 'British Shorthair',
                  bgColor: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                  bgOpacity: 1,
                  fontSize: 16,
                  hasStroke: true,
                ),
                const Row(
                  children: [
                    Text(
                      'test,',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '20 Years',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: Wrap(
                    spacing: 8.0, // Adjust spacing between badge items
                    runSpacing: 8.0, // Adjust spacing between lines
                    children: badgeItems.map((badgeText) {
                      return Badge(
                        text: badgeText,
                        bgColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        bgOpacity: 0.6,
                        fontSize: 14,
                        hasStroke: true,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: Wrap(
                    spacing: 3.0, // Adjust spacing between badge items
                    runSpacing: 3.0, // Adjust spacing between lines
                    children: imageItems.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        height: 67,
                        width: 67,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (imageUrl.isEmpty)
                                ? const AssetImage(
                                        'assets/images/placeholder-image.png')
                                    as ImageProvider
                                : NetworkImage(imageUrl),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  final bool hasStroke;
  final Color bgColor;
  final double bgOpacity;

  const Badge({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.bgColor = Colors.pink,
    this.bgOpacity = 1,
    this.hasStroke = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        border: hasStroke ? Border.all(color: bgColor) : null,
        color: bgColor.withOpacity(bgOpacity),
        borderRadius:
            BorderRadius.circular(20.0), // Adjust radius for desired roundness
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceButton.small(
          color: Theme.of(context).colorScheme.secondary,
          icon: Icons.clear_rounded,
          onTap: () {
            // context.read<SwipeBloc>().add(
            //       SwipeRight(user: state.users[0]),
            //     );
          },
        ),
        const SizedBox(width: 10),
        ChoiceButton.large(
          onTap: () {
            // context.read<SwipeBloc>().add(
            //       SwipeRight(user: state.users[0]),
            //     );
          },
        ),
        const SizedBox(width: 10),
        ChoiceButton.small(
          color: Theme.of(context).primaryColor,
          icon: Icons.watch_later,
        ),
      ],
    );
  }
}
