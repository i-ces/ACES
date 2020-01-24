import 'package:equatable/equatable.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountBlocState extends Equatable {}

/// UnInitialized
class LoadAccountBlocState extends AccountBlocState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadGuidesBlocState extends AccountBlocState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadingAccountBlocState extends AccountBlocState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadingGuidesBlocState extends AccountBlocState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InAccountBlocState extends AccountBlocState {
  final AccountModel accountModel;
  InAccountBlocState({@required this.accountModel})
      : assert(accountModel != null);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadedGuidesListState extends AccountBlocState {
  final List<AccountModel> guidesList;
  LoadedGuidesListState({@required this.guidesList});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorAccountBlocState extends AccountBlocState {
  final String errorMessage;

  ErrorAccountBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorAccountBlocState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorGuidesBlocState extends AccountBlocState {
  final String errorMessage;

  ErrorGuidesBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorAccountBlocState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
