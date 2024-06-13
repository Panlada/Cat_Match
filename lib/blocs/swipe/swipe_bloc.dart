import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';
import '../blocs.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  SwipeBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(SwipeLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
    on<SwipeSkip>(_onSwipeSkip);

    // swipe bloc constructor
    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        // load profiles for swipe
        add(LoadUsers());
      }
    });
    // swipe bloc constructor
  }

  // load users to swipe
  void _onLoadUsers(
    LoadUsers event,
    Emitter<SwipeState> emit,
  ) {
    if (_authBloc.state.user != null) {
      User currentUser = _authBloc.state.user!;
      _databaseRepository.getUsersToSwipe(currentUser).listen((users) {
        if (_isDisposed) {
          return;
        }

        add(UpdateHome(users: users));
      });
    }
  }
  // load users to swipe

  // update home profiles
  void _onUpdateHome(
    UpdateHome event,
    Emitter<SwipeState> emit,
  ) {
    // update home profiles
    if (event.users!.isNotEmpty) {
      emit(SwipeLoaded(users: event.users!));
    } else {
      emit(SwipeError());
    }
  }
  // update home profiles

  // swipe left event fn
  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      _databaseRepository.updateUserSwipe(
        _authBloc.state.authUser!.uid,
        event.user.id!,
        false,
      );

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users));
      } else {
        emit(SwipeError());
      }
    }
  }
  // swipe left event fn

  // swipe right event fn
  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) async {
    final state = this.state as SwipeLoaded;
    String userId = _authBloc.state.authUser!.uid;
    List<User> users = List.from(state.users)..remove(event.user);

    _databaseRepository.updateUserSwipe(
      userId,
      event.user.id!,
      true,
    );

    if (event.user.swipeRight!.contains(userId)) {
      await _databaseRepository.updateUserMatch(
        userId,
        event.user.id!,
      );
      emit(SwipeMatched(user: event.user));
    } else if (users.isNotEmpty) {
      emit(SwipeLoaded(users: users));
    } else {
      emit(SwipeError());
    }
  }
  // swipe right event fn

  // swipe skip event fn
  void _onSwipeSkip(
    SwipeSkip event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users));
      } else {
        emit(SwipeError());
      }
    }
  }
  // swipe skip event fn

  bool _isDisposed = false;

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();

    _isDisposed = true;
  }
}
