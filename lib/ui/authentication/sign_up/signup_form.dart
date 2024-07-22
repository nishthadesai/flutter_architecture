import 'package:auto_route/auto_route.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_demo_structure/widget/base_app_bar.dart';
import 'package:flutter_demo_structure/widget/show_message.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../widget/app_text_filed.dart';
import '../../../widget/custom_button.dart';
import '../store/authentication_store.dart';

@RoutePage()
class SignUpFormPage extends StatefulWidget {
  const SignUpFormPage({super.key});

  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  ValueNotifier<bool> isBilling = ValueNotifier(false);
  ValueNotifier<bool> isPolicy = ValueNotifier(false);
  ValueNotifier<String> currentValue = ValueNotifier("");
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void callSignupApi() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var req = Map.of({
      "first_name": "${firstNameController.text}",
      "last_name": "${lastNameController.text}",
      "email": "${emailController.text}",
      "login_type": "S",
      "device_type": "A",
      "device_token": "123456",
      "vat_number": "${vatController.text}",
      "country_code": "+91",
      "phone": "${numberController.text}",
      "password": "${passwordController.text}",
      "confirm_password": "${cPasswordController.text}",
      "latitude": "23.1013",
      "longitude": "72.5407"
    });

    await authenticStore.signUp(req).then(
      (value) {
        if (authenticStore.signupResponse?.code == 1) {
          callOtpApi();
        }
      },
    );
  }

  void callOtpApi() async {
    var req = Map.of({
      "send_otp_for": "Update",
      "country_code": "+91",
      "phone": "1230006741",
      "user_id": "1"
    });
    await authenticStore.checkOtp(req).then((value) {
      if (authenticStore.otpResponse?.code == 1) {
        verificationBottomSheet();
      }
    });
  }

  void callResendOtpApi() async {
    var req = Map.of({
      "send_otp_for": "Update",
      "country_code": "+91",
      "phone": "1230006741",
      "user_id": "1"
    });
    await authenticStore.checkOtp(req);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.detailsBgColor,
      appBar: buildAppBar(),
      body: buildView(context),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return BaseAppBar(
      backgroundColor: AppColor.white,
      leadingIcon: true,
      leadingWidget: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24.r,
        ).wrapPaddingLeft(13),
        onPressed: () {
          context.router.maybePop();
        },
      ),
      showTitle: true,
      centerTitle: true,
      titleWidget: Text(
        S.of(context).signUp.toTitleCase(),
        style: textBold.copyWith(
            fontSize: 18.spMin, color: AppColor.headingTextColor),
      ),
    );
  }

  Widget buildView(BuildContext context) {
    return Observer(builder: (context) {
      if (authenticStore.isLoading == true) {
        return Center(child: CircularProgressIndicator());
      } else if (authenticStore.errorMessage != null) {
        debugPrint(authenticStore.errorMessage);
        if (authenticStore.errorMessage ==
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
                    callSignupApi();
                  },
                  child: Text(
                    S.of(context).retry,
                    style: textRegular.copyWith(
                        fontSize: 14.spMin, color: AppColor.white),
                  )),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      } else {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                Text(
                  S.of(context).profileInformation,
                  style: textSemiBold.copyWith(
                      fontSize: 16.spMin, color: AppColor.headingTextColor),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).firstName,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  controller: firstNameController,
                  validators: firstNameValidator,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterFirstName,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Image.asset(
                    Assets.imageAccount,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(left: 15, top: 15, bottom: 15, right: 15),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).lastName,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  controller: lastNameController,
                  validators: lastNameValidator,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterLastName,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Image.asset(
                    Assets.imageAccount,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(left: 15, top: 15, bottom: 15, right: 15),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).mobileNumber,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: numberController,
                  validators: mobileValidator,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  maxLength: 10,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterMobileNumber,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Assets.imageMobileIcon,
                        height: 20.r,
                        width: 20.r,
                        fit: BoxFit.fill,
                      ).wrapPaddingOnly(
                        left: 15,
                        top: 15,
                        bottom: 15,
                      ),
                      CountryCodePicker(
                        closeIcon: Icon(Icons.close),
                        showDropDownButton: true,
                        enabled: true,
                        padding: EdgeInsets.zero,
                        initialSelection: S.of(context).dk,
                        favorite: const ['+91', 'IN'],
                        showFlag: false,
                      ),
                    ],
                  ),
                ),
                30.verticalSpace,
                Text(
                  S.of(context).loginInformation,
                  style: textSemiBold.copyWith(
                      fontSize: 16.spMin, color: AppColor.headingTextColor),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).email,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  controller: emailController,
                  validators: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterEmail,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Image.asset(
                    Assets.imageIcon,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(left: 15, top: 15, bottom: 15, right: 15),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).password,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  obscureText: true,
                  controller: passwordController,
                  validators: passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterPassword,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Image.asset(
                    Assets.imageLockIcon,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingAll(15),
                  suffixIcon: Image.asset(
                    Assets.imagePassword,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(top: 15, right: 17, bottom: 18, left: 80),
                ),
                15.verticalSpace,
                Text(
                  S.of(context).confirmPassword,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  obscureText: true,
                  controller: cPasswordController,
                  validators: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).enterConfirmPassword;
                    } else if (passwordController.text !=
                        cPasswordController.text) {
                      return S.of(context).confirmPasswordMustBeSameAsPassword;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAction: TextInputAction.done,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterConfirmPassword,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  prefixIcon: Image.asset(
                    Assets.imageLockIcon,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(left: 15, top: 15, bottom: 15, right: 15),
                  suffixIcon: Image.asset(
                    Assets.imagePassword,
                    height: 20.r,
                    width: 20.r,
                    fit: BoxFit.fill,
                  ).wrapPaddingOnly(top: 15, right: 17, bottom: 18, left: 80),
                ),
                30.verticalSpace,
                Text(
                  S.of(context).billingAndPaymentDetails,
                  style: textSemiBold.copyWith(
                      fontSize: 16.spMin, color: AppColor.headingTextColor),
                ),
                30.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.r,
                      width: 20.r,
                      child: ValueListenableBuilder(
                        valueListenable: isBilling,
                        builder: (BuildContext context, bool billingValue,
                            Widget? child) {
                          return Checkbox(
                            //policy
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: AppColor.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5).r),
                            value: billingValue,
                            onChanged: (value) {
                              isBilling.value = value!;
                            },
                          );
                        },
                      ),
                    ),
                    15.horizontalSpace,
                    Flexible(
                      child: Text(
                        S
                            .of(context)
                            .billingAddressIsDifferentThanServiceAddress,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textMedium.copyWith(
                            fontSize: 14.spMin,
                            color: AppColor.starNonSelectedColor),
                      ),
                    ),
                  ],
                ),
                15.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10).r,
                        topLeft: Radius.circular(10).r,
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.imageLocationIcon,
                        height: 18.r,
                        width: 18.r,
                      ),
                      13.horizontalSpace,
                      Text(
                        S.of(context).home,
                        style: textRegular.copyWith(
                            fontSize: 14.spMin, color: AppColor.lightRed),
                      ),
                    ],
                  ).wrapPaddingOnly(top: 12, left: 15, right: 15),
                ),
                AppTextField(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.zero,
                      topLeft: Radius.zero,
                      bottomLeft: Radius.circular(10).r,
                      bottomRight: Radius.circular(10).r),
                  textStyle: textMedium.copyWith(
                      fontSize: 14.spMin, color: AppColor.darkBlackColor),
                  controller: addressController,
                  validators: addressValidator,
                  keyboardType: TextInputType.name,
                  height: 1.r,
                  label: '',
                  hint: S.of(context).enterAddress,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 49, vertical: 0),
                  filled: true,
                ),
                15.verticalSpace,
                Text(
                  S.of(context).vatNumber,
                  style: textRegular.copyWith(
                      fontSize: 12.spMin, color: AppColor.starNonSelectedColor),
                ),
                7.verticalSpace,
                AppTextField(
                  textStyle: textRegular.copyWith(
                      fontSize: 15.spMin, color: AppColor.headingTextColor),
                  controller: vatController,
                  keyboardAction: TextInputAction.done,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validators: vatValidator,
                  keyboardType: TextInputType.number,
                  height: 55.r,
                  label: '',
                  hint: S.of(context).enterVatNumber,
                  contentPadding: EdgeInsets.only(left: 18),
                  filled: true,
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).paymentMethod,
                      style: textSemiBold.copyWith(
                          fontSize: 16, color: AppColor.headingTextColor),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 20.h,
                        width: 59.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5).r,
                          color:
                              AppColor.tutoringGradiantColor.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).change,
                            style: textRegular.copyWith(
                                fontSize: 10.spMin,
                                color: AppColor.tutoringGradiantColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                6.verticalSpace,
                Text(
                  S.of(context).weWillNotChargeYouUntilTheServiceHasBeen,
                  maxLines: 2,
                  style: textMedium.copyWith(
                      fontSize: 14.spMin, color: AppColor.starNonSelectedColor),
                ).wrapPaddingRight(40),
                15.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5).r,
                              border: Border.all(
                                  color: Color.fromRGBO(152, 153, 155, 0.2)),
                              color: AppColor.white,
                            ),
                            height: 37.r,
                            width: 52.r,
                            child: Center(
                              child: Image.asset(
                                Assets.imageMastercard,
                                height: 20.r,
                                width: 33.r,
                              ),
                            ),
                          ),
                          13.horizontalSpace,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).janeSmith,
                                style: textBold.copyWith(
                                    fontSize: 12.spMin,
                                    color: AppColor.headingTextColor),
                              ),
                              2.verticalSpace,
                              Text(
                                "•••• •••• •••• 2562",
                                style: textRegular.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.starNonSelectedColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ).wrapPaddingOnly(top: 16, left: 16, bottom: 16),
                ),
                15.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.r,
                      width: 24.r,
                      child: ValueListenableBuilder(
                        valueListenable: isPolicy,
                        builder: (BuildContext context, bool checkValue,
                            Widget? child) {
                          return Checkbox(
                            //policy
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: AppColor.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5).r),
                            value: checkValue,
                            onChanged: (value) {
                              isPolicy.value = value!;
                            },
                          );
                        },
                      ),
                    ),
                    11.horizontalSpace,
                    Flexible(
                      // fit: FlexFit.loose,
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: S.of(context).byContinuingYouAgreeToThe,
                                style: textMedium.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.headingTextColor)),
                            TextSpan(
                                text: S.of(context).termsOfService,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint(S.of(context).termsOfService);
                                  },
                                style: textBold.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.lightRed)),
                            TextSpan(
                                text: S.of(context).and,
                                style: textMedium.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.headingTextColor)),
                            TextSpan(
                                text: S.of(context).privacyPolicy,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint(S.of(context).privacyPolicy);
                                  },
                                style: textBold.copyWith(
                                    fontSize: 14.spMin,
                                    color: AppColor.lightRed)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                18.verticalSpace,
                SizedBox(
                  height: 57.r,
                  width: double.infinity,
                  child: CustomElevatedButton(
                    child: Text(
                      S.of(context).signUpContinueToConfirmation,
                      style: textMedium,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isPolicy.value == false) {
                          showMessage(S.of(context).pleaseAcceptPrivacyPolicy);
                        } else {
                          callSignupApi();
                        }
                      }
                    },
                  ),
                ),
                16.verticalSpace,
              ],
            ).wrapPaddingHorizontal(20),
          ),
        );
      }
    });
  }

  Widget buildOtpForm() {
    return Form(
      key: _formKey,
      child: PinCodeTextField(
        errorTextSpace: 30,
        errorTextMargin: EdgeInsets.only(left: 90).r,
        validator: otpValidator,
        onChanged: (value) {
          currentValue.value = value;
        },
        autoDisposeControllers: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        hintCharacter: "⬤",
        hintStyle:
            TextStyle(fontSize: 15.spMin, color: AppColor.starNonSelectedColor),
        textInputAction: TextInputAction.next,
        cursorColor: AppColor.black.withOpacity(0.5),
        animationDuration: Duration(milliseconds: 300),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 0,
          selectedBorderWidth: 0,
          disabledBorderWidth: 0,
          activeColor: AppColor.white,
          inactiveColor: AppColor.white,
          selectedColor: AppColor.white,
          selectedFillColor: AppColor.white,
          activeFillColor: AppColor.white,
          inactiveFillColor: AppColor.white,
          borderRadius: BorderRadius.circular(10).r,
          fieldHeight: 55.r,
          fieldWidth: 55.r,
        ),
        enableActiveFill: true,
        textStyle: TextStyle(
            fontSize: 20.spMin, height: 1.6.h, color: AppColor.lightRed),
        keyboardType: TextInputType.number,
        controller: otpController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        length: 4,
        appContext: context,
        obscureText: false,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
      ),
    ).wrapPaddingHorizontal(28);
  }

  Future verificationBottomSheet() {
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.white,
                  AppColor.offWhiteColor,
                ],
              ),
            ),
            padding: EdgeInsets.only(left: 20, right: 20, top: 9, bottom: 20).r,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2).r,
                        color: AppColor.black),
                    height: 3.r,
                    width: 60.r,
                  ),
                  60.verticalSpace,
                  Image.asset(
                    Assets.imageMobileVerification,
                    height: 90.r,
                    width: 83.r,
                  ),
                  18.verticalSpace,
                  Text(
                    S.of(context).verificationCode.toTitleCase(),
                    style: textBold.copyWith(
                        color: AppColor.headingTextColor, fontSize: 18.spMin),
                  ),
                  12.verticalSpace,
                  Text(
                    S.of(context).enterThe4DigitVerificationCodeWeSentToYou,
                    style: textRegular.copyWith(
                        fontSize: 16.spMin,
                        color: AppColor.starNonSelectedColor),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: false,
                  ).wrapPaddingHorizontal(28),
                  30.verticalSpace,
                  buildOtpForm(),
                  25.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn’t received? ",
                          style: textMedium.copyWith(
                              fontSize: 16.spMin,
                              color: AppColor.starNonSelectedColor)),
                      InkWell(
                        onTap: () {
                          otpController.text = "";
                          callResendOtpApi();
                          showMessage(S.of(context).otpSentSuccesfully);
                        },
                        child: Text(S.of(context).resend,
                            style: textMedium.copyWith(
                                fontSize: 16.spMin, color: AppColor.lightRed)),
                      ),
                    ],
                  ),
                  35.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    height: 57.r,
                    child: CustomElevatedButton(
                        child: Text(
                          S.of(context).verify,
                          style: textMedium.copyWith(
                              fontSize: 16.spMin, color: AppColor.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (authenticStore.otpResponse?.data?.otp ==
                                otpController.text) {
                              Navigator.of(context).pop();
                              passwordSetBottomSheet();
                            } else {
                              showMessage("Please enter correct otp");
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(
      () {
        otpController.text = "";
      },
    );
  }

  Future passwordSetBottomSheet() {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return WillPopScope(
          //to not close bottom sheet
          onWillPop: () async {
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.white,
                  AppColor.handyWorkGradiantColor,
                ],
              ),
            ),
            padding: EdgeInsets.only(left: 20, right: 20, top: 9, bottom: 20).r,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 3.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2).r,
                    color: AppColor.black,
                  ),
                ),
                68.verticalSpace,
                Image.asset(
                  Assets.imageAllDone,
                  height: 104.r,
                  width: 102.r,
                  fit: BoxFit.fill,
                ),
                25.verticalSpace,
                Text(
                  S.of(context).youreAllSet.toTitleCase(),
                  style: textBold.copyWith(
                      fontSize: 18.spMin, color: AppColor.headingTextColor),
                ),
                12.verticalSpace,
                Text(
                  S.of(context).youHaveSuccessfullyCreatedYourAccount,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: false,
                  style: textRegular.copyWith(
                    fontSize: 16.spMin,
                    color: AppColor.headingTextColor,
                  ),
                ).wrapPaddingHorizontal(39),
                54.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 57.h,
                  child: CustomElevatedButton(
                    backgroundColor: AppColor.white,
                    child: Text(
                      S.of(context).backToLogin,
                      style:
                          textMedium.copyWith(color: AppColor.headingTextColor),
                    ),
                    onPressed: () {
                      context.router.replaceAll([LoginRoute()]);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    isBilling.dispose();
    isPolicy.dispose();
    currentValue.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    numberController.dispose();
    vatController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    otpController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
