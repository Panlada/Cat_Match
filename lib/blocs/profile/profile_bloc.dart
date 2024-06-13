import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';
import '../blocs.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  final LocationRepository _locationRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
    required LocationRepository locationRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        _locationRepository = locationRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<EditProfile>(_onEditProfile);
    on<SaveProfile>(_onSaveProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<UpdateUserImagesFromProfile>(_onUpdateUserImagesFromProfile);
    on<DeleteUserImageFromProfile>(_onDeleteUserImageFromProfile);

    // authentication in profile constructor
    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadProfile(userId: state.authUser!.uid));
        }
      }
    });
    // authentication in profile constructor
  }

  // load profile data
  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    User user = await _databaseRepository.getUser(event.userId).first;
    emit(ProfileLoaded(user: user));
  }
  // load profile data

  // edit profile data
  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          isEditingOn: event.isEditingOn,
          controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }
  // edit profile data

  // save profile data
  void _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      _databaseRepository.updateUser((state as ProfileLoaded).user);

      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          isEditingOn: false,
          controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }
  // save profile data

  // update profile data
  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit(
        ProfileLoaded(
          user: event.user,
          isEditingOn: (state as ProfileLoaded).isEditingOn,
          controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }
  // update profile data

  // update user location in profile
  void _onUpdateUserLocation(
    UpdateUserLocation event,
    Emitter<ProfileState> emit,
  ) async {
    final state = this.state as ProfileLoaded;

    if (event.isUpdateComplete && event.location != null) {
      final Location location =
          await _locationRepository.getLocation(event.location!.name);

      state.controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            location.lat.toDouble(),
            location.lon.toDouble(),
          ),
        ),
      );

      add(UpdateUserProfile(user: state.user.copyWith(location: location)));
    } else {
      emit(
        ProfileLoaded(
          user: state.user.copyWith(location: event.location),
          controller: event.controller ?? state.controller,
          isEditingOn: state.isEditingOn,
        ),
      );
    }
  }
  // update user location in profile

  // update user image in profile
  void _onUpdateUserImagesFromProfile(
    UpdateUserImagesFromProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      User user = (state as ProfileLoaded).user;
      await _storageRepository.uploadImage(user, event.image);

      _databaseRepository.getUser(user.id!).listen((user) {
        add(UpdateUserProfile(user: user));
      });
    }
  }
  // update user image in profile

  // delete user image in profile
  void _onDeleteUserImageFromProfile(
    DeleteUserImageFromProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      User user = (state as ProfileLoaded).user;

      // Delete image from Firebase Storage
      await _storageRepository.deleteImage(user, event.imageUrl);

      emit(
        ProfileLoaded(
          user: event.user,
          isEditingOn: (state as ProfileLoaded).isEditingOn,
          controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }
  // delete user image in profile

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
