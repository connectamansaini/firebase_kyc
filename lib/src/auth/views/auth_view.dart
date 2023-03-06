import 'package:firebase_kyc/src/agent/bloc/agent_bloc.dart';
import 'package:firebase_kyc/src/auth/bloc/auth_bloc.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/home/views/home_view.dart';
import 'package:firebase_kyc/src/user/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isCreateUser = true;
  late final TextEditingController _controllerEmail;
  late final TextEditingController _controllerPassword;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.createWithEmailStatus is StatusSuccess) {
          context.read<AgentBloc>().add(AgentCreated(state.agent));
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
        if (state.signInWithEmailStatus is StatusSuccess) {
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
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agent Sign In'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              ElevatedButton(
                onPressed: () {
                  isCreateUser
                      ? context.read<AuthBloc>().add(
                            SignedInWithEmailAndPassword(
                              _controllerEmail.text,
                              _controllerPassword.text,
                            ),
                          )
                      : context.read<AuthBloc>().add(
                            CreatedUserWithEmailAndPassword(
                              _controllerEmail.text,
                              _controllerPassword.text,
                            ),
                          );
                },
                child: SizedBox(
                  width: 40.w,
                  child: Center(
                    child: Text(isCreateUser ? 'Login' : 'Register'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isCreateUser = !isCreateUser;
                  });
                },
                child: Text(
                  isCreateUser
                      ? "Don't have a Account, Register"
                      : 'Login instead',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
