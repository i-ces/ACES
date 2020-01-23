import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/index.dart';

class AccountBlocPage extends StatefulWidget {
  final AccountRepository accountRepository;

  const AccountBlocPage({Key key, this.accountRepository}) : super(key: key);

  @override
  _AccountBlocPage createState() => _AccountBlocPage();
}

class _AccountBlocPage extends State<AccountBlocPage> {
  AccountBlocBloc _accountBlocBloc;
  @override
  void initState() {
    super.initState();
    _accountBlocBloc =
        AccountBlocBloc(accountRepository: widget.accountRepository);
    _accountBlocBloc.add(LoadAccountBlocEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("AccountBloc"),
      ),
      body: AccountBlocScreen(),
    );
  }
}
