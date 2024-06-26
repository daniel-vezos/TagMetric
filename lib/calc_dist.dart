import 'dart:math';

class Calculadora {
  double frequencia;
  double potencia;
  double ganho;
  double vswr;
  double cabo;
  double sensibilidade;

  Calculadora({
    required this.frequencia,
    required this.potencia,
    required this.ganho,
    required this.vswr,
    required this.cabo,
    required this.sensibilidade,
  });

  double calculoMetros() {
    //((C9-1)/(C9+1))^2
    // double perdaVswr = ((vswr - 1) / (vswr + 1)) * ((vswr - 1) / (vswr + 1));

    double perdaVswr = pow((vswr - 1) / (vswr + 1), 2).toDouble();

    double perdaVswr2 = 10 * (perdaVswr > 0 ? log(1 - perdaVswr) / log(10) : 0);

    double resultadoGanhoEmissoraRevisada = ganho - perdaVswr2.abs();

    double perdaCaboConectores = (0.5 * cabo) + 0.4;

    double eirpCalculado =
        (potencia + resultadoGanhoEmissoraRevisada) - perdaCaboConectores;

    double eirp = (pow(10, eirpCalculado / 10)) / 1000;

    double dbWatt = (pow(10, sensibilidade / 10)) / 1000;

    double etag = ((4 * pi) / 0.328) * (sqrt(30 * dbWatt));

    double distanciaMaximaLeitura = sqrt(30 * eirp) / etag;
    // double distanciaMaximaLeitura = etag;

    return distanciaMaximaLeitura;
  }
}
