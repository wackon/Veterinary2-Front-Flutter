import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:veterinary1/components/loader_component.dart';
import 'package:veterinary1/helpers/api_helper.dart';
import 'package:veterinary1/models/procedimiento.dart';
import 'package:veterinary1/models/response.dart';
import 'package:veterinary1/models/token.dart';

class ProcedimientoScreen extends StatefulWidget {
  final Token token;
  final Procedimiento procedimiento;

  ProcedimientoScreen({required this.token, required this.procedimiento});

  @override
  _ProcedimientoScreenState createState() => _ProcedimientoScreenState();
}

class _ProcedimientoScreenState extends State<ProcedimientoScreen> {
  bool _showLoader = false;

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();

  /* String _price = '';
  String _priceError = '';
  bool _priceShowError = false;
  TextEditingController _priceController = TextEditingController();
 */
  @override
  void initState() {
    super.initState();
    _description = widget.procedimiento.nombreProcedimiento;
    _descriptionController.text = _description;
    /*  _price = widget.procedure.price.toString();
    _priceController.text = _price; */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedimiento.id == 0
            ? 'Nuevo procedimiento'
            : widget.procedimiento.nombreProcedimiento),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescription(),
              /*  _showPrice(), */
              _showButtons(),
            ],
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa un procedimiento...',
          labelText: 'Procedimiento',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }

  /*  Widget _showPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController,
        decoration: InputDecoration(
          hintText: 'Ingresa un precio...',
          labelText: 'Precio',
          errorText: _priceShowError ? _priceError : null,
          suffixIcon: Icon(Icons.attach_money),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _price = value;
        },
      ),
    );
  } */

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Color(0xFF120E43);
                }),
              ),
              onPressed: () => _save(),
            ),
          ),
          widget.procedimiento.id == 0
              ? Container()
              : SizedBox(
                  width: 20,
                ),
          widget.procedimiento.id == 0
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    child: Text('Borrar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Color(0xFFB4161B);
                      }),
                    ),
                    onPressed: () => _confirmDelete(),
                  ),
                ),
        ],
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    widget.procedimiento.id == 0 ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_description.isEmpty) {
      isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripción.';
    } else {
      _descriptionShowError = false;
    }
/* 
    if (_price.isEmpty) {
      isValid = false;
      _priceShowError = true;
      _priceError = 'Debes ingresar un precio.';
    } else {
      double price = double.parse(_price);
      if (price <= 0) {
        isValid = false;
        _priceShowError = true;
        _priceError = 'Debes ingresar un precio mayor a cero.';
      } else {
        _priceShowError = false;
      }
    } */

    setState(() {});
    return isValid;
  }

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'description': _description,
      /* 'price': double.parse(_price), */
    };

    Response response =
        await ApiHelper.post('/api/procedimiento', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  void _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'id': widget.procedimiento.id,
      'description': _description,
      /* 'price': double.parse(_price), */
    };

    Response response = await ApiHelper.put('/api/procedimiento/',
        widget.procedimiento.id.toString(), request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estas seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);

    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.delete('/api/procedimiento/',
        widget.procedimiento.id.toString(), widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pop(context, 'yes');
  }
}
