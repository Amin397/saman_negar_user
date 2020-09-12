import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samannegarusers/request/models/taxi_type.dart';

import 'get_experts.dart';

class Expert extends Equatable {
  final String ActiveExpert_id;
  final String lat;
  final String lang;
  final String expert_id;
  final GetExpert expert;


  Expert(this.ActiveExpert_id, this.lat, this.lang, this.expert_id, this.expert
      );

  Expert.named({
    this.ActiveExpert_id,
    this.lat,
    this.lang,
    this.expert_id,
    this.expert,

  });

  @override
  List<Object> get props => [lat, lang, expert_id, expert];
}
