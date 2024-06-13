import 'package:flutter/material.dart';
import '/widgets/widgets.dart';

class ProfileGenderInput extends StatelessWidget {
  const ProfileGenderInput({
    super.key,
    required this.title,
    required this.value,
    required this.onChangedMale,
    required this.onChangedFemale,
    required this.isEditingOn,
  });

  final String title;
  final String value;
  final Function(bool?) onChangedMale;
  final Function(bool?) onChangedFemale;
  final bool isEditingOn;

  @override
  Widget build(BuildContext context) {
    double containerWidthFull = MediaQuery.of(context).size.width - 24;
    double containerWidthHalf = MediaQuery.of(context).size.width / 2 -
        24; // Subtracting padding from width

    return isEditingOn
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: containerWidthFull,
                child: CheckboxInput(
                  text: 'Male',
                  value: value == 'Male',
                  onChanged: onChangedMale,
                ),
              ),
              SizedBox(
                width: containerWidthFull,
                child: CheckboxInput(
                  text: 'Female',
                  value: value == 'Female',
                  onChanged: onChangedFemale,
                ),
              ),
              const SizedBox(height: 15),
            ],
          )
        : Container(
            width: containerWidthHalf,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff06afe2),
              ),
              color: const Color(0xff06afe2).withOpacity(0.05),
              borderRadius: BorderRadius.circular(
                  10.0), // Adjust radius for desired roundness
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
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
