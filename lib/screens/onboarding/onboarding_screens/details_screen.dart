import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '../../screens.dart';

class DetailsTab extends StatelessWidget {
  const DetailsTab({
    super.key,
    required this.state,
  });

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 2,
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

        // cat name
        const CustomTextTitle(
            text: 'Cat\'s Name',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Enter your cat's name",
          inputType: TextInputType.name,
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(name: value),
                  ),
                );
          },
        ),
        // cat name

        const SizedBox(height: 20),

        // species
        const CustomTextTitle(
            text: 'Species',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Enter your cat's species",
          inputType: TextInputType.text,
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(species: value),
                  ),
                );
          },
        ),
        // species

        const SizedBox(height: 20),

        // gender
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CheckboxInput(
                text: 'Male',
                value: state.user.gender == 'Male',
                onChanged: (bool? newValue) {
                  context.read<OnboardingBloc>().add(
                        UpdateUser(
                          user: state.user.copyWith(gender: 'Male'),
                        ),
                      );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CheckboxInput(
                text: 'Female',
                value: state.user.gender == 'Female',
                onChanged: (bool? newValue) {
                  context.read<OnboardingBloc>().add(
                        UpdateUser(
                          user: state.user.copyWith(gender: 'Female'),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
        // gender

        const SizedBox(height: 20),

        // color
        const CustomTextTitle(
            text: 'Cat\'s Color',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Enter your cat's color",
          inputType: TextInputType.text,
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(color: value),
                  ),
                );
          },
        ),
        // color

        const SizedBox(height: 20),

        // age
        const CustomTextTitle(
            text: 'Age',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TextFieldComponent(
          hint: "Enter your cat's age",
          inputType: const TextInputType.numberWithOptions(decimal: true),
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(age: double.parse(value)),
                  ),
                );
          },
        ),
        // age

        const SizedBox(height: 20),

        // behavior
        const CustomTextTitle(
            text: 'Behavior',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TagInputFieldComponent(
          hint: 'Type Behavior Here',
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(
                      behavior: value.isNotEmpty
                          ? {...?state.user.behavior, ...value}.toList()
                          : [],
                    ),
                  ),
                );
          },
          // ignore: prefer_const_literals_to_create_immutables
          initialValue: [],
        ),
        // behavior

        const SizedBox(height: 20),

        // medicalHistory
        const CustomTextTitle(
            text: 'Medical History',
            textCenter: false,
            padding: EdgeInsets.only(bottom: 8)),
        TagInputFieldComponent(
          hint: 'Type Medical History Here',
          padding: const EdgeInsets.all(0),
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(
                      medicalHistory: value.isNotEmpty
                          ? {...?state.user.medicalHistory, ...value}.toList()
                          : [],
                    ),
                  ),
                );
          },
          // ignore: prefer_const_literals_to_create_immutables
          initialValue: [],
        ),
        // medicalHistory

        const SizedBox(height: 100),
      ],
      onPressed: () {
        // on tab next step
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
        // on tab next step
      },
    );
  }
}
