import 'package:intl/intl.dart';

class CurrencyUtils {
  static String formatToRupiah(int amount, {String symbol = 'Rp'}) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0, // No decimal places for Rupiah
    );
    return formatCurrency.format(amount);
  }
}