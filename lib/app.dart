import 'package:firebase_kyc/src/agent/bloc/agent_bloc.dart';
import 'package:firebase_kyc/src/agent/repository/agent_repository.dart';
import 'package:firebase_kyc/src/auth/bloc/auth_bloc.dart';
import 'package:firebase_kyc/src/auth/repository/auth_repository.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/core/presentation/theme.dart';
import 'package:firebase_kyc/src/image_picker/bloc/image_picker_bloc.dart';
import 'package:firebase_kyc/src/image_picker/repository/image_picker_repository.dart';
import 'package:firebase_kyc/src/location/bloc/location_bloc.dart';
import 'package:firebase_kyc/src/location/repository/location_repository.dart';
import 'package:firebase_kyc/src/permission/bloc/permission_bloc.dart';
import 'package:firebase_kyc/src/permission/repository/permission_repository.dart';
import 'package:firebase_kyc/src/start_up/views/start_up_view.dart';
import 'package:firebase_kyc/src/user/blocs/user/user_bloc.dart';
import 'package:firebase_kyc/src/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //This is providing repository to the whole app.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocationRepository(),
        ),
        RepositoryProvider(
          create: (context) => PermissionRepository(),
        ),
        RepositoryProvider(
          create: (context) => ImagePickerRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => AgentRepository(),
        )
      ],
      //This is initializing bloc at the starting of the app
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LocationBloc(context.read<LocationRepository>()),
          ),
          //*1 LocationPermission is requested.
          BlocProvider(
            create: (context) =>
                PermissionBloc(context.read<PermissionRepository>())
                  ..add(LocationPermissionRequested()),
          ),
          BlocProvider(
            create: (context) =>
                ImagePickerBloc(context.read<ImagePickerRepository>()),
          ),
          BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>())
              ..add(IsAuthenticated()),
          ),
          BlocProvider(
            create: (context) => AgentBloc(context.read<AgentRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MultiBlocListener(
              listeners: [
                //*2 If Authenticated then AgentReceived from
                //*Auth (SignIn or Create).
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.authStatus == AuthStatus.authenticated) {
                      //Agent is Received in agentBloc
                      context.read<AgentBloc>().add(AgentReceived(state.agent));
                    }
                  },
                ),

                //*3: If LocationPermission is permanently denied then
                //*  setting is opened.
                BlocListener<PermissionBloc, PermissionState>(
                  listener: (context, state) {
                    if (state.locationPermissionStatus ==
                        LocationPermissionStatus.permanentlyDenied) {
                      context.read<PermissionRepository>().openSetting();
                    }
                  },
                ),
              ],
              child: Sizer(
                builder: (context, orientation, deviceType) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: AppThemes.lightTheme,
                    //*5: StartUpView  is Shown when these
                    //*   above listeners are running.
                    home: const StartUpView(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
