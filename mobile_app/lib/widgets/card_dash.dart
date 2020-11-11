import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardDash extends StatefulWidget {
  final String idReceita;
  final String data;
  final String nomePaciente;
  final String nomeMedicamento;
  final String qrCode;

  CardDash(
      [this.idReceita,
      this.data,
      this.nomePaciente,
      this.nomeMedicamento,
      this.qrCode]);

  @override
  _CardDashState createState() => _CardDashState();
}

class _CardDashState extends State<CardDash> {
  ajustData(String data) {
    String dataString = "";
    List listData = data.split("-").toList();
    listData.reversed.toList().forEach((element) {
      dataString = listData.reversed.toList().join("/");
    });
    return dataString;
  }

  getLastData() {
    String data = widget.data;
    String dia = ajustData(data.substring(0, data.indexOf("T")));
    String hora = data.substring((data.indexOf("T") + 1), data.indexOf("."));
    return SelectableText(
      "$dia às $hora",
      style: textStyleConteudo(),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        color: ThemeData().primaryColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText("ID Receita: ", style: textStyleTitulo()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SelectableText(
                    "${widget.idReceita}",
                    style: textStyleConteudo(),
                  ),
                ),
                SelectableText("Data: ", style: textStyleTitulo()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: getLastData(),
                ),
                SelectableText("Nome Paciente: ", style: textStyleTitulo()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "${widget.nomePaciente}",
                    style: textStyleConteudo(),
                  ),
                ),
                SelectableText("Nome Paciente: ", style: textStyleTitulo()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SelectableText(
                    "${widget.nomeMedicamento}",
                    style: textStyleConteudo(),
                  ),
                ),
              ],
            ),
            QrImage(
              data: widget.qrCode,
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.height * 0.15,
            ),
          ],
        ),
      ),
    );
  }

  textStyleTitulo() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);
  }

  textStyleConteudo() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
        fontSize: 12);
  }
}
