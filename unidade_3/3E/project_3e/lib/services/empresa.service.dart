import 'package:dio/dio.dart';

class EmpresaService {
  final dio = Dio();
  final endpoint = "http://localhost:5001/Empresa/";

  Future getAllEmpresas() async {
    print("passei aqui");
    Response response =
        await dio.get("http://localhost:5001/Empresa/GetAllEmpresas");

    print("antes do response");
    print(response.data);
    return response.data;
  }
}
