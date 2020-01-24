import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/account_bloc/index.dart';
import 'package:ghumnajaam/profile/my_profile.dart';

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.topRight,
        colors: <Color>[
          Color.fromRGBO(63, 169, 245, 1),
          const Color(0xFF2B264A),
        ],
      ),
    );
    return BlocBuilder<AccountBlocBloc, AccountBlocState>(
        bloc: BlocProvider.of<AccountBlocBloc>(context),
        builder: (
          BuildContext context,
          currentState,
        ) {
          if (currentState is LoadAccountBlocState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is LoadingAccountBlocState) {
            return Center(
              child: RefreshProgressIndicator(),
            );
          }
          if (currentState is ErrorAccountBlocState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          if (currentState is InAccountBlocState) {
            final account = currentState.accountModel;
            print(account);
            return UserProfilePage(model: account);
          }
        });
  }
}
