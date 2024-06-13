import 'package:cat_matching/widgets/add_user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '/blocs/blocs.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';
import '../widgets/widgets.dart';

class PicturesTab extends StatelessWidget {
  const PicturesTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    var images = state.user.imageUrls;
    var imageCount = images.length;

    return OnboardingScreenLayout(
      currentStep: 4,
      children: [
        const CustomTextHeader(text: 'Add 2 or More Pictures'),
        const SizedBox(height: 20),
        SizedBox(
          height: 350,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.66,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return (imageCount > index)
                  ? UserImage.medium(
                      url: images[index],
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 10.0,
                        right: 10.0,
                      ),
                    )
                  : AddUserImage(
                      onPressed: () async {
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
                          // ignore: avoid_print
                          print('Uploading ...');
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<OnboardingBloc>(context).add(
                            UpdateUserImages(image: image),
                          );
                        }
                      },
                    );
            },
          ),
        ),
      ],
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
    );
  }
}
