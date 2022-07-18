import 'package:end_sem_project/models/casesModel.dart';

class casesModel{
  var cases;
  var recovered;
  var deaths;
  var active;

  casesModel(
      {
        this.cases,
        this.recovered,
        this.deaths,
        this.active
      }
      );

  factory casesModel.fromJson(final json)
  {
    return casesModel(
      cases: json["cases"],
      recovered: json["recovered"],
      active: json['active'],
      deaths: json["deaths"],
    );
}
}