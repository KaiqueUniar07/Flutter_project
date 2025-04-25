import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(home: CadastroJogo()));

class CadastroJogo extends StatefulWidget {
  const CadastroJogo({super.key});

  @override
  State<CadastroJogo> createState() => _CadastroJogoState();
}

class _CadastroJogoState extends State<CadastroJogo> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _categoria = TextEditingController();
  final _data = TextEditingController();
  final _plataforma = TextEditingController();
  String mensagem = '';
  bool enviando = false;

  Future<void> enviar() async {
    if (!_formulario.currentState!.validate()) return;

    setState(() {
      enviando = true;
      mensagem = '';
    });

    final url = Uri.parse('https://68078226e81df7060eba95a7.mockapi.io/api/jogos/jogos');
    final resposta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': _nome.text,
        'categoria': _categoria.text,
        'dataLancamento': _data.text,
        'plataforma': _plataforma.text,
      }),
    );

    setState(() {
      enviando = false;
      if (resposta.statusCode == 201) {
        _nome.clear();
        _categoria.clear();
        _data.clear();
        _plataforma.clear();
        mensagem = 'Cadastro realizado com sucesso!';
      } else {
        mensagem = 'Erro ao cadastrar os dados.';
      }
    });
  }

  Widget campo(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(labelText: label),
          validator: (valor) => valor!.isEmpty ? 'Preencha este campo!' : null,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar novo Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formulario,
          child: Column(
            children: [
              campo('Nome', _nome),
              campo('Categoria', _categoria),
              campo('Data de Lançamento', _data),
              campo('Plataforma', _plataforma),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: enviando ? null : enviar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cadastrar'), 
              ),
              const SizedBox(height: 16),
              if (mensagem.isNotEmpty)
                Text(
                  mensagem,
                  style: TextStyle(
                    color: mensagem.contains('sucesso')
                        ? const Color.fromARGB(255, 15, 15, 15)
                        : const Color.fromARGB(255, 8, 8, 8),
                    fontWeight: FontWeight.bold,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
