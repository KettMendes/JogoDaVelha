import 'package:flutter/material.dart';
import 'dart:async';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  final List<String> _tabuleiro = List.filled(9, '');
  String _jogador = 'X';
  String _mensagem = '';
  bool contraComputador = false;

  // Função para trocar entre os jogadores
  void _trocaJogador() {
    setState(() {
      _jogador = _jogador == 'X' ? 'O' : 'X';
    });
  }

  // Função de jogada
  void _jogada(int index) {
    if (_tabuleiro[index] == '' && _mensagem == '') {
      setState(() {
        _tabuleiro[index] = _jogador;
        if (!_verificaVencedor(_jogador)) {
          _trocaJogador();
          if (contraComputador && _jogador == 'O') {
            _jogadaComputador();
          }
        }
      });
    }
  }

  // Função para verificar vencedor
  bool _verificaVencedor(String jogador) {
    List<List<int>> vitorias = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var vitoria in vitorias) {
      if (_tabuleiro[vitoria[0]] == jogador &&
          _tabuleiro[vitoria[1]] == jogador &&
          _tabuleiro[vitoria[2]] == jogador) {
        setState(() {
          _mensagem = '$jogador Venceu! 🏆';
        });
        _marcarLinha(vitoria);
        return true;
      }
    }

    // Verifica se deu empate
    if (!_tabuleiro.contains('') && _mensagem == '') {
      setState(() {
        _mensagem = 'Ninguém Ganhou!';
      });
    }

    return false;
  }

  // Função para desenhar a linha nos quadrados vencedores
  void _marcarLinha(List<int> vitoria) {
    for (var i in vitoria) {
      _tabuleiro[i] = _tabuleiro[i]; // Apenas marca a vitória visualmente
    }
  }

  // Função para a jogada do computador
  void _jogadaComputador() {
    Future.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < _tabuleiro.length; i++) {
        if (_tabuleiro[i] == '') {
          _jogada(i);
          break;
        }
      }
    });
  }

  // Função para alternar entre humano e computador
  void _toggleJogador() {
    setState(() {
      contraComputador = !contraComputador;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: contraComputador,
                onChanged: (value) {
                  _toggleJogador();
                },
              ),
              Text(
                contraComputador ? 'Computador' : 'Humano',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: contraComputador ? Colors.blue : Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mensagem de vitória ou empate
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              _mensagem,
              style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),

          // Grade do Jogo
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 3.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _jogada(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tabuleiro[index] == ''
                          ? const Color.fromARGB(74, 238, 34, 194)
                          : _tabuleiro[index] == 'X'
                              ? Colors.blue
                              : const Color.fromARGB(255, 222, 54, 244),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        _tabuleiro[index],
                        style: const TextStyle(
                          fontSize: 40.0, // Reduz o tamanho do texto
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Botão de reinício
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tabuleiro.fillRange(0, _tabuleiro.length, '');
                    _mensagem = '';
                  });
                },
                child: const Text('Reiniciar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
