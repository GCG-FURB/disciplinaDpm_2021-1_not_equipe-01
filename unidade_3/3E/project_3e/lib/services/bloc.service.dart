import 'package:project_3e/services/empresa.service.dart';
import 'package:rxdart/rxdart.dart';

class Bloc {
  final _service = EmpresaService();

  final _controlador = BehaviorSubject();
  Stream get saida => _controlador.stream;
  Sink get entrada => _controlador.sink;

  getAllEmpresas() async {
    await _service.getAllEmpresas();
  }

  void dispose() {
    _controlador.close();
  }
}
