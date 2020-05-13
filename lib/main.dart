import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=087d95ec";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.blue,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          hintStyle: TextStyle(color: Colors.blue),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {

  void realChanged (String text){
    print(text);
  }
  void dolarChanged (String text){
    print(text);

  }
  void euroChanged (String text){
    print(text);

  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final reaisController = TextEditingController();
  final dolarController = TextEditingController();
  final eurosController = TextEditingController();

  double euro;
  double dolar;

  void _clearAll(){
    reaisController.text = "";
    dolarController.text = "";
    eurosController.text = "";
  }

  void _realChanged (String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text  = (real /dolar).toStringAsFixed(2);
    eurosController.text  = (real /euro).toStringAsFixed(2);
  }
  void _dolarChanged (String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    reaisController.text  = (dolar * this.dolar).toStringAsFixed(2);
    eurosController.text  = (dolar * this.dolar / euro).toStringAsFixed(2);


  }
  void _euroChanged (String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    reaisController.text  = (euro * this.euro).toStringAsFixed(2);
    dolarController.text  = (euro * this.euro / dolar).toStringAsFixed(2);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("conversor \$"),
          backgroundColor: Colors.blue,
          centerTitle: true,

        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            // ignore: missing_return
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.blue, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.blue,
                        ),
                        buildTextField("Reais", "R\$", reaisController,_realChanged ),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", eurosController, _euroChanged ),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController moedas, Function transation){
  return TextField(
    controller: moedas,
    decoration: InputDecoration(
      labelText: label,
      labelStyle:
      TextStyle(color: Colors.blue),
      prefixText: prefix,
      border: OutlineInputBorder(),
    ),
    style: TextStyle(
        color: Colors.blue,
        fontSize: 25.0
    ),
    onChanged: transation,
    keyboardType: TextInputType.number,
  );
}





