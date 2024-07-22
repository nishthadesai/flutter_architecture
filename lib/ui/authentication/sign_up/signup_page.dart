import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/extensions/widget_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../widget/custom_button.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.white,
              AppColor.offWhiteColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                S.of(context).needToRegister.toTitleCase(),
                style: textBold.copyWith(
                    fontSize: 18.spMin, color: AppColor.headingTextColor),
              ),
            ),
            46.verticalSpace,
            Text(
              S.of(context).toCompleteYourBookingPleaseRegisterOrAFreeAccount,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: textRegular.copyWith(color: AppColor.starNonSelectedColor),
            ),
            46.verticalSpace,
            SizedBox(
              height: 57.r,
              width: double.infinity,
              child: CustomElevatedButton(
                  child: Text(
                    S.of(context).createAccount,
                    style: textMedium.copyWith(
                        fontSize: 16.spMin, color: AppColor.white),
                  ),
                  onPressed: () {
                    context.router.push(SignUpFormRoute());
                  }),
            ),
            46.verticalSpace,
            Text(
              S.of(context).alreadyHaveAnAccount,
              style: textBold.copyWith(
                  fontSize: 14.spMin, color: AppColor.starNonSelectedColor),
            ),
            10.verticalSpace,
            InkWell(
              onTap: () {
                context.router.push(LoginRoute());
              },
              child: Text(
                S.of(context).login.toUpperCase(),
                style: textBold.copyWith(
                    fontSize: 14.spMin, color: AppColor.green),
              ),
            ),
          ],
        ).wrapPaddingHorizontal(20),
      ),
    );
  }
}
