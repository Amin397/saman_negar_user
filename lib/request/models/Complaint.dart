class Complaint {
  final String complaints_name;
  final String typesofcomplaint_id;
  final String followcomplaint_id;

  Complaint({this.complaints_name, this.typesofcomplaint_id, this.followcomplaint_id});

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
        complaints_name: json['complaints_name'],
        typesofcomplaint_id: json['typesofcomplaint_id'],
        followcomplaint_id: json['followcomplaint_id'],
        );
  }
}
