import 'package:flutter/widgets.dart';

class HomeState {}

class InitializedHomeState extends HomeState {}

class DataFetchedHomeState extends HomeState {
  DataFetchedHomeState({@required this.data});

  final List<String> data;

  bool get hasData => data.isNotEmpty;
}

class BusyHomeState extends HomeState {}

class ErrorHomeState extends HomeState {}
