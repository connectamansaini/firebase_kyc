import 'package:firebase_kyc/src/auth/bloc/auth_bloc.dart';
import 'package:firebase_kyc/src/auth/views/auth_view.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/home/views/home_view.dart';
import 'package:firebase_kyc/src/user/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.authStatus !=
          current.authStatus, //This is used to save resources

      //* Step6: If authenticated then Users is Requested after
      //*       giving agentId and HomeView is shown.
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authenticated) {
          context.read<UserBloc>().add(UsersRequested(state.agent.id));
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomeView();
              },
            ),
          );
        }
        //* Step6.1 : If Unauthenticated then AuthView is shown.
        if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AuthView();
              },
            ),
          );
        }
      },
      //Scaffold is heavy material is used
      child: Material(
        child: Center(
          child: FlutterLogo(
            size: 20.w,
          ),
        ),
      ),
    );
  }
}
