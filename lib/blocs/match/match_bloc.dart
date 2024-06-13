import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _databaseSubscription;

  MatchBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(MatchLoading()) {
    on<LoadMatches>(_onLoadMatches);
    on<UpdateMatches>(_onUpdateMatches);
  }

  // load matched profile
  void _onLoadMatches(
    LoadMatches event,
    Emitter<MatchState> emit,
  ) {
    _databaseSubscription =
        _databaseRepository.getMatches(event.user).listen((matchedUsers) {
      add(UpdateMatches(matchedUsers: matchedUsers));
    });
  }
  // load matched profile

  // on update matched profile
  void _onUpdateMatches(
    UpdateMatches event,
    Emitter<MatchState> emit,
  ) {
    if (event.matchedUsers.isEmpty) {
      emit(MatchUnavailable());
    } else {
      emit(MatchLoaded(matches: event.matchedUsers));
    }
  }
  // on update matched profile

  @override
  Future<void> close() async {
    _databaseSubscription?.cancel();
    super.close();
  }
}
