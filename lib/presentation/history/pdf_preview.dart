import 'package:moneytrack/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../resources/pdfExport.dart';

class PdfPreviewPage extends StatelessWidget {
  final Transactions trans;

  const PdfPreviewPage({super.key, required this.trans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(trans),
      ),
    );
  }
}
