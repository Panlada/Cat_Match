part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class EditProfile extends ProfileEvent {
  final bool isEditingOn;

  const EditProfile({
    required this.isEditingOn,
  });

  @override
  List<Object?> get props => [isEditingOn];
}

class SaveProfile extends ProfileEvent {
  final User user;

  const SaveProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserProfile extends ProfileEvent {
  final User user;

  const UpdateUserProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserLocation extends ProfileEvent {
  final Location? location;
  final GoogleMapController? controller;
  final bool isUpdateComplete;

  const UpdateUserLocation({
    this.location,
    this.controller,
    this.isUpdateComplete = false,
  });

  @override
  List<Object?> get props => [location, controller, isUpdateComplete];
}

class UpdateUserImagesFromProfile extends ProfileEvent {
  final User user;
  final XFile image;

  const UpdateUserImagesFromProfile({
    required this.user,
    required this.image,
  });

  @override
  List<Object?> get props => [user, image];
}

class DeleteUserImageFromProfile extends ProfileEvent {
  final User user;
  final String imageUrl;

  const DeleteUserImageFromProfile({
    required this.user,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [user, imageUrl];
}
