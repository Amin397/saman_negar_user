import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samannegarusers/request/models/taxi_type.dart';

class GetExpert extends Equatable {
  final String expert_id;
  final String aid;
  final String fname;
  final String lname;
  final String presenter_id;
  final String main_expert;
  final String banTime;
  final String push_id;
  final String mobile;
  final bool can_enter_portal;
  final bool active;
  final bool has_cartable;
  final bool isBanned;



  GetExpert(this.expert_id, this.aid, this.fname, this.lname, this.presenter_id,
      this.main_expert, this.banTime, this.push_id, this.mobile, this.can_enter_portal,this.active,
      this.has_cartable, this.isBanned);

  GetExpert.named({
    this.expert_id,
    this.aid,
    this.fname,
    this.lname,
    this.presenter_id,
    this.main_expert,
    this.banTime,
    this.push_id,
    this.mobile,
    this.can_enter_portal,
    this.active,
    this.has_cartable,
    this.isBanned,

  });

  @override
  List<Object> get props => [fname, lname, expert_id, mobile];
}
