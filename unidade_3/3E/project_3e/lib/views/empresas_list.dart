import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_3e/services/bloc.service.dart';
import 'package:project_3e/services/empresa.service.dart';

class EmpresasList extends StatelessWidget {
  final _bloc = Bloc();
  final empresas = EmpresaService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.saida,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Lista de Empresas"),
              ),
              body: Center(child: Text("${empresas.getAllEmpresas()}")));
        });
  }
}
