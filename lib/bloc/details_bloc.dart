import 'dart:async';

import 'package:rxdart/rxdart.dart';

class DetailsBloc {
  DetailsBloc() {
    firstName.listen((event) {});
    lastName.listen((event) {});
    mobile.listen((event) {});
  }

  //  Behaviours subject stream controllers
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _mobile = BehaviorSubject<String>();

  //  Streams
  Stream<String> get firstName => _firstName.stream;
  Stream<String> get lastName => _lastName.stream;
  Stream<String> get mobile => _mobile.stream;
  Stream<bool> get submit => Rx.combineLatest3(firstName, lastName, mobile, (a, b, c) => true);

  String? getFirstName() {
    return _firstName.valueOrNull;
  }

  String? getLastname() {
    return _lastName.valueOrNull;
  }

  String? getMobile() {
    return _mobile.valueOrNull;
  }

  //  Observe any changes
  StreamSink<String> get observeFirstName => _firstName.sink;
  StreamSink<String> get observeLastName => _lastName.sink;
  StreamSink<String> get observeMobile => _mobile.sink;

  dispose() {
    _firstName.close();
    _lastName.close();
    _mobile.close();
  }
}
