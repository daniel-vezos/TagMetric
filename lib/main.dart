import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'graph.dart';
import 'calc_dist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 250, 250, 250)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simulador de Leituras TAGS RFID UHF'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _distanciaMaximaLeitura = 0;

  final _frequencia = TextEditingController();
  final _potencia = TextEditingController();
  final _ganho = TextEditingController();
  final _vswr = TextEditingController();
  final _cabo = TextEditingController();
  final _sensibilidade = TextEditingController();

  double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      // Tratar o erro ou retornar um valor padrão
      return 0.0;
    }
  }

  @override
  void dispose() {
    _frequencia.dispose();
    _potencia.dispose();
    _ganho.dispose();
    _vswr.dispose();
    _cabo.dispose();
    _sensibilidade.dispose();
    super.dispose();
  }

  void _calcularDistanciaMaximaLeitura() {
    var calculadora = Calculadora(
      frequencia: parseDouble(_frequencia.text),
      potencia: parseDouble(_potencia.text),
      ganho: parseDouble(_ganho.text),
      vswr: parseDouble(_vswr.text),
      cabo: parseDouble(_cabo.text),
      sensibilidade: parseDouble(_sensibilidade.text),
    );

    setState(() {
      _distanciaMaximaLeitura = calculadora.calculoMetros();
    });
  }

  void _limparCampos() {
    setState(() {
      _frequencia.clear();
      _potencia.clear();
      _ganho.clear();
      _vswr.clear();
      _cabo.clear();
      _sensibilidade.clear();
      _distanciaMaximaLeitura = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
          const Text(
            "Preencha os campos a seguir",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 5,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Frequência"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _frequencia,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'MHz',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Potência do leitor (max)"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _potencia,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'dBm',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ganho antena"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _ganho,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'dBi',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("VSWR antena"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _vswr,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '%',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Comprimento cabo da antena"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _cabo,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'mts',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sensibilidade CI tag"),
                      const SizedBox(width: 10),
                      Container(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          controller: _sensibilidade,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'dBm',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calcularDistanciaMaximaLeitura,
                    child: const Text("Calcular"),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Distância máxima de leitura: ${_distanciaMaximaLeitura.toStringAsFixed(1)}m",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_frequencia.text.isNotEmpty &&
                                _potencia.text.isNotEmpty &&
                                _ganho.text.isNotEmpty &&
                                _vswr.text.isNotEmpty &&
                                _cabo.text.isNotEmpty &&
                                _sensibilidade.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LineChartPage(
                                      frequencia:
                                          double.parse(_frequencia.text),
                                      potencia: double.parse(_potencia.text),
                                      ganho: double.parse(_ganho.text),
                                      vswr: double.parse(_vswr.text),
                                      cabo: double.parse(_cabo.text),
                                      sensibilidade:
                                          double.parse(_sensibilidade.text)),
                                ),
                              );
                            } else {
                              // Mostrar algum aviso para o usuário preencher todos os campos
                            }
                          },
                          child: Text('Gráfico'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _limparCampos,
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
