import 'package:firebase_kyc/src/agent/bloc/agent_bloc.dart';
import 'package:firebase_kyc/src/auth/bloc/auth_bloc.dart';
import 'package:firebase_kyc/src/auth/views/auth_view.dart';
import 'package:firebase_kyc/src/core/domain/enums.dart';
import 'package:firebase_kyc/src/core/domain/status.dart';
import 'package:firebase_kyc/src/image_picker/bloc/image_picker_bloc.dart';
import 'package:firebase_kyc/src/location/bloc/location_bloc.dart';
import 'package:firebase_kyc/src/permission/bloc/permission_bloc.dart';
import 'package:firebase_kyc/src/permission/repository/permission_repository.dart';
import 'package:firebase_kyc/src/user/blocs/create_user/create_user_bloc.dart';
import 'package:firebase_kyc/src/user/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    final state = context.read<PermissionBloc>().state;
    if (state.locationPermissionStatus == LocationPermissionStatus.granted) {
      context.read<LocationBloc>().add(LocationInfoRequested());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //*  If LocationInfo is successful
        //* then in CreateUser Location is changed.
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state.locationInfoStatus == Status.success()) {
              context
                  .read<CreateUserBloc>()
                  .add(LocationChanged(state.locationInfo));
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
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
        ),
        BlocListener<PermissionBloc, PermissionState>(
          listener: (context, state) {
            if (state.cameraPermissionStatus ==
                CameraPermissionStatus.permanentlyDenied) {
              context.read<PermissionRepository>().openSetting();
            }
            if (state.cameraPermissionStatus ==
                CameraPermissionStatus.granted) {
              // TODO(ask): If cameraPermission is already granted then what will happen in this listener
              context.read<ImagePickerBloc>().add(CameraPhotoPicked());
            }
          },
        ),
        BlocListener<ImagePickerBloc, ImagePickerState>(
          listener: (context, state) {
            if (state.cameraPhotoStatus == Status.success()) {
              if (state.pickedImage != null) {
                context
                    .read<CreateUserBloc>()
                    .add(ImageUploaded(file: state.pickedImage!));
              }
            }
          },
        ),
        BlocListener<CreateUserBloc, CreateUserState>(
          listenWhen: (previous, current) =>
              previous.uploadUserStatus != current.uploadUserStatus,
          listener: (context, state) {
            if (state.uploadUserStatus is StatusSuccess) {
              context.read<UserBloc>().add(UserAdded(state.user));
              nameController.clear();
              emailController.clear();
              phoneController.clear();

              FocusManager.instance.primaryFocus?.unfocus();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data Uploaded'),
                ),
              );

              Navigator.pop(context);
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insert Lead Here'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                BlocBuilder<CreateUserBloc, CreateUserState>(
                  builder: (context, state) {
                    if (state.imageUploadStatus == Status.success()) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 30.h,
                            width: 50.w,
                            child: Image.network(
                              state.user.url,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<PermissionBloc>()
                                    .add(CameraPermissionRequested());
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state.imageUploadStatus == Status.loading()) {
                      return SizedBox(
                        height: 30.h,
                        width: 50.w,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    return SizedBox(
                      height: 30.h,
                      width: 50.w,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Upload photo'),
                        // TODO(ask): Why this onPressed opens camera
                        onPressed: () {
                          context
                              .read<PermissionBloc>()
                              .add(CameraPermissionRequested());
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    context.read<CreateUserBloc>().add(NameChanged(value));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    context.read<CreateUserBloc>().add(EmailChanged(value));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email',
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextField(
                  controller: phoneController,
                  onChanged: (value) {
                    context.read<CreateUserBloc>().add(PhoneChanged(value));
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // On
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Phone No.',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<CreateUserBloc, CreateUserState>(
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed: () {
                if (state.user.isValid) {
                  context.read<CreateUserBloc>().add(
                        DataUploaded(context.read<AgentBloc>().state.agent.id),
                      );
                }
              },
              label: const Text('Submit'),
            );
          },
        ),
      ),
    );
  }
}
