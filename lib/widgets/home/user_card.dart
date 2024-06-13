import 'package:flutter/material.dart';

import '../widgets.dart';
import '/models/models.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'user_card',
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 255,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: [
              UserImage.large(
                url: user.imageUrls.isNotEmpty ? user.imageUrls[0] : null,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).highlightColor,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user.species.isNotEmpty
                        ? CustomBadge(
                            text: user.species,
                            bgColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.white,
                            bgOpacity: 1,
                            fontSize: 16,
                            hasStroke: true,
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.red.withOpacity(0.3),
                          child: Text(
                            user.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${user.age} Year',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white.withOpacity(0.75)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    user.behavior!.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: Wrap(
                              spacing:
                                  8.0, // Adjust spacing between badge items
                              runSpacing: 8.0, // Adjust spacing between lines
                              children: user.behavior!.map((badgeText) {
                                return CustomBadge(
                                  text: badgeText,
                                  bgColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  bgOpacity: 0.6,
                                  fontSize: 14,
                                  hasStroke: true,
                                );
                              }).toList(),
                            ),
                          )
                        : Container(),
                    user.imageUrls.length > 1
                        ? SmallPictureCard(user: user)
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallPictureCard extends StatelessWidget {
  const SmallPictureCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: user.imageUrls.length + 1,
          itemBuilder: (builder, index) {
            return (index < user.imageUrls.length)
                ? UserImage.small(
                    url: user.imageUrls.isNotEmpty
                        ? user.imageUrls[index]
                        : null,
                    margin: const EdgeInsets.only(top: 8, right: 8),
                  )
                : null;
          }),
    );
  }
}
