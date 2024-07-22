import '../../generated/l10n.dart';

class ServiceData {
  bool isCheck;
  String name;
  String time;

  ServiceData(this.isCheck, this.name, this.time);
}

List serviceList = [
  ServiceData(false, S.current.deepKitchenCleaning, S.current.Hour),
  ServiceData(false, S.current.additionalBathroom, "+ 0.5 hour"),
  ServiceData(false, S.current.ovenCleaning, "+ 1 hour"),
  ServiceData(false, S.current.carWash, "+ 2 Hour"),
];
