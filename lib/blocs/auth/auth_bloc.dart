import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '/repositories/repositories.dart';

import '/models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository,
  })  : _authRepository = authRepository,
        _databaseRepository = databaseRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);

    // authenticate user constructor
    _authUserSubscription = _authRepository.user.listen((authUser) {
      // print('Auth user: $authUser');

      if (authUser != null) {
        _databaseRepository.getUser(authUser.uid).listen((user) {
          add(AuthUserChanged(authUser: authUser, user: user));
        });
      } else {
        add(AuthUserChanged(authUser: authUser));
      }
    });
    // authenticate user constructor
  }

  // on change authenticated user fn
  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    event.authUser != null
        ? emit(AuthState.authenticated(
            authUser: event.authUser!,
            user: event.user!,
          ))
        : emit(const AuthState.unauthenticated());
  }
  // on change authenticated user fn

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
