import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/api/api.dart';
import 'package:mobile_app/data/data.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String qrCodeResult = "Efetuar leitura do QRcode";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$instituicao"),
        centerTitle: true,
      ),
      body: Center(child: Text(qrCodeResult)),
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
        },
      ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Pesquisa receita",
                            style: textStyleTitulo(),
                          ),
                          Text(
                            data.toString(),
                          ),
                          FlatButton(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            "Pesquisa de receita",
                            style: textStyleTitulo(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SelectableText(data.toString()),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            "Pesquisa de receita",
                            style: textStyleTitulo(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SelectableText(
                              "Erro no código de validação. O mesmo deve seguir o padrão 36-char." +
                                  "\n Ex.: 1b2c74a3-4c4d-45dc-8514-b32dfa38fd64"),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
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

  textStyleTitulo() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);
  }
}
