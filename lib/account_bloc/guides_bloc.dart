import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/index.dart';

class GuidesBloc extends Bloc<AccountBlocEvent, AccountBlocState> {
  final AccountRepository accountRepository;
  GuidesBloc({this.accountRepository});

  AccountBlocState get initialState => new LoadGuidesBlocState();

  @override
  Stream<AccountBlocState> mapEventToState(
    AccountBlocEvent event,
  ) async* {
    if (event is LoadGuidesBlocEvent) {
      yield LoadingGuidesBlocState();
      try {
        final List<AccountModel> guides = await accountRepository.fetchGuides();
        yield LoadedGuidesListState(guidesList: guides);
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
