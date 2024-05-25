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
    double perdaVswr = ((vswr - 1) / (vswr + 1)) * ((vswr - 1) / (vswr + 1));
    double resultadoGanhoEmissoraRevisada = ganho - (ganho * perdaVswr);
    double perdaCaboConectores = (0.5 * cabo) + 0.4;
    double eirpCalculado =
        (potencia + resultadoGanhoEmissoraRevisada) - perdaCaboConectores;
    double eirp = (pow(10, eirpCalculado / 10)) / 1000;
    double dbWatt = (pow(10, sensibilidade / 10)) / 1000;
    double etag = ((4 * pi) / 0.328) * (sqrt(30 * dbWatt));
    double distanciaMaximaLeitura = sqrt(30 * eirp) / etag;

    return distanciaMaximaLeitura;
  }
}
