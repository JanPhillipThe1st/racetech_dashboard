import 'package:flutter/material.dart';
import "package:mobile_scanner/mobile_scanner.dart";
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class ScanRacerQR extends StatefulWidget {
  const ScanRacerQR({Key? key}) : super(key: key);

  @override
  _ScanRacerQRState createState() => _ScanRacerQRState();
}

List<Barcode> _barcodes = [];

class _ScanRacerQRState extends State<ScanRacerQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Racer"),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onScannerStarted: (args) {},
            onDetect: (BarcodeCapture capture) {
              _barcodes = capture.barcodes;
              for (final barcode in _barcodes) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    dismissDirection: DismissDirection.horizontal,
                    content: Text(barcode.rawValue!),
                  ),
                );
              }
            },
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Color.fromARGB(123, 30, 59, 85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: DefaultText(
                          text: "Scanning QR...",
                          fontSize: 16,
                          fontFamily: "MontserratBold",
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color.fromARGB(123, 30, 59, 85),
                  child: SizedBox(
                    width: 350,
                    height: 2,
                    child: LinearProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
