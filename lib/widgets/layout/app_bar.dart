import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/screens/screens.dart';

class CatMatchingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActions;
  final bool centerTitle;
  final bool isLoading;
  final bool isLogoVisible;
  final bool topOverlay;
  final bool automaticallyImplyLeading;
  final IconThemeData? iconTheme;
  final List<String> actionsIcons;
  final List<String> actionsRoutes;

  const CatMatchingAppBar({
    super.key,
    this.title = '',
    this.hasActions = true,
    this.centerTitle = false,
    this.isLoading = false,
    this.isLogoVisible = true,
    this.topOverlay = false,
    this.automaticallyImplyLeading = false,
    this.actionsIcons = const [
      'assets/svg-icons/matching.svg',
      'assets/svg-icons/profile.svg',
    ],
    this.iconTheme,
    this.actionsRoutes = const [
      MatchesScreen.routeName,
      ProfileScreen.routeName,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: topOverlay == true
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
              ),
            )
          : null,
      child: AppBar(
        elevation: 0,
        iconTheme: iconTheme,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.only(left: 10, top: 13),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: centerTitle == true
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      isLogoVisible
                          ? InkWell(
                              onTap: () {
                                isLoading == false
                                    ? Navigator.popAndPushNamed(
                                        context, HomeScreen.routeName)
                                    : null;
                              },
                              child: SvgPicture.asset(
                                'assets/logo/logo.svg',
                                height: 40,
                              ),
                            )
                          : Container(height: 40),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: hasActions
            ? [
                Container(
                  padding: const EdgeInsets.only(right: 14, top: 13),
                  child: Row(
                    children: [
                      actionsIcons[0].isNotEmpty
                          ? IconButton(
                              icon: SvgPicture.asset(
                                actionsIcons[0].isNotEmpty
                                    ? actionsIcons[0]
                                    : 'assets/svg-icons/matching.svg',
                                height: 34,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context,
                                    actionsRoutes[0].isNotEmpty
                                        ? actionsRoutes[0]
                                        : MatchesScreen.routeName);
                              },
                            )
                          : Container(),
                      actionsIcons.length > 1 && actionsIcons[1].isNotEmpty
                          ? IconButton(
                              icon: SvgPicture.asset(
                                actionsIcons[1].isNotEmpty
                                    ? actionsIcons[1]
                                    : 'assets/svg-icons/profile.svg',
                                height: 32,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context,
                                    actionsRoutes[1].isNotEmpty
                                        ? actionsRoutes[1]
                                        : ProfileScreen.routeName);
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
