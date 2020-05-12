//This shows good app architecture using StreamBuilder
//with our ui and logic separated
import 'package:flutter/material.dart';
import 'package:flutterarchitecture/home_event.dart';
import 'package:flutterarchitecture/home_model.dart';
import 'package:flutterarchitecture/home_state.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeModel model = HomeModel();

  @override
  void initState() {
    model.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          model.dispatch(
            FetchData(
              hasError: true,
            ),
          );
        },
        label: Text('Push Me'),
      ),
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
          stream: model.homeState,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // error ui
            if (snapshot.hasError) {
              return _getInformationMessage(snapshot.error);
            }

            var homeState = snapshot.data;
            // Busy fetching data
            if (!snapshot.hasData || homeState is BusyHomeState) {
              return Center(child: CircularProgressIndicator());
            }

            // When empty data is returned
            if (homeState is DataFetchedHomeState) {
              if (!homeState.hasData) {
                return _getInformationMessage(
                    'No data found for your account. Add something and check back.');
              }
            }

            // Build list if we have data
            return ListView.builder(
              itemCount: homeState.data.length,
              itemBuilder: (buildContext, index) =>
                  _getListItemUi(index, homeState.data),
            );
          }),
    );
  }

  Widget _getListItemUi(int index, List<String> listItems) {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Colors.grey[600]),
      child: Center(
        child: Text(
          listItems[index],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getInformationMessage(String message) {
    return Center(
        child: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey[500]),
    ));
  }
}
