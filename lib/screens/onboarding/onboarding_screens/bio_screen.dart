import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';
import '../../screens.dart';

class BioTab extends StatelessWidget {
  const BioTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    // var images = state.user.imageUrls;
    // var imageCount = images.length;

    return OnboardingScreenLayout(
      buttonText: "Get Started",
      currentStep: 3,
      children: [
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: SvgPicture.asset(
              'assets/logo/logo.svg',
            ),
          ),
        ),
        const SizedBox(height: 60),

        // bio
        const CustomTextTitle(
            text: 'Cat\'s Biography',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Type biography here",
          inputType: TextInputType.multiline,
          maxLines: null,
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(bio: value),
                  ),
                );
          },
        ),
        // bio

        const SizedBox(height: 20),

        // location
        const CustomTextTitle(
            text: 'Location',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Type location/zip here",
          inputType: TextInputType.text,
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            Location location = state.user.location!.copyWith(name: value);
            context
                .read<OnboardingBloc>()
                .add(SetUserLocation(location: location));
          },
          onFocusChanged: (hasFocus) {
            if (hasFocus) {
              return;
            } else {
              context.read<OnboardingBloc>().add(
                    SetUserLocation(
                      isUpdateComplete: true,
                      location: state.user.location,
                    ),
                  );
            }
          },
        ),
        const SizedBox(height: 15),

        // google map
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
            height: 300,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController mapController) {
                context.read<OnboardingBloc>().add(
                      SetUserLocation(mapController: mapController),
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
        // google map
        // location

        const SizedBox(height: 30),

        // images
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTextTitle(
                text: 'Images',
                textCenter: false,
                padding: EdgeInsets.only(bottom: 8),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                child: Wrap(
                  spacing: 8.0, // Adjust spacing between image items
                  runSpacing: 8.0, // Adjust spacing between lines
                  children: [
                    ...state.user.imageUrls.asMap().entries.map((entry) {
                      // final int index = entry.key;
                      final String imageUrl = entry.value;

                      return ManageImageComponent(
                        imageUrl: imageUrl,
                        isEditingOn: false,
                        onPressedAdd: () async {},
                        onPressedRemove: () async {
                          if (imageUrl.isNotEmpty) {
                            BlocProvider.of<OnboardingBloc>(context).add(
                              DeleteUserImageFromOnboarding(
                                user: state.user,
                                imageUrl: imageUrl,
                              ),
                            );
                          }
                        },
                      );
                    }),
                    ManageImageComponent(
                      isEditingOn: true,
                      onPressedRemove: () async {},
                      onPressedAdd: () async {
                        final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);

                        if (image == null) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No image was selected.'),
                            ),
                          );
                        } else {
                          // Upload image
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<OnboardingBloc>(context).add(
                            UpdateUserImages(
                              image: image,
                              user: state.user,
                            ),
                          );
                          // Upload image
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // images

        const SizedBox(height: 100),
      ],
      onPressed: () {
        // complete signup
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
        // complete signup
      },
    );
  }
}
