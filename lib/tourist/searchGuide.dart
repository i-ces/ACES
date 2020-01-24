import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/guides_bloc.dart';
import 'package:ghumnajaam/account_bloc/index.dart';
import 'package:ghumnajaam/profile/other_profile.dart';

class GuidesSearch extends StatelessWidget {
  Widget guideView(List<AccountModel> guide) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 10.0),
      shrinkWrap: true,
      itemCount: guide.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.only(bottom: 20, right: 20),
          elevation: 3.0,
          child: new ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(guide[index].profilepic),
              ),
              title: new Text(
                guide[index].firstName + " " + guide[index].lastName,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlutterRatingBarIndicator(
                        rating: guide[index].rating,
                        itemCount: 5,
                        itemSize: 18.0,
                        physics: NeverScrollableScrollPhysics(),
                        emptyColor: Colors.amber.withAlpha(50),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Container(
                width: 60,
                child: OutlineButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OtherProfilePage(model: guide[index])));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(60))),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.lightBlue,
                  ),
                  color: Colors.lightBlueAccent,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OtherProfilePage(model: guide[index])));
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBlocBloc, AccountBlocState>(builder: (
      BuildContext context,
      currentState,
    ) {
      if (currentState is LoadGuidesBlocState) {
        return SafeArea(
            child: Center(
          child: CircularProgressIndicator(),
        ));
      }
      if (currentState is LoadingGuidesBlocState) {
        return SafeArea(
            child: Center(
          child: RefreshProgressIndicator(),
        ));
      }
      if (currentState is ErrorGuidesBlocState) {
        return new Container(
            child: new Center(
          child: new Text(currentState.errorMessage ?? 'Error'),
        ));
      }
      if (currentState is LoadedGuidesListState) {
        final List<AccountModel> guides = currentState.guidesList;
        print(guides[0]);
        return guideView(guides);
      }
    });
  }
}
