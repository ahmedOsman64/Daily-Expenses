import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../models/expense.dart';
import '../../../models/income.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateReport({
    required String userName,
    required String period,
    required double totalIncome,
    required double totalExpenses,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) async {
    final pdf = pw.Document();

    final dateStr = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    final balance = totalIncome - totalExpenses;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Daily Expenses Report',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Generated on: $dateStr',
                        style: const pw.TextStyle(color: PdfColors.grey700)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('User: $userName',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Period: $period',
                        style: const pw.TextStyle(color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 32),

            // Financial Summary Card
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Total Income', '\$${totalIncome.toStringAsFixed(2)}', PdfColors.green700),
                  _summaryItem('Total Expenses', '\$${totalExpenses.toStringAsFixed(2)}', PdfColors.red700),
                  _summaryItem('Net Balance', '\$${balance.toStringAsFixed(2)}', balance >= 0 ? PdfColors.blue700 : PdfColors.red700),
                ],
              ),
            ),
            pw.SizedBox(height: 32),

            // Transactions Table
            pw.Text('Transaction Details',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
              },
              headers: ['Date', 'Title', 'Type', 'Amount'],
              data: [
                ...incomes.map((i) => [
                      DateFormat('yyyy-MM-dd').format(i.date),
                      i.title,
                      'Income',
                      '+\$${i.amount.toStringAsFixed(2)}'
                    ]),
                ...expenses.map((e) => [
                      DateFormat('yyyy-MM-dd').format(e.date),
                      e.title,
                      'Expense',
                      '-\$${e.amount.toStringAsFixed(2)}'
                    ]),
              ],
              cellStyle: const pw.TextStyle(fontSize: 10),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
              ),
            ),
            
            pw.SizedBox(height: 40),
            pw.Divider(color: PdfColors.grey400),
            pw.Center(
              child: pw.Text('Thank you for using Daily Expenses!',
                  style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10)),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Expenses_Report_${period}_$userName.pdf',
    );
  }

  static pw.Widget _summaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }
}
