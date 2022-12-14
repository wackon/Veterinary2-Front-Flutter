import 'package:flutter/material.dart';
import 'package:veterinary1/components/loader_component.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderComponent(
        text: 'Por favor espere...',
      ),
    );
  }
}
