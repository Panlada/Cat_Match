part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class StartOnboarding extends OnboardingEvent {
  final User user;
  final TabController tabController;

  const StartOnboarding({
    this.user = User.empty,
    required this.tabController,
  });

  @override
  List<Object?> get props => [user, tabController];
}

class ContinueOnboarding extends OnboardingEvent {
  final User user;
  final bool isSignup;

  const ContinueOnboarding({
    required this.user,
    this.isSignup = false,
  });

  @override
  List<Object?> get props => [user, isSignup];
}

class UpdateUser extends OnboardingEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class SetUserLocation extends OnboardingEvent {
  final Location? location;
  final GoogleMapController? mapController;
  final bool isUpdateComplete;

  const SetUserLocation({
    this.location,
    this.mapController,
    this.isUpdateComplete = false,
  });

  @override
  List<Object?> get props => [location, mapController, isUpdateComplete];
}

class UpdateUserImages extends OnboardingEvent {
  final User? user;
  final XFile image;

  const UpdateUserImages({
    this.user,
    required this.image,
  });

  @override
  List<Object?> get props => [user, image];
}

class DeleteUserImageFromOnboarding extends OnboardingEvent {
  final User user;
  final String imageUrl;

  const DeleteUserImageFromOnboarding({
    required this.user,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [user, imageUrl];
}

class ShowSnackBarEvent extends OnboardingEvent {
  final String message;

  const ShowSnackBarEvent(this.message);

  @override
  List<Object?> get props => [message];
}
