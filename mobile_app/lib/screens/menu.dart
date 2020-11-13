import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/api/api.dart';
import 'package:mobile_app/data/data.dart';
import 'package:mobile_app/widgets/card_dash.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String qrCodeResult = "";
  Widget detalhesReceita = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///////////// appBar ////////
      appBar: AppBar(
        title: Text("$instituicao"),
        centerTitle: true,
      ),
      ///////////// body ///////////
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              child: Center(
                  child: Text("Lista de Receitas cadastradas",
                      style: textStyleTitulo()))),
          Flexible(flex: 8, child: updateList()),
        ],
      ),
      ///////////// floating ///////
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.qr_code),
          label: Text("QRcode"),
          tooltip: "Capturar QRcode",
          onPressed: () async {
            String scaning = await BarcodeScanner.scan();
            setState(() {
              qrCodeResult = scaning;
              checkReceita();
            });
          }),
    );
  }

  checkReceita() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.white,
          title: SelectableText("Verificação de receita"),
          content: FutureBuilder(
              future: ApiCollection.checkReceita(
                host,
                port,
                qrCodeResult,
              ).checkQRCode(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  if (data.toString().startsWith("Receita")) {
                    return Container(
                      height: 350,
                      width: 650,
                      color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Receita válida!",
                            style: textStyleTitulo(),
                          ),
                          Text(data.toString(), textAlign: TextAlign.center),
                          FlatButton(
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    );
                  } else if (data.toString().startsWith("Erro:")) {
                    return Container(
                      height: 350,
                      width: 650,
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            "Receita indisponível para venda!",
                            style: textStyleTitulo(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SelectableText(
                            data.toString(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: 350,
                      width: 650,
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            "Erro na verificação!",
                            style: textStyleTitulo(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SelectableText(
                              "Erro: Código inválido. O QRcode não segue o padrão aceito",
                              textAlign: TextAlign.center),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    );
                  }
                } else {
                  return Container(
                      height: 120,
                      width: 650,
                      child: Center(
                          child: Column(
                        children: [
                          CircularProgressIndicator(
                            semanticsLabel: "Pesquisando receita. Aguarde.",
                          ),
                          SelectableText("Pesquisando receita. Aguarde."),
                        ],
                      )));
                }
              }),
        );
      },
    );
  }

  Widget updateList() {
    return new FutureBuilder(
        future: ApiCollection.listaReceitas(host, port).getMyReceitas(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var content = snapshot.data;
            var _counter = content.length;
            var index;
            return Scrollbar(
              child: ListView.builder(
                  physics: index,
                  itemCount: _counter,
                  itemBuilder: (BuildContext context, int index) {
                    String dataAjustada = getLastData(
                        content[(_counter - 1) - index]["state"]["data"]
                                ["dataEmissao"]
                            .toString());
                    List compradoresVendedores =
                        (content[(_counter - 1) - index]["state"]["data"]
                                        ["iouVenda"]
                                    .toString() ==
                                "null")
                            ? ["Medicamento não comprado"]
                            : content[(_counter - 1) - index]["state"]["data"]
                                ["iouVenda"]["venda"];

                    return Column(
                      children: [
                        GestureDetector(
                          //Infomações dos cards da lista de receitas
                          child: CardDash(
                            //ID Receita
                            content[(_counter - 1) - index]["state"]["data"]
                                    ["iouReceita"]["receita"]["numeroReceita"]
                                .toString(),
                            //Data Emissão
                            content[(_counter - 1) - index]["state"]["data"]
                                    ["dataEmissao"]
                                .toString(),
                            //Nome Paciente
                            content[(_counter - 1) - index]["state"]["data"]
                                    ["iouReceita"]["receita"]["nomePaciente"]
                                .toString(),
                            //Nome Medicamento
                            content[(_counter - 1) - index]["state"]["data"]
                                    ["iouReceita"]["receita"]["nomeMedicamento"]
                                .toString(),
                            //QrCode Receita
                            content[(_counter - 1) - index]["state"]["data"]
                                    ["linearId"]["id"]
                                .toString(),
                          ),
                          //Informações da receita completa
                          onTap: () => showDetails(
                              //ID Receita
                              content[(_counter - 1) - index]["state"]["data"]
                                      ["iouReceita"]["receita"]["numeroReceita"]
                                  .toString(),
                              //Data Emissão
                              dataAjustada,
                              //Nome Paciente
                              content[(_counter - 1) - index]["state"]["data"]
                                      ["iouReceita"]["receita"]["nomePaciente"]
                                  .toString(),
                              //Endereço do Paciente
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]
                                      ["receita"]["enderecoPaciente"]
                                  .toString(),
                              //Nome Médico
                              content[(_counter - 1) - index]["state"]["data"]
                                      ["iouReceita"]["receita"]["nomeMedico"]
                                  .toString(),
                              //CRM Médico
                              content[(_counter - 1) - index]["state"]["data"]
                                      ["iouReceita"]["receita"]["crmMedico"]
                                  .toString(),
                              //QrCode Receita
                              content[(_counter - 1) - index]["state"]["data"]["linearId"]["id"].toString(),
                              //Nome Medicamento
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]["receita"]["nomeMedicamento"].toString(),
                              //Quantidade receitada do medicamento
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]["receita"]["quantidadeMedicamento"].toString(),
                              //Formula do medicamento
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]["receita"]["formulaMedicamento"].toString(),
                              //Dose por unidade
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]["receita"]["doseUnidade"].toString(),
                              //Posologia
                              content[(_counter - 1) - index]["state"]["data"]["iouReceita"]["receita"]["posologia"].toString(),
                              compradoresVendedores),
                        ),
                        Divider(),
                      ],
                    );
                  }),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    semanticsLabel: "Buscando Informações no ledger",
                  ),
                  SelectableText("Buscando Informações no ledger")
                ],
              ),
            );
          }
        });
  }

  showDetails(
      String idReceita,
      String data,
      String nomePaciente,
      String endPaciente,
      String nomeMedico,
      String crmMedico,
      String qrCode,
      String nomeMedicamento,
      String qteMedicamento,
      String formulaMedicamento,
      String doseUnidade,
      String posologia,
      List compradorVendedor) {
    seperarComprador() {
      List data = compradorVendedor;
      String todosCompradores = "";
      if (data[0].toString() == "Medicamento não comprado") {
        return "Medicamento não comprado";
      } else {
        for (int i = 0; i < data.length; i++) {
          todosCompradores = todosCompradores +
              "Quantidade Vendida: " +
              data[i]["quantidadeMedVendida"].toString() +
              "\n" +
              "Nome: " +
              data[i]["comprador"].toString() +
              "\n" +
              "Endereço: " +
              data[i]["enderecoComprador"].toString() +
              "\n" +
              "RG: " +
              data[i]["rg"].toString() +
              "\n" +
              "Telefone: " +
              data[i]["telefone"].toString() +
              "\n" +
              "\n";
        }
        return todosCompradores;
      }
    }

    seperarVendedor() {
      List data = compradorVendedor;
      String todosCompradores = "";
      if (data[0].toString() == "Medicamento não comprado") {
        return "Medicamento não comprado";
      } else {
        for (int i = 0; i < data.length; i++) {
          todosCompradores = todosCompradores +
              "\n" +
              "Quantidade Vendida: " +
              data[i]["quantidadeMedVendida"].toString() +
              "\n" +
              "Nome: " +
              data[i]["nomeVendedor"].toString() +
              "\n" +
              "cnpj: " +
              data[i]["cnpj"].toString() +
              "\n" +
              "data: " +
              getLastData(data[i]["data"].toString()) +
              "\n";
        }
        return todosCompradores;
      }
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Detalhes da Receita",
                ),
                centerTitle: true,
                backgroundColor: ThemeData().primaryColor,
              ),
              body: SingleChildScrollView(
                child: Card(
                  elevation: 10,
                  child: InteractiveViewer(
                    child: Container(
                      color: ThemeData().primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ID Receita: ",
                                        style: textStyleTitulo()),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        "$idReceita",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    SelectableText(
                                      "Data: ",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        "$data",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    SelectableText(
                                      "Nome Paciente: ",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "$nomePaciente",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    SelectableText(
                                      "Endereço do Paciente: ",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        "$endPaciente",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    SelectableText(
                                      "Nome Médico",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        "$nomeMedico",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    SelectableText(
                                      "CRM Médico:",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        "$crmMedico",
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    Divider(),
                                    SelectableText(
                                      "Dados do comprador:",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        seperarComprador(),
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                    Divider(),
                                    SelectableText(
                                      "Dados do Vendedor",
                                      style: textStyleTitulo(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        seperarVendedor(),
                                        style: textStyleConteudo(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  QrImage(
                                    data: qrCode,
                                    version: QrVersions.auto,
                                    size: MediaQuery.of(context).size.height *
                                        0.15,
                                  ),
                                  SelectableText(qrCode),
                                  SelectableText("Nome medicamento: ",
                                      style: textStyleTitulo()),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      "$nomeMedicamento",
                                      style: textStyleConteudo(),
                                    ),
                                  ),
                                  SelectableText("Quantidade do medicamento: ",
                                      style: textStyleTitulo()),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      "$qteMedicamento",
                                      style: textStyleConteudo(),
                                    ),
                                  ),
                                  SelectableText("Formula do Medicamento: ",
                                      style: textStyleTitulo()),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      "$formulaMedicamento",
                                      style: textStyleConteudo(),
                                    ),
                                  ),
                                  SelectableText("Dose por unidade: ",
                                      style: textStyleTitulo()),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      "$doseUnidade",
                                      style: textStyleConteudo(),
                                    ),
                                  ),
                                  SelectableText("Posologia: ",
                                      style: textStyleTitulo()),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      "$posologia",
                                      style: textStyleConteudo(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });

    setState(() {});
  }

  ajustData(String data) {
    String dataString = "";
    List listData = data.split("-").toList();
    listData.reversed.toList().forEach((element) {
      dataString = listData.reversed.toList().join("/");
    });
    return dataString;
  }

  getLastData(String dataJson) {
    String data = dataJson;
    String dia = ajustData(data.substring(0, data.indexOf("T")));
    String hora = data.substring((data.indexOf("T") + 1), data.indexOf("."));
    return "$dia às $hora";
  }

  textStyleTitulo() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
  }

  textStyleConteudo() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
        fontSize: 14);
  }

  textStyleTituloShow() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
  }
}
