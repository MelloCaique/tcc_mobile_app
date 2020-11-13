import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCollection {
  String host;
  String port;
  String linearId;
  int numeroReceita;
  String nomePaciente;
  String enderecoPaciente;
  String nomeMedico;
  int crmMedico;
  String nomeMedicamento;
  int quantidadeMedicamento;
  String formulaMedicamento;
  int doseUnidade;
  String posologia;
  int quantidadeMedVendida;
  String comprador;
  String enderecoComprador;
  int rg;
  int telefone;
  String nomeVendedor;
  int cnpj;

  ApiCollection.listaReceitas(this.host, this.port);

  ApiCollection.cadastro(
    this.host,
    this.port,
    this.numeroReceita,
    this.nomePaciente,
    this.enderecoPaciente,
    this.nomeMedico,
    this.crmMedico,
    this.nomeMedicamento,
    this.quantidadeMedicamento,
    this.formulaMedicamento,
    this.doseUnidade,
    this.posologia,
  );

  ApiCollection.checkReceita(this.host, this.port, this.linearId);

  ApiCollection.vendaReceita(
      this.host,
      this.port,
      this.linearId,
      this.quantidadeMedVendida,
      this.comprador,
      this.enderecoComprador,
      this.rg,
      this.telefone,
      this.nomeVendedor,
      this.cnpj);

  ///////////////// Checar a receita através do QRcode ///////////////////
  Future<dynamic> checkQRCode() async {
    final String url = "http://$host:$port/api/example/check-receita";

    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "cache-control": "no-cache"
        },
        body: jsonEncode({
          "linearId": {"externalId": null, "id": linearId}
        }));
    return (response.body);
  }

  ///////////////// Cadastriar receita médica no sistema ///////////////////
  Future<dynamic> cadastroReceita() async {
    final String url = "http://$host:$port/api/example/create-receita";

    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "cache-control": "no-cache"
        },
        body: jsonEncode({
          "numeroReceita": numeroReceita,
          "nomePaciente": nomePaciente,
          "enderecoPaciente": enderecoPaciente,
          "nomeMedico": nomeMedico,
          "crmMedico": crmMedico,
          "nomeMedicamento": nomeMedicamento,
          "quantidadeMedicamento": quantidadeMedicamento,
          "formulaMedicamento": formulaMedicamento,
          "doseUnidade": doseUnidade,
          "posologia": posologia
        }));
    return (response.body);
  }

  ///////////////// Realizar a venda da receita médica ///////////////////
  Future<dynamic> vendaReceita() async {
    final String url = "http://$host:$port/api/example/venda-receita";

    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "cache-control": "no-cache"
        },
        body: jsonEncode({
          "linearId": {"externalId": null, "id": linearId},
          "quantidadeMedVendida": quantidadeMedVendida,
          "comprador": comprador,
          "enderecoComprador": enderecoComprador,
          "rg": rg,
          "telefone": telefone,
          "nomeVendedor": nomeVendedor,
          "cnpj": cnpj
        }));
    return (response.body);
  }

  //////////////////////// Lista de todas as receitas //////////////////////////

  Future<dynamic> getAllReceitas() async {
    final String apiUrl = "http://$host:$port/api/example/receitas";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  //////////////////////// Lista de todas as receitas //////////////////////////

  Future<dynamic> getMyReceitas() async {
    final String apiUrl = "http://$host:$port/api/example/my-receitas";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }
}
