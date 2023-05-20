import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/internet_connection_cubit/internet_connection_cubit.dart';

class InternetVerifier extends StatelessWidget {
  const InternetVerifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _InternetVerifierBody());
  }
}

class _InternetVerifierBody extends StatefulWidget {
  @override
  State<_InternetVerifierBody> createState() => _InternetVerifierBodyState();
}

class _InternetVerifierBodyState extends State<_InternetVerifierBody> {
  PersistentBottomSheetController? _bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listener: (context, state) {
        if (_bottomSheetController != null) _bottomSheetController!.close();
        const color = Colors.grey;
        const padding = EdgeInsets.all(8);
        if (!state.isConnected)
          _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: color,
                padding: padding,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off),
                    SizedBox(width: 8),
                    Text(
                      'No network connection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          );
        else if (!state.online)
          _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: color,
                padding: padding,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public_off_outlined),
                    SizedBox(width: 8),
                    Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          );
      },
    );
  }
}
