import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/home/store/home_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ShowUploadedImagePage extends StatefulWidget {
  const ShowUploadedImagePage({super.key});

  @override
  State<ShowUploadedImagePage> createState() => _ShowUploadedImagePageState();
}

class _ShowUploadedImagePageState extends State<ShowUploadedImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (context) {
        if (homeStore.imageResponse?.location != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 100.r,
                  width: 100.r,
                  child: Image.network(
                    homeStore.imageResponse!.location,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
