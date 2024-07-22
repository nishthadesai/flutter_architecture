import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/home/store/home_store.dart';
import 'package:flutter_demo_structure/widget/show_message.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../generated/l10n.dart';
import '../../router/app_router.dart';
import '../../values/colors.dart';

@RoutePage()
class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).chooseImage),
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: AppColor.white,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                context.router.maybePop();
                                await checkPermission(context, "camera");
                              },
                              icon: Icon(Icons.camera_alt_outlined)),
                          IconButton(
                              onPressed: () async {
                                context.router.maybePop();
                                await checkPermission(context, "gallery");
                              },
                              icon: Icon(
                                  Icons.photo_size_select_actual_outlined)),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(S.of(context).pickAnImage),
            ),
          ),
          30.verticalSpace,
          Text(S.of(context).yourPickedImage),
          15.verticalSpace,
          Observer(builder: (context) {
            if (homeStore.imageResponse?.location != null) {
              return Container(
                height: 100.r,
                width: 100.r,
                child: Image.network(
                  homeStore.imageResponse!.location,
                  fit: BoxFit.fill,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(ShowUploadedImageRoute());
        },
        child: Icon(
          Icons.navigate_next,
          size: 25.r,
        ),
      ),
    );
  }

  Future checkPermission(BuildContext context, String s) async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.storage,
    ].request();
    PermissionStatus? cameraStatus = status[Permission.camera];
    PermissionStatus? storageStatus = status[Permission.storage];
    if (cameraStatus!.isGranted || storageStatus!.isGranted) {
      await getImage(s);
    } else {
      showMessage(S.of(context).permissionDeniedPleaseGivePermission);
    }
  }

  Future getImage(String s) async {
    XFile? selectedImage;
    if (s == 'camera') {
      selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      selectedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (selectedImage != null) {
      File pickedImage = File(selectedImage.path);
      await homeStore.uploadImage(pickedImage);
    } else {
      debugPrint(S.of(context).noImageSelected);
    }
  }
}
