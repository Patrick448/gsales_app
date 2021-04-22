import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String formatDateFromMillisseconds(int millisseconds) {
  initializeDateFormatting("pt_BR");
  DateFormat format = DateFormat('dd/MM/yyy');
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisseconds);

  String dateString = format.format(dateTime);

  return dateString;
}

String formatDate(DateTime date) {
  initializeDateFormatting("pt_BR");
  DateFormat format = DateFormat('dd/MM/yyy');
  String dateString = format.format(date);

  return dateString;
}

String formatCurrencyReal(double value) {
  NumberFormat format = NumberFormat.currency(locale: 'pt_BR', symbol: "R\$");
  String formattedString = format.format(value);
  return formattedString;
}
