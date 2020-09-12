import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String description;

  PaymentMethod(
      {@required this.id,
      @required this.title,
      @required this.icon,
      @required this.description});


  PaymentMethod.named(
      {
        this.id,
        this.title,
        this.icon,
        this.description});

  @override
  List<Object> get props => [id, title, icon, description];
}
