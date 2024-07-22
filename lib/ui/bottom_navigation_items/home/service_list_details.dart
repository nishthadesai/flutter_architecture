import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/data/widgets/service_data.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';
import '../../../widget/app_image.dart';
import '../../../widget/custom_button.dart';

@RoutePage()
class ServiceListDetailsPage extends StatefulWidget {
  final String image;
  final String desc;
  final String tag;
  const ServiceListDetailsPage({
    super.key,
    required this.image,
    required this.desc,
    required this.tag,
  });

  @override
  State<ServiceListDetailsPage> createState() => _ServiceListDetailsPageState();
}

class _ServiceListDetailsPageState extends State<ServiceListDetailsPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? dropDownValue;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
  List<String> listOfFreq = [S.current.low, S.current.medium, S.current.high];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.detailsBgColor,
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverLayoutBuilder(
              builder: (context, constraints) {
                return SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 177,
                  pinned: true,
                  stretch: true,
                  leading: IconButton(
                    onPressed: () {
                      context.router.maybePop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.r,
                      color: AppColor.black,
                    ).wrapPaddingLeft(20),
                  ),
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
                          height: 177,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppColor.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    19.verticalSpace,
                    Text(
                      widget.tag.replaceAll(r"_", " ").toTitleCase(),
                      style: textSemiBold.copyWith(
                          fontSize: 18.spMin, color: AppColor.headingTextColor),
                    ).wrapPaddingLeft(7),
                    10.verticalSpace,
                    Text(
                      widget.desc,
                      maxLines: 3,
                      style: textRegular.copyWith(
                          fontSize: 16.spMin,
                          color: AppColor.starNonSelectedColor),
                    ).wrapPaddingOnly(left: 6),
                    18.verticalSpace,
                    ValueListenableBuilder(
                      valueListenable: isExpanded,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).details,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                              2.verticalSpace,
                              Text(
                                S.of(context).floorVacuumAndWash,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                              Text(
                                S.of(context).dustingAllSurfaces,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                              Text(
                                S.of(context).wipeDownOfCabinets,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                              Text(
                                S.of(context).BathroomCleaned,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                              Text(
                                S.of(context).KitchenCleaned,
                                style: textRegular.copyWith(
                                    fontSize: 16.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    4.verticalSpace,
                    InkWell(
                      onTap: () {
                        isExpanded.value = !isExpanded.value;
                      },
                      child: ValueListenableBuilder(
                        valueListenable: isExpanded,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Text(
                            value
                                ? S.of(context).readLess
                                : S.of(context).readMore,
                            style: textRegular.copyWith(
                                fontSize: 12.spMin, color: AppColor.green),
                          );
                        },
                      ),
                    ).wrapPaddingLeft(6),
                    14.verticalSpace,
                  ],
                ).wrapPaddingOnly(left: 14, right: 21),
              ),
              14.verticalSpace,
              Text(
                S.of(context).taskDetails,
                style: textSemiBold.copyWith(
                    fontSize: 14.spMin, color: AppColor.cleaningGradiantColor),
              ).wrapPaddingLeft(20),
              15.verticalSpace,
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).howOften,
                      style: textRegular.copyWith(
                          fontSize: 12.spMin,
                          color: AppColor.starNonSelectedColor),
                    ).wrapPaddingLeft(20),
                    7.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        color: AppColor.white,
                      ),
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: AppColor.white,
                        underline: SizedBox.shrink(),
                        value: dropDownValue,
                        hint: Text(
                          S.of(context).selectFrequencyForCleaning,
                          style: textRegular.copyWith(
                              color: AppColor.starNonSelectedColor,
                              fontSize: 15.spMin),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 14.r,
                        ),
                        items: listOfFreq.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: textMedium.copyWith(
                                    color: AppColor.dropDownTextColor,
                                    fontSize: 14.spMin),
                              ));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        },
                      ).wrapPaddingOnly(
                        left: 18,
                        right: 15,
                      ),
                    ).wrapPaddingSymmetric(horizontal: 20),
                  ],
                ),
              ),
              15.verticalSpace,
              Container(
                color: AppColor.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).additionalServices,
                      style: textSemiBold.copyWith(color: AppColor.black),
                    ),
                    20.verticalSpace,
                    Column(
                      children: List.generate(
                        4,
                        (index) {
                          ServiceData serviceData = serviceList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: AppColor.dropDownTextColor,
                                              width: 1.w),
                                          borderRadius:
                                              BorderRadius.circular(5).r),
                                      activeColor: AppColor.green,
                                      value: serviceData.isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          serviceData.isCheck = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      serviceData.name,
                                      maxLines: 1,
                                      style: textMedium.copyWith(
                                          fontSize: 14.spMin,
                                          color: AppColor.starNonSelectedColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                serviceData.time,
                                maxLines: 1,
                                style: textSemiBold.copyWith(
                                    fontSize: 14.spMin, color: AppColor.green),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    12.verticalSpace,
                    SizedBox(
                      height: 57.h,
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (dropDownValue == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColor.black,
                                content: Text(
                                  S.of(context).pleaseSelectFrequency,
                                  style: textBold.copyWith(
                                      fontSize: 14.spMin, color: AppColor.red),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          S.of(context).next,
                          style: textBold.copyWith(
                              color: AppColor.white, fontSize: 16.spMin),
                        ),
                      ),
                    ),
                  ],
                ).wrapPaddingOnly(top: 21, left: 20, right: 20, bottom: 31),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
