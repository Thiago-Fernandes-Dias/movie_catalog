import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionState {
  final bool isConnected;
  final bool online;

  const InternetConnectionState({this.isConnected = true, this.online = true});
}

abstract class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit() : super(const InternetConnectionState());

  void listenToConnectionState();

  void stopListening();
}

class InternetConnectionCubitImpl extends InternetConnectionCubit {
  InternetConnectionCubitImpl({
    Connectivity? connectivity,
    InternetConnectionCheckerPlus? internetConnectionChecker,
  })  : _connectivity = connectivity ?? Connectivity(),
        _internetConnectionChecker = internetConnectionChecker ?? InternetConnectionCheckerPlus();

  late final Connectivity _connectivity;
  late final InternetConnectionCheckerPlus _internetConnectionChecker;

  StreamSubscription<InternetConnectionStatus>? _internetConnectionListener;
  StreamSubscription<ConnectivityResult>? _connectivityListener;

  @override
  void listenToConnectionState() {
    _connectivityListener = _connectivity.onConnectivityChanged.listen((result) {
      final allowedResults = [
        ConnectivityResult.wifi,
        ConnectivityResult.mobile,
        ConnectivityResult.ethernet,
        ConnectivityResult.vpn,
      ];
      if (!allowedResults.contains(result))
        emit(const InternetConnectionState(online: false, isConnected: false));
      else
        emit(const InternetConnectionState(isConnected: true));
    });
    _internetConnectionListener = _internetConnectionChecker.onStatusChange.listen((status) {
      emit(InternetConnectionState(online: status == InternetConnectionStatus.connected));
    });
  }

  @override
  void stopListening() {
    _internetConnectionListener?.cancel();
    _connectivityListener?.cancel();
  }
}
