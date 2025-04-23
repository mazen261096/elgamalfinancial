import 'package:moneytrack/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../resources/pdfExport.dart';

class PdfPreviewCollection extends StatelessWidget {
  final List<Transactions> trans;
  final List<String> filterWallets;
  final List<String> filterCategory;
  final List<String> filterName;
  final DateTime? filterAfter;
  final DateTime? filterBefore;
  final int total;

  const PdfPreviewCollection(
      {super.key,
      required this.trans,
      required this.filterWallets,
      required this.filterCategory,
      required this.filterName,
      required this.filterAfter,
      required this.filterBefore,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdfCollection(
            trans: trans,
            filterWallets: filterWallets,
            filterCategory: filterCategory,
            filterName: filterName,
            filterAfter: filterAfter,
            filterBefore: filterBefore,
            total: total),
      ),
    );
  }
}
