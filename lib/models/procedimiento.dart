class Procedimiento {
  String? nombreProcedimiento;

  Procedimiento({this.nombreProcedimiento});

  Procedimiento.fromJson(Map<String, dynamic> json) {
    nombreProcedimiento = json['nombreProcedimiento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombreProcedimiento'] = this.nombreProcedimiento;
    return data;
  }
}
