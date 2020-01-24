import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TripState extends Equatable {
  TripState([Iterable props]) : super();

  /// Copy object for use in action
  TripState getStateCopy();
}

/// UnInitialized
class UnTripState extends TripState {
  @override
  String toString() => 'UnTripState';

  @override
  TripState getStateCopy() {
    return UnTripState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InTripState extends TripState {
  @override
  String toString() => 'InTripState';

  @override
  TripState getStateCopy() {
    return InTripState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class TripLoading extends TripState {
  @override
  String toString() => 'TripLoading';

  @override
  TripState getStateCopy() {
    return TripLoading();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorTripState extends TripState {
  final String errorMessage;

  ErrorTripState(this.errorMessage);

  @override
  String toString() => 'ErrorTripState';

  @override
  TripState getStateCopy() {
    return ErrorTripState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
