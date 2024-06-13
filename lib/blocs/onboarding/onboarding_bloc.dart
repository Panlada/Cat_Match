import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/repositories/repositories.dart';
import '/models/models.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  final LocationRepository _locationRepository;

  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
    required LocationRepository locationRepository,
  })  : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        _locationRepository = locationRepository,
        super(OnboardingLoading()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<ContinueOnboarding>(_onContinueOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
    on<SetUserLocation>(_onSetUserLocation);
    on<DeleteUserImageFromOnboarding>(_onDeleteUserImageFromOnboarding);
  }

  // initialize onboarding
  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      OnboardingLoaded(
        user: User.empty,
        tabController: event.tabController,
      ),
    );
  }
  // initialize onboarding

  // on continue onboarding fn
  void _onContinueOnboarding(
    ContinueOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    final state = this.state as OnboardingLoaded;

    if (event.isSignup) {
      await _databaseRepository.createUser(event.user);
    }

    final newIndex = state.tabController.index + 1;
    if (newIndex < state.tabController.length) {
      // Emit an event to indicate continuing to the next tab
      state.tabController.animateTo(newIndex);

      emit(
        OnboardingLoaded(
          user: event.user,
          tabController: state.tabController,
        ),
      );
    } else {
      // Emit an event to indicate navigation to the home screen
      emit(OnboardingComplete());
    }
  }
  // on continue onboarding fn

  // update user data from onboarding
  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      _databaseRepository.updateUser(event.user);
      emit(
        OnboardingLoaded(
          user: event.user,
          tabController: (state as OnboardingLoaded).tabController,
          mapController: (state as OnboardingLoaded).mapController,
        ),
      );
    }
  }
  // update user data from onboarding

  // update user image from onboarding
  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;
      await _storageRepository.uploadImage(user, event.image);

      _databaseRepository.getUser(user.id!).listen((user) {
        add(UpdateUser(user: user));
      });
    }
  }
  // update user image from onboarding

  // update user location from onboarding
  void _onSetUserLocation(
    SetUserLocation event,
    Emitter<OnboardingState> emit,
  ) async {
    final state = this.state as OnboardingLoaded;

    if (event.isUpdateComplete && event.location != null) {
      final Location location =
          await _locationRepository.getLocation(event.location!.name);

      state.mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            location.lat.toDouble(),
            location.lon.toDouble(),
          ),
        ),
      );

      add(UpdateUser(user: state.user.copyWith(location: location)));

      // _databaseRepository.getUser(state.user.id!).listen((user) {
      //   add(UpdateUser(user: state.user.copyWith(location: location)));
      // });
    } else {
      emit(
        OnboardingLoaded(
          user: state.user.copyWith(location: event.location),
          mapController: event.mapController ?? state.mapController,
          tabController: state.tabController,
        ),
      );
    }
  }
  // update user location from onboarding

  // delete user image in onboarding
  void _onDeleteUserImageFromOnboarding(
    DeleteUserImageFromOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;

      // Delete image from Firebase Storage
      await _storageRepository.deleteImage(user, event.imageUrl);

      emit(
        OnboardingLoaded(
          user: user,
          mapController: (state as OnboardingLoaded).mapController,
          tabController: (state as OnboardingLoaded).tabController,
        ),
      );
    }
  }
  // delete user image in onboarding
}
