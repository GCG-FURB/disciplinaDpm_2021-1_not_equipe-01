class Fornecedor {
  final int id;
  final String nome;
  final String cpfcnpj;
  final String rg;
  final DateTime dataNascimento;
  final DateTime dataCadastro;
  final int empresaId;
  final int tipoFornecedor;

  const Fornecedor(
      {this.id,
      this.nome,
      this.cpfcnpj,
      this.rg,
      this.dataNascimento,
      this.dataCadastro,
      this.empresaId,
      this.tipoFornecedor});
}
