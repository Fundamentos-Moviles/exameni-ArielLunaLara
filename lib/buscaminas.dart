import 'package:flutter/material.dart';
import 'dart:math';
import 'constantes.dart' as cons;

class Buscaminas extends StatefulWidget {
  const Buscaminas({super.key});
  @override
  State<Buscaminas> createState() => _BuscaminasState();
}

class _BuscaminasState extends State<Buscaminas> {
  final int filas = 6;
  final int columnas = 6;
  final int totalCeldas = 36;

  late List<bool> celdasTocadas;
  late int indiceBomba;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    celdasTocadas = List.generate(totalCeldas, (_) => false);
    indiceBomba = Random().nextInt(totalCeldas);
  }

  void _manejarTap(int fila, int columna) {
    if (gameOver) return;
    final index = fila * columnas + columna;
    if (celdasTocadas[index]) return;
    setState(() {
      celdasTocadas[index] = true;
      if (index == indiceBomba) {
        gameOver = true;
        _mostrarFinJuego();
      } else {
        int tocadasSeguras = 0;
        for (int i = 0; i < totalCeldas; i++){
          if (celdasTocadas[i] && i != indiceBomba){
            tocadasSeguras++;
          }
        }
        if (tocadasSeguras == totalCeldas - 1){
          gameOver = true;
          _mostrarVictoria();
        }
      }
    });
  }

  void _mostrarVictoria(){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Felcidades!, Ganaste'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarFinJuego() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fin del juego'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuscaMinas Luna Lara Luis Ariel'),
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeGame();
                gameOver = false;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: List.generate(filas, (fila) {
          return Expanded(
            child: Row(
              children: List.generate(columnas, (columna) {
                final index = fila * columnas + columna;
                Color colorCelda = cons.inactivo;
                if (celdasTocadas[index]) {
                  colorCelda =
                  index == indiceBomba ? cons.bomba : cons.seguro;
                }
                return Expanded(
                  child: InkWell(
                    onTap: () => _manejarTap(fila, columna),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorCelda,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
