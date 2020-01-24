import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/index.dart';

class AccountBlocBloc extends Bloc<AccountBlocEvent, AccountBlocState> {
  final AccountRepository accountRepository;
  AccountBlocBloc({this.accountRepository});

  AccountBlocState get initialState => new LoadAccountBlocState();

  @override
  Stream<AccountBlocState> mapEventToState(
    AccountBlocEvent event,
  ) async* {
    print("object");
    yield LoadingAccountBlocState();
    print("loadcomplete");
    if (event is LoadAccountBlocEvent) {
      print("hello");
      try {
        final AccountModel account = await accountRepository.loadAccount();

        yield InAccountBlocState(accountModel: account);
      } catch (e) {
        throw e.toString();
      }
    }
    if (event is LoadGuidesBlocEvent) {
      print("object is called");
      try {
        final List<AccountModel> guides = await accountRepository.fetchGuides();
        print("object is called");
        yield LoadedGuidesListState(guidesList: guides);
        print("object is called");
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
