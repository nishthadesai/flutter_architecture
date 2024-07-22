import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(S.of(context).booking)),
    );
  }
}
