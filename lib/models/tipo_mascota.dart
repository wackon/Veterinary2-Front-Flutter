class TipoMascota {
  String? descripcion;

  TipoMascota({this.descripcion});

  TipoMascota.fromJson(Map<String, dynamic> json) {
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['descripcion'] = this.descripcion;
    return data;
  }
}
