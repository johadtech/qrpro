import 'splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/qrScanner': (context) => QRViewExample(),
      },
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                final barcode = barcodeCapture.barcodes.first;
                final String? code = barcode.rawValue;
                if (code == null) {
                  debugPrint('Failed to scan Barcode');
                } else {
                  debugPrint('Barcode found! $code');
                  setState(() {
                    qrText = code;
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (qrText != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Scanned QR Code: $qrText'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (qrText != null) {
                        Clipboard.setData(ClipboardData(text: qrText!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to clipboard')),
                        );
                      }
                    },
                    child: Text('Copy to Clipboard'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
