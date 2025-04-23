import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/transaction.dart';
import 'assets_manager.dart';

Future<Uint8List> makePdf(Transactions trans) async {
  final pdf = pw.Document();
  final imageLogo = pw.MemoryImage(
    (await rootBundle.load(ImageAssets.logoBlack)).buffer.asUint8List(),
  );
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load(FontsAssets.pdfFont)),
    bold: pw.Font.ttf(await rootBundle.load(FontsAssets.pdfFontBold)),
  );
  pw.Widget image =
       pw.SizedBox();

  pdf.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        margin: pw.EdgeInsets.all(10),
        theme: theme,
        pageFormat: PdfPageFormat.a4,
      ),
      build: (context) {
        return pw.Container(
          width: double.infinity,
          height: double.infinity,
          padding: pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
          child: pw.Column(
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    height: 150,
                    width: 150,
                    child: pw.Center(
                      child: pw.Text(
                        trans.walletName,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: 200,
                    width: 200,
                    child: pw.Image(imageLogo),
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  rowTitlesTable(
                    name: 'Name',
                    date: 'Date',
                    category: 'Category',
                    amount: 'Amount',
                    description: 'Description',
                  ),
                  rowTable(
                    name: trans.name,
                    description: trans.description,
                    date: DateFormat(
                      'yyyy-MM-dd',
                      'en',
                    ).format(trans.createdAt),
                    category: trans.category,
                    amount: trans.amount,
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              image,
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}

pw.TableRow rowTable({
  required String name,
  required String date,
  required String category,
  required var amount,
  required String description,
}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          name,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          date,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          category,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Container(
        constraints: pw.BoxConstraints(maxWidth: 170),
        child: pw.Text(
          description,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          NumberFormat('###,###,###', 'en').format(amount),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

pw.TableRow rowTitlesTable({
  required String name,
  required String date,
  required String category,
  required var amount,
  required String description,
}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          name,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          date,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          category,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          description,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          amount.toString(),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

pw.TableRow rowTotalTable({required var total}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          'Total',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          NumberFormat('###,###,###', 'en').format(total),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

pw.TableRow rowTableAll({
  required String name,
  required String date,
  required String category,
  required String walletName,
  required var amount,
  required String description,
}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          name,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          date,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          category,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),

      pw.Padding(
        child: pw.Text(
          walletName,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          NumberFormat('###,###,###', 'en').format(amount),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

pw.TableRow rowTitlesTableAll({
  required String name,
  required String date,
  required String category,
  required String walletName,
  required var amount,
  required String description,
}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          name,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          date,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          category,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          walletName,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          amount.toString(),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

pw.TableRow rowTotalTableAll({required var total}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),

      pw.Padding(
        child: pw.Text(
          '',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          'Total',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
      pw.Padding(
        child: pw.Text(
          NumberFormat('###,###,###', 'en').format(total),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
        ),
        padding: pw.EdgeInsets.all(10),
      ),
    ],
  );
}

Future<Uint8List> makePdfCollection({
  required List<Transactions> trans,
  required List<String> filterWallets,
  required List<String> filterCategory,
  required List<String> filterName,
  required DateTime? filterAfter,
  required DateTime? filterBefore,
  required int total,
}) async {
  final imageLogo = pw.MemoryImage(
    (await rootBundle.load(ImageAssets.logoBlack)).buffer.asUint8List(),
  );

  const pageSize = 20;
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load(FontsAssets.pdfFont)),
    bold: pw.Font.ttf(await rootBundle.load(FontsAssets.pdfFontBold)),
  );

  Map<int, List<pw.TableRow>> rows = {};

  final numberOfPages = (trans.length / pageSize).ceil();
  //add header to all pages
  for (var page = 0; page < numberOfPages; page++) {
    rows[page] =
        filterWallets.length == 1
            ? [
              rowTitlesTable(
                name: 'Name',
                date: 'Date',
                category: 'Category',
                amount: 'Amount',
                description: 'Description',
              ),
            ]
            : [
              rowTitlesTableAll(
                name: 'Name',
                date: 'Date',
                category: 'Category',
                walletName: 'Wallet Name',
                amount: 'Amount',
                description: 'Description',
              ),
            ];

    var loopLimit = trans.length - (trans.length - ((page + 1) * pageSize));

    if (loopLimit > trans.length) loopLimit = trans.length;

    for (var index = pageSize * page; index < loopLimit; index++) {
      filterWallets.length == 1
          ? rows[page]!.add(
            rowTable(
              name: trans[index].name,
              description: trans[index].description,
              date: DateFormat(
                'yyyy-MM-dd',
                'en',
              ).format(trans[index].createdAt),
              category: trans[index].category,
              amount: trans[index].amount,
            ),
          )
          : rows[page]!.add(
            rowTableAll(
              name: trans[index].name,
              description: trans[index].description,
              date: DateFormat(
                'yyyy-MM-dd',
                'en',
              ).format(trans[index].createdAt),
              category: trans[index].category,
              walletName: trans[index].walletName,
              amount: trans[index].amount,
            ),
          );
      if (page + 1 == numberOfPages && index + 1 == loopLimit) {
        filterWallets.length == 1
            ? rows[page]!.add(rowTotalTable(total: total))
            : rows[page]!.add(rowTotalTableAll(total: total));
      }
    }
  }

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(10),
        theme: theme,
        pageFormat: PdfPageFormat.a4,
      ),
      maxPages: 100,
      build: (context) {
        return List<pw.Widget>.generate(rows.keys.length, (index) {
          return pw.Column(
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (filterWallets.length == 1)
                    pw.SizedBox(
                      width: 120,
                      height: 120,
                      child: pw.Center(
                        child: pw.Text(
                          filterWallets.first,
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ),
                  pw.SizedBox(
                    height: 150,
                    width: 150,
                    child: pw.Image(imageLogo),
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColor.fromHex("#000000")),
                children: rows[index]!,
              ),
            ],
          );
        });
      },
    ),
  );
  return pdf.save();
}
