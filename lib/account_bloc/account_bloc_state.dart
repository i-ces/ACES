import 'package:equatable/equatable.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountBlocState {}

/// UnInitialized
class LoadAccountBlocState extends AccountBlocState {}

class LoadGuidesBlocState extends AccountBlocState {}

class LoadingAccountBlocState extends AccountBlocState {}

class LoadingGuidesBlocState extends AccountBlocState {}

/// Initialized
class InAccountBlocState extends AccountBlocState {
  final AccountModel accountModel;
  InAccountBlocState({@required this.accountModel})
      : assert(accountModel != null);
}

class LoadedGuidesListState extends AccountBlocState {
  final List<AccountModel> guidesList;
  LoadedGuidesListState({@required this.guidesList})
      : assert(guidesList != null);
}

class ErrorAccountBlocState extends AccountBlocState {
  final String errorMessage;

  ErrorAccountBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorAccountBlocState';
}

class ErrorGuidesBlocState extends AccountBlocState {
  final String errorMessage;

  ErrorGuidesBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorAccountBlocState';
}
