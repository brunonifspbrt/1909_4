import 'dart:convert';

import 'package:ex1/endereco.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var conteudo = '';
  var msg = '';
  //TextEditingController tfCep = TextEditingController();
  TextEditingController contCep = TextEditingController();
  TextEditingController contRua = TextEditingController();
  TextEditingController contBairro = TextEditingController();
  TextEditingController contCidade = TextEditingController();
  TextEditingController contEstado = TextEditingController();

  void limpaCampos() {
    contRua.clear();
    contBairro.clear();
    contCidade.clear();
    contEstado.clear();
  }

  void buscaCEP() async {
    String cep = contCep.text;
    // define url com cep ja embutido
    String url = 'https://viacep.com.br/ws/$cep/json/';

    // verifica tamanho do campo
    if (cep.length < 8) {
      // limpa todos os campos
      limpaCampos();
      setState(() {
        msg = 'Informe um CEP Válido!';
      });
    } else {
      // objeto Json retornado da APi
      final resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode == 200) {
        // resposta 200 OK
        // o body contém JSON
        // obtem todo conteudo de json
        var jsonValor = jsonDecode(resposta.body);
        // através do método da classe Endereço ele envia todo o conteudo JSON para retornar só dois valores no JSON
        var endereco = Endereco.fromJson(jsonValor);
        setState(() {
          msg = 'CEP encontrado';
        });
        contRua.text = endereco.logradouro;
        contBairro.text = endereco.bairro;
        contCidade.text = endereco.cidade;
        contEstado.text = endereco.estado;
      } else {
        // diferente de 200 exibe mensagem de erro
        // throw Exception('Falha no carregamento.');
        setState(() {
          msg = 'CEP informado NÃO encontrado';
        });
        limpaCampos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: contCep,
                  maxLines: 5,
                ),
              ),
              // TextField(
              //   controller: tfCep,
              //   decoration: const InputDecoration(labelText: 'Digite o CEP'),
              // ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  buscaCEP();
                },
                child: const Text('Buscar'),
              ),
              Text('Resultado: $msg'),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contRua,
                  decoration: const InputDecoration(labelText: 'Rua:'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contBairro,
                  decoration: const InputDecoration(labelText: 'Bairro:'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contCidade,
                  decoration: const InputDecoration(labelText: 'Cidade:'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contEstado,
                  decoration: const InputDecoration(labelText: 'Estado:'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
