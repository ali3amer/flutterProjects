class ChangeFavoritesModel {
  bool? status;
  String? massage;

  ChangeFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    massage = json["massage"];
  }
}
