import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_final/src/shared/base_model.dart';

class Lembretes extends BaseModel {
  String _id;
  String descricao;
  String titulo;
  String foto;
  String localizacao;

  Lembretes();

  Lembretes.fromMap(DocumentSnapshot doc) {
    _id = doc.id;
    this.descricao = doc['descricao'] as String;
    this.titulo = doc['titulo'] as String;
    this.foto = doc['foto'] as String;
    this.localizacao = doc['localizacao'] as String;
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['descricao'] = this.descricao;
    map['titulo'] = this.titulo;
    map['foto'] = this.foto;
    map['localizacao'] = this.localizacao;

    return map;
  }

  @override
  String id() => _id;
}
