import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/account_bloc/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountBlocEvent extends Equatable {
  AccountBlocEvent([List props = const []]) : super();
}

class LoadAccountBlocEvent extends AccountBlocEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadGuidesBlocEvent extends AccountBlocEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
