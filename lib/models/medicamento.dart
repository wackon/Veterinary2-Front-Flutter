class Medicamento {
  String? nombreMedicamento;

  Medicamento({this.nombreMedicamento});

  Medicamento.fromJson(Map<String, dynamic> json) {
    nombreMedicamento = json['nombreMedicamento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombreMedicamento'] = this.nombreMedicamento;
    return data;
  }
}
