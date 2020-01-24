import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ghumnajaam/login_bloc/login_bloc.dart';
import 'package:ghumnajaam/trip/index.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;
  TripBloc(this.tripRepository);

  TripState get initialState => new InTripState();

  @override
  Stream<TripState> mapEventToState(
    TripEvent event,
  ) async* {
    if (event is AddTripButtonPressed) {
      yield TripLoading();
      try {
        print("called");
        bool result = await tripRepository.insertTrip(
            day: event.days,
            place: event.address,
            placeId: event.placeId,
            rating: event.rating,
            description: event.description,
            images: event.images);
        if (result == true) {
          yield UnTripState();
        } else {
          yield InTripState();
        }
      } catch (e) {
        yield ErrorTripState(e);
      }
    }
  }
}
