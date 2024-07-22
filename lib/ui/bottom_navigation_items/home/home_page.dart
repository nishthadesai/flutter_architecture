import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/data/model/response/category_model.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/home/store/home_store.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../values/export.dart';
import '../../../widget/app_image.dart';
import '../../../widget/base_app_bar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int count = 3;

class _HomePageState extends State<HomePage> {
  String? dropDownValue;
  CategoryModel? response;

  void addDisposer() {
    homeStore.disposer ??= [
      reaction((_) => homeStore.categoryResponse, (res) {
        response = res?.data;
      }),
    ];
  }

  @override
  void didChangeDependencies() {
    addDisposer();
    super.didChangeDependencies();
  }

  removeDisposer() {
    for (var element in homeStore.disposer!) {
      element.reaction.dispose();
    }
  }

  @override
  void dispose() {
    super.dispose();
    removeDisposer();
  }

  @override
  void initState() {
    checkLocation();
    super.initState();
  }

  Future checkLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await getCurrentLocation();
  }

  Future getCurrentLocation() async {
    homeStore.isLoading = true;
    await homeStore.getCurrentPosition();
    homeStore.isLoading = false;
    callApiHelpData();
  }

  void callApiHelpData() async {
    var req = Map.of({
      S.current.latitude: "${homeStore.currentPosition?.latitude}",
      S.current.longitude: "${homeStore.currentPosition?.longitude}"
    });

    await homeStore.categoryData(req);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Observer(builder: (context) {
      if (homeStore.isLoading == true) {
        return Center(
            child: CircularProgressIndicator(
          color: AppColor.green,
        ));
      } else if (homeStore.errorMessage != null) {
        debugPrint(homeStore.errorMessage);
        if (homeStore.errorMessage ==
            S.of(context).noActiveInternetConnection) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                Assets.imageNoInternet,
                fit: BoxFit.fill,
                height: 150.h,
              )),
              Text(
                S.of(context).noConnection,
                style: textBold.copyWith(
                    fontSize: 16.spMin, color: AppColor.black),
              ),
              10.verticalSpace,
              Text(
                S.of(context).pleaseCheckYourInternetConnectivityAndTryAgain,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: textRegular.copyWith(
                    fontSize: 14.spMin, color: AppColor.black),
              ).wrapPaddingHorizontal(50),
              10.verticalSpace,
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.green),
                  ),
                  onPressed: () {
                    callApiHelpData();
                  },
                  child: Text(
                    S.of(context).retry,
                    style: textRegular.copyWith(
                        fontSize: 14.spMin, color: AppColor.white),
                  )),
            ],
          );
        } else {
          return Center(child: Text(homeStore.errorMessage.toString()));
        }
      } else if (homeStore.categoryResponse != null) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: BaseAppBar(
            centerTitle: false,
            showTitle: true,
            titleWidget: Row(
              children: [
                InkWell(
                  onTap: () {
                    homeStore.launchURL();
                  },
                  child: Image.asset(
                    Assets.imageLocationIcon,
                    height: 20.h,
                    width: 20.w,
                  ).wrapPaddingOnly(top: 13, bottom: 13),
                ),
                5.horizontalSpace,
                Observer(builder: (context) {
                  return Flexible(
                    child: Text(
                      homeStore.currentAddress,
                      maxLines: 1,
                      softWrap: false,
                      style: textMedium.copyWith(
                          color: AppColor.dropDownTextColor,
                          fontSize: 14.spMin),
                    ),
                  );
                }),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 30)
                              .r,
                          color: AppColor.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 3.h,
                                width: 40.w,
                                color: AppColor.black,
                              ),
                              15.verticalSpace,
                              Text(
                                "${homeStore.fullAddress}",
                                maxLines: 5,
                                style: textMedium.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.dropDownTextColor),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 12.r,
                  ).wrapPaddingOnly(left: 10, right: 10),
                ),
              ],
            ),
            backgroundColor: AppColor.white,
            action: [
              Image.asset(
                Assets.imageLike,
                height: 24.h,
                width: 24.w,
              ).wrapPaddingOnly(
                top: 9,
                bottom: 9,
                right: 15,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.imageMessages,
                    height: 24.h,
                    width: 24.w,
                  ).wrapPaddingOnly(top: 9, bottom: 9, right: 15),
                  Container(
                    margin: EdgeInsets.only(
                      top: 3,
                      bottom: 22,
                    ),
                    alignment: Alignment.topRight,
                    height: 17.h,
                    width: 17.h,
                    decoration: BoxDecoration(
                      color: AppColor.lightRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: textBold.copyWith(fontSize: 10.spMin),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.imageNotification,
                    height: 24.h,
                    width: 24.w,
                  ).wrapPaddingOnly(top: 9, bottom: 9, right: 21),
                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 22, right: 4),
                    alignment: Alignment.topRight,
                    height: 17.h,
                    width: 17.h,
                    decoration: BoxDecoration(
                      color: AppColor.lightRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: textBold.copyWith(fontSize: 10.spMin),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  27.verticalSpace,
                  Text(
                    S.of(context).popularProjectsInYourArea,
                    style: textSemiBold.copyWith(
                        fontSize: 16.spMin, color: AppColor.headingTextColor),
                  ).wrapPaddingOnly(left: 20),
                  15.verticalSpace,

                  ///popular projects list view
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: popularProjectsListView(),
                  ),
                  20.verticalSpace,
                  Text(
                    S.of(context).iNeedHelpWith,
                    style: textSemiBold.copyWith(
                        fontSize: 16.spMin, color: AppColor.headingTextColor),
                  ).wrapPaddingOnly(left: 20),
                  15.verticalSpace,
                  needHelpGridView(context),
                  30.verticalSpace,
                  Text(
                    S.of(context).featuredHelpers,
                    style:
                        textSemiBold.copyWith(color: AppColor.headingTextColor),
                  ).wrapPaddingOnly(left: 20),
                  15.verticalSpace,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          height: height < 600 ? 360.h : 318.h,
                          child: Row(
                            children: [
                              featureHelperListview(height),
                            ],
                          ),
                        ),
                        Container(
                          height: height < 600 ? 360.h : 310.h,
                          width: 20.w,
                        )
                      ],
                    ),
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget popularProjectsListView() {
    return Row(
      children: List.generate(
        response?.popluarProjectList.length ?? 0,
        (index) {
          PopluarProjectList? data = response?.popluarProjectList[index];
          return Container(
            height: 161.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AppImage(
                  url: data?.image ?? Assets.imageGiftWrapping,
                  width: 306.w,
                  height: 161.h,
                  radius: 10.r,
                  boxFit: BoxFit.fill,
                  placeHolder: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
                Container(
                  width: 306.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                        .r,
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.headingTextColor.withOpacity(0),
                        AppColor.headingTextColor
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      S.current.tasksAroundTheHouse,
                      style: textSemiBold.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.giftWrapping,
                          style: textSemiBold.copyWith(
                            fontSize: 22.spMin,
                            color: AppColor.white,
                          ),
                        ),
                        10.verticalSpace,
                        SizedBox(
                          height: 23.r,
                          width: 133.r,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape:
                                  WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5).r,
                              )),
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColor.green),
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Text(S.current.avgPrice200Dkk,
                                  style: textMedium.copyWith(
                                      color: AppColor.white,
                                      fontSize: 12.spMin)),
                            ),
                          ),
                        ).wrapPaddingOnly(bottom: 12.5),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ).wrapPaddingOnly(
              left: 20,
              right: response?.popluarProjectList.length == index + 1 ? 20 : 0);
        },
      ),
    );
  }

  Widget needHelpGridView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
      itemCount: response?.categories.length,
      itemBuilder: (context, index) {
        Category? helpData = response?.categories[index];
        return InkWell(
          onTap: () {
            context.router
                .push(HouseCleaningDetailsRoute(
              id: helpData!.id,
              tag: helpData.tag,
              image: helpData.image,
              description: helpData.description,
            ))
                .then((_) {
              setState(() {});
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10).r,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: AppColor.black.withOpacity(0.25),
                  blurRadius: 4.r,
                ),
              ],
            ),
            child: Stack(
              children: [
                AppImage(
                  url: helpData?.image,
                  height: double.infinity,
                  width: double.infinity,
                  radius: 10.r,
                  boxFit: BoxFit.fill,
                  placeHolder: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                        .r,
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.petCareGradiantColor.withOpacity(0),
                        AppColor.cleaningGradiantColor
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpData?.tag.replaceAll(r"_", " ").toTitleCase() ??
                          S.of(context).noDataFound,
                      style: textSemiBold.copyWith(
                          fontSize: 18.spMin, color: AppColor.white),
                    ),
                    8.verticalSpace,
                    Text(
                      "120 -320 dkk/hour",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textMedium.copyWith(
                          fontSize: 12.spMin, color: AppColor.white),
                    ).wrapPaddingRight(15),
                    14.verticalSpace,
                  ],
                ).wrapPaddingOnly(left: 15, right: 10),
              ],
            ),
          ),
        );
      },
    ).wrapPaddingOnly(right: 20, left: 20);
  }

  Widget featureHelperListview(double height) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: response?.serviceProvider.length,
      itemBuilder: (context, index) {
        ServiceProvider? helperData = response?.serviceProvider[index];
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                color: AppColor.black.withOpacity(0.10),
                blurRadius: 20.r,
              ),
            ],
            borderRadius: BorderRadius.circular(10).r,
            color: AppColor.white,
          ),
          width: 262.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppImage(
                    url: helperData?.profileImage ?? Assets.imageHelper,
                    height: height < 600 ? 62.h : 50.h,
                    width: 50.w,
                    radius: 10.r,
                    placeHolder: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.transparent,
                      child: Container(
                        height: height < 600 ? 62.h : 34.h,
                        width: 50.w,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Container(
                    width: 170.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            helperData?.fullName ?? S.current.jasonRoy,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textBold.copyWith(
                                fontSize: 14.spMin,
                                color: AppColor.reviewerNameColor),
                          ),
                        ),
                        6.48.verticalSpace,
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RatingBarIndicator(
                                rating: helperData?.rating.toDouble() ?? 4,
                                itemBuilder: (BuildContext context, int index) {
                                  return Icon(
                                    Icons.star,
                                    color: AppColor.starYellowColor,
                                  );
                                },
                                itemCount: 5,
                                itemSize: 12.r,
                                direction: Axis.horizontal,
                              ),
                              4.horizontalSpace,
                              Flexible(
                                child: Text(
                                  "${helperData?.totalReview.toString()} reviews",
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textRegular.copyWith(
                                      fontSize: 10.spMin,
                                      color: AppColor.starNonSelectedColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        3.verticalSpace,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Assets.imageLocationIcon,
                              height: 10.h,
                              width: 10.w,
                            ),
                            2.horizontalSpace,
                            Flexible(
                              child: Text(
                                helperData?.fullAddress ?? S.current.newyorkUsa,
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textRegular.copyWith(
                                    fontSize: 10.spMin,
                                    color: AppColor.lightGreyColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ).wrapPaddingOnly(left: 16, right: 15),
              10.verticalSpace,
              Container(
                height: 34.h,
                child: Text(
                  helperData?.aboutMe ??
                      S.of(context).iAmThoroughFriendlyAndHonestIWillLeaveYour,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.canIHelpColor),
                ).wrapPaddingOnly(left: 16, right: 15),
              ),
              15.verticalSpace,
              Container(
                height: height < 600 ? 142.h : 126.h,
                width: double.infinity,
                color: AppColor.canIHelpColor.withOpacity(0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).iCanHelpYouWith,
                      style: textSemiBold.copyWith(
                          fontSize: 13.spMin, color: AppColor.green),
                    ),
                    16.verticalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        helperData!.categories.length,
                        (index) {
                          Category data = helperData.categories[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.tag.replaceAll(r"_", " ").toTitleCase(),
                                style: textRegular.copyWith(
                                    fontSize: 12.spMin,
                                    color: AppColor.headingTextColor),
                              ),
                              Text(
                                S.of(context).DkkHour,
                                style: textMedium.copyWith(
                                    fontSize: 12.spMin, color: AppColor.green),
                              ),
                            ],
                          ).wrapPaddingBottom(12);
                        },
                      ),
                    )
                  ],
                ).wrapPaddingOnly(top: 13, left: 16, right: 15),
              ),
              15.verticalSpace,
              Text(
                helperData.review ??
                    S.of(context).sanneWasWonderfulWithMySonWhoNeededLovingCare,
                maxLines: 2,
                softWrap: false,
                style: textLight.copyWith(
                    fontSize: 12.spMin,
                    color: AppColor.headingTextColor,
                    fontStyle: FontStyle.italic),
              ).wrapPaddingOnly(left: 16, right: 6),
            ],
          ).wrapPaddingOnly(top: 15, bottom: 15),
        ).wrapPaddingOnly(
          top: 5,
          bottom: 5,
          left: 20,
        );
      },
    );
  }
}
