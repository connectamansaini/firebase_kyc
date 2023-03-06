import 'package:firebase_kyc/src/user/models/user.dart';
import 'package:firebase_kyc/src/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DetailUserView extends StatelessWidget {
  const DetailUserView({
    required this.user,
    super.key,
  });
  final User user;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMEEEEd()
        .add_jms()
        .format(DateTime.fromMillisecondsSinceEpoch(user.time));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Detail'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade300,
              height: 40.h,
              width: double.infinity,
              child: Image.network(
                user.url,
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Name: ${user.name}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Email: ${user.email}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Phone no: ${user.phone}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Time: $date'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<UserRepository>().launchMap(user.lat, user.lon);
        },
        label: const Text('Location'),
      ),
    );
  }
}
