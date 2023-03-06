import 'package:firebase_kyc/src/auth/bloc/auth_bloc.dart';
import 'package:firebase_kyc/src/auth/views/auth_view.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/user/blocs/create_user/create_user_bloc.dart';
import 'package:firebase_kyc/src/user/blocs/user/user_bloc.dart';
import 'package:firebase_kyc/src/user/repository/user_repository.dart';
import 'package:firebase_kyc/src/user/views/create_user_view.dart';
import 'package:firebase_kyc/src/user/views/detail_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (context) => const AuthView()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.usersStatus is StatusSuccess) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text('There are no entries in database'),
                );
              }
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(state.users[index].name),
                      subtitle: Text(state.users[index].email),
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailUserView(user: state.users[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            if (state.usersStatus is StatusFailure) {
              return const Center(child: Text('Failure'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      CreateUserBloc(context.read<UserRepository>()),
                  child: const CreateUserView(),
                ),
              ),
            );
          },
          label: const Text('Add User Details'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to Logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                context.read<AuthBloc>().add(SignedOut());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
