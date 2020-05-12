import 'dart:async';

import 'package:flutterarchitecture/home_event.dart';
import 'package:flutterarchitecture/home_state.dart';

/*
Deprecated: We now use [HomeState]
//Values for the state of our data
enum HomeViewState {
  Busy,
  DataRetrieved,
  NoData,
}*/

class HomeModel {
  // Controller for the stream
  StreamController<HomeState> _stateController = StreamController<HomeState>();

  // Items that are retrieved
  List<String> _listItems;

  // -- Public interface for the home model --
  Stream<HomeState> get homeState => _stateController.stream;

  void dispatch(HomeEvent event) {
    print('Event dispatched: $event');
    if (event is FetchData) {
      _getListData(
        hasError: event.hasError,
        hasData: event.hasData,
      );
    }
  }

  // Actual business logic
  Future _getListData({
    bool hasError = false,
    bool hasData = true,
  }) async {
    _stateController.add(BusyHomeState());
    await Future.delayed(Duration(seconds: 2));

    if (hasError) {
      return _stateController.addError(
          'An error occurred while fetching the data. Please try again later.');
    }

    if (!hasData) {
      return _stateController.add(DataFetchedHomeState(data: <String>[]));
    }

    _listItems = List<String>.generate(10, (index) => '$index title');
//    Data returned successfully
    _stateController.add(DataFetchedHomeState(data: _listItems));
  }
}
