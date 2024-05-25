import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class LineChartPage extends StatelessWidget {
  final double frequencia;
  final double potencia;
  final double ganho;
  final double vswr;
  final double cabo;
  final double sensibilidade;

  const LineChartPage({
    Key? key,
    required this.frequencia,
    required this.potencia,
    required this.ganho,
    required this.vswr,
    required this.cabo,
    required this.sensibilidade,
  }) : super(key: key);

  double perdaCabos() {
    double perdaCaboConectores = (0.5 * cabo) + 0.4;
    return perdaCaboConectores;
  }

  double ganhoAntena() {
    double perdaVswr = ((vswr - 1) / (vswr + 1)) * ((vswr - 1) / (vswr + 1));
    double resultadoGanhoEmissoraRevisada = ganho - (ganho * perdaVswr);
    return resultadoGanhoEmissoraRevisada;
  }

  double calc_etag() {
    double dbWatt = (pow(10, sensibilidade / 10)) / 1000;
    double etag = ((4 * pi) / 0.328) * (sqrt(30 * dbWatt));
    return etag;
  }

  List<double> calc_eirp() {
    List<double> eirpList = [];
    for (int i = 9; i <= 33; i++) {
      double eirp = i + ganhoAntena() - perdaCabos();
      eirpList.add(eirp);
    }
    return eirpList;
  }

  List<double> calc_watt() {
    List<double> wattList = [];
    for (double eirp in calc_eirp()) {
      double watt_transmitido = (pow(10, eirp / 10)) / 1000;
      wattList.add(watt_transmitido);
    }
    return wattList;
  }

  List<double> d() {
    List<double> dList = [];
    for (double watt in calc_watt()) {
      double d_teorica = sqrt(30 * watt) / calc_etag();
      dList.add(d_teorica);
    }
    return dList;
  }

  @override
  Widget build(BuildContext context) {
    List<double> dValues = d();
    double minD = dValues.isNotEmpty ? dValues.first : 0.0;
    double maxD = dValues.isNotEmpty ? dValues.reduce(max) + 1 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distância máxima leitura x Potência leitor '),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.97,
          height: MediaQuery.of(context).size.height * 1,
          child: AspectRatio(
            aspectRatio: 1,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final flSpot = touchedSpot;
                        if (flSpot.x == null || flSpot.y == null) {
                          return null;
                        }

                        // Aqui você pode arredondar o valor de x e y como desejar
                        final value = '${flSpot.y.toStringAsFixed(2)}';
                        return LineTooltipItem(
                          value,
                          TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (int i = 0; i < dValues.length; i++)
                        FlSpot(i + 9, dValues[i]),
                    ],
                    isCurved: true,
                    dotData: FlDotData(show: true),
                    color: Colors.black,
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color.fromARGB(255, 93, 93, 93)
                          .withOpacity(0.7),
                    ),
                  )
                ],
                minX: 9,
                maxX: 34,
                minY: minD,
                maxY: maxD,
                backgroundColor: Colors.white,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = '0';
                            break;
                          case 1:
                            text = '6';
                            break;
                          case 2:
                            text = '9';
                            break;
                        }
                        return Text(text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color.fromARGB(255, 86, 86, 86),
                      strokeWidth: 0.5),
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.amberAccent, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
