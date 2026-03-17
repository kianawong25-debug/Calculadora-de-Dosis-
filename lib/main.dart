import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DosisApp());
}

class DosisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculadora de Dosis",
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Color(0xFFF2F6FB),

        primaryColor: Color(0xFF0B3C5D),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0B3C5D),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0B3C5D),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFFB0C4DE),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFF0B3C5D),
              width: 2,
            ),
          ),
        ),
      ),
      home: DosisScreen(),
    );
  }
}

class DosisScreen extends StatefulWidget {
  @override
  _DosisScreenState createState() => _DosisScreenState();
}

class _DosisScreenState extends State<DosisScreen> {

  int tipoPaciente = 1;
  int tipoMedicamento = 1;

  final pesoController = TextEditingController();
  final dosisMgKgController = TextEditingController();
  final dosisFijaController = TextEditingController();
  final dosisPorDiaController = TextEditingController();
  final diasController = TextEditingController();
  final mgFrascoController = TextEditingController();
  final mlEquivalenteController = TextEditingController();
  final contenidoFrascoController = TextEditingController();
  final mgTabletaController = TextEditingController();

  String resultado = "";

  void calcular() {
    try {

      double mgPorDosis = 0;

      if (tipoPaciente == 1) {
        double peso = double.parse(pesoController.text);
        double dosisMgKg = double.parse(dosisMgKgController.text);
        mgPorDosis = peso * dosisMgKg;
      } else {
        mgPorDosis = double.parse(dosisFijaController.text);
      }

      int dosisPorDia = int.parse(dosisPorDiaController.text);
      int dias = int.parse(diasController.text);

      if (tipoMedicamento == 1) {

        double mgFrasco = double.parse(mgFrascoController.text);
        double mlEquivalente = double.parse(mlEquivalenteController.text);
        double contenidoFrasco = double.parse(contenidoFrascoController.text);

        double mlPorDosis = (mgPorDosis * mlEquivalente) / mgFrasco;
        double totalMl = mlPorDosis * dosisPorDia * dias;

        int frascos = (totalMl / contenidoFrasco).ceil();

        setState(() {
          resultado =
              "mL por dosis: ${mlPorDosis.toStringAsFixed(2)}\n"
              "Total mL: ${totalMl.toStringAsFixed(2)}\n"
              "Frascos necesarios: $frascos";
        });

      } else {

        double mgTableta = double.parse(mgTabletaController.text);

        double tabletasPorDosis = mgPorDosis / mgTableta;
        int totalTabletas =
            (tabletasPorDosis * dosisPorDia * dias).ceil();

        setState(() {
          resultado =
              "Tabletas por dosis: ${tabletasPorDosis.toStringAsFixed(2)}\n"
              "Total tabletas: $totalTabletas";
        });
      }

    } catch (e) {
      setState(() {
        resultado = "Completa todos los campos correctamente.";
      });
    }
  }

  Widget campo(String texto, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: texto,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de Dosis"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Center(
              child: Image.asset(
                "assets/images/intento.png",
                height: 120,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Tipo de paciente",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 8),

            DropdownButton<int>(
              value: tipoPaciente,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 1, child: Text("Niño")),
                DropdownMenuItem(value: 2, child: Text("Adulto")),
              ],
              onChanged: (value) {
                setState(() {
                  tipoPaciente = value!;
                });
              },
            ),

            SizedBox(height: 15),

            if (tipoPaciente == 1) ...[
              campo("Peso (kg)", pesoController),
              campo("Dosis (mg/kg)", dosisMgKgController),
            ] else ...[
              campo("Dosis fija (mg)", dosisFijaController),
            ],

            campo("Dosis por día", dosisPorDiaController),
            campo("Días de tratamiento", diasController),

            SizedBox(height: 20),

            Text(
              "Tipo de medicamento",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 8),

            DropdownButton<int>(
              value: tipoMedicamento,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 1, child: Text("Jarabe")),
                DropdownMenuItem(value: 2, child: Text("Tabletas")),
              ],
              onChanged: (value) {
                setState(() {
                  tipoMedicamento = value!;
                });
              },
            ),

            SizedBox(height: 15),

            if (tipoMedicamento == 1) ...[
              campo("mg del frasco", mgFrascoController),
              campo("mL equivalentes", mlEquivalenteController),
              campo("Contenido del frasco (mL)", contenidoFrascoController),
            ] else ...[
              campo("mg por tableta", mgTabletaController),
            ],

            SizedBox(height: 25),

            ElevatedButton(
              onPressed: calcular,
              child: Text("Calcular"),
            ),

            SizedBox(height: 25),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFB0C4DE),
                ),
              ),
              child: Text(
                resultado,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B3C5D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
