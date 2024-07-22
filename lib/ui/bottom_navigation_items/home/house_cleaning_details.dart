import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/data/model/response/sub_category_model.dart';
import 'package:flutter_demo_structure/ui/bottom_navigation_items/home/store/home_store.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../widget/app_image.dart';

@RoutePage()
class HouseCleaningDetailsPage extends StatefulWidget {
  final int id;
  final String tag;
  final String image;
  final String description;

  const HouseCleaningDetailsPage({
    super.key,
    required this.id,
    required this.tag,
    required this.image,
    required this.description,
  });

  @override
  State<HouseCleaningDetailsPage> createState() =>
      _HouseCleaningDetailsPageState();
}

class _HouseCleaningDetailsPageState extends State<HouseCleaningDetailsPage> {
  List<ReactionDisposer>? _disposer;
  List<SubcategoryListModel>? subcategoryList;

  @override
  void didChangeDependencies() {
    addDisposer();
    super.didChangeDependencies();
  }

  Future callApiSubcategoryData() async {
    var req = Map.of({S.of(context).categoryid: "${widget.id}"});
    return await homeStore.subcategoryData(req);
  }

  void addDisposer() {
    _disposer ??= [
      reaction((_) => homeStore.subcategoryResponse, (res) {
        subcategoryList = res?.data;
      }),
      reaction((_) => homeStore.errorMessage, (String? error) {
        if (error != null || error!.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
      })
    ];
  }

  removeDisposer() {
    for (var element in _disposer!) {
      element.reaction.dispose();
    }
  }

  @override
  void dispose() {
    super.dispose();
    removeDisposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.detailsBgColor,
      body: FutureBuilder(
        future: callApiSubcategoryData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              if (snapshot.error == S.of(context).noActiveInternetConnection) {
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
                      S
                          .of(context)
                          .pleaseCheckYourInternetConnectivityAndTryAgain,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: textRegular.copyWith(
                          fontSize: 14.spMin, color: AppColor.black),
                    ).wrapPaddingHorizontal(50),
                    10.verticalSpace,
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColor.green),
                        ),
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text(
                          S.of(context).retry,
                          style: textRegular.copyWith(
                              fontSize: 14.spMin, color: AppColor.white),
                        )),
                  ],
                );
              } else {
                return Center(child: Text("${snapshot.error}"));
              }
            } else {
              return NestedScrollView(
                floatHeaderSlivers: false,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverLayoutBuilder(
                      builder: (context, constraints) {
                        return SliverAppBar(
                          backgroundColor: AppColor.white,
                          leading: IconButton(
                            onPressed: () {
                              context.router.maybePop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 24.r,
                              color: AppColor.black,
                            ).wrapPaddingOnly(left: 20),
                          ),
                          expandedHeight: 177,
                          stretch: true,
                          pinned: true,
                          systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: AppImage(
                              url: widget.image,
                              boxFit: BoxFit.fill,
                              placeHolder: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.transparent,
                                child: Container(
                                  height: 177.h,
                                  width: double.infinity,
                                  color: AppColor.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      19.verticalSpace,
                      Text(
                        widget.tag.replaceAll(r"_", " ").toTitleCase(),
                        style: textSemiBold.copyWith(
                            fontSize: 22.spMin,
                            color: AppColor.cleaningGradiantColor),
                      ),
                      4.verticalSpace,
                      Text(
                        widget.description,
                        style: textRegular.copyWith(
                            fontSize: 14.spMin,
                            color: AppColor.dropDownTextColor),
                      ).wrapPaddingRight(15),
                      23.verticalSpace,
                      Text(
                        "Available ${widget.tag.replaceAll(r"_", " ").toTitleCase()} services",
                        style: textSemiBold.copyWith(
                            fontSize: 14.spMin,
                            color: AppColor.cleaningGradiantColor),
                      ),
                      20.verticalSpace,
                      serviceListView(subcategoryList!),
                      44.verticalSpace,
                    ],
                  ).wrapPaddingOnly(left: 21, right: 19),
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget serviceListView(List<SubcategoryListModel> subcategoryList) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: subcategoryList.length,
      itemBuilder: (context, index) {
        SubcategoryListModel serviceData = subcategoryList[index];
        return Container(
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(10).r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage(
                url: serviceData.image,
                height: 69,
                width: 69,
                radius: 4.r,
                boxFit: BoxFit.fill,
                placeHolder: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 165.h,
                    width: 165.w,
                    color: AppColor.grey,
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            serviceData.name ??
                                "Full ${widget.tag.replaceAll(r"_", " ").toTitleCase()} Service",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textSemiBold.copyWith(
                                fontSize: 14.spMin,
                                color: AppColor.headingTextColor),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.router
                                .push(ServiceListDetailsRoute(
                                    image: '${serviceData.image}',
                                    desc: '${serviceData.description}',
                                    tag: widget.tag))
                                .then((_) {
                              setState(() {});
                            });
                          },
                          child: Text(
                            S.of(context).readMore,
                            style: textRegular.copyWith(
                                fontSize: 12.spMin, color: AppColor.green),
                          ).wrapPaddingOnly(left: 10),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    Text(
                      serviceData.description.isEmpty
                          ? S
                              .of(context)
                              .loremIpsumIsSimplyDummyTextOfThePrintingAnd
                          : serviceData.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textRegular.copyWith(
                          fontSize: 12.spMin,
                          color: AppColor.starNonSelectedColor),
                    )
                  ],
                ),
              ),
            ],
          ).wrapPaddingOnly(top: 10, left: 10, right: 19, bottom: 12),
        ).wrapPaddingOnly(bottom: 15);
      },
    );
  }
}
